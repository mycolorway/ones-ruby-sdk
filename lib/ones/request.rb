require 'http'
require 'core_ext/object/to_ones_query'

module Ones
  class Request
    RETRY_OPTIONS = {
      max_tries: 5,
      base_sleep_seconds: 0.5,
      max_sleep_seconds: 3.0,
      rescue: [Ones::InternalError, Ones::ServerError, HTTP::TimeoutError]
    }.freeze

    attr_reader :ssl_context, :http

    def initialize(skip_verify_ssl = true)
      @http = HTTP.timeout(**Ones.http_timeout_options)
                  .basic_auth(user: Ones.client_id, pass: Ones.client_secret)
      @ssl_context = OpenSSL::SSL::SSLContext.new
      @ssl_context.verify_mode = OpenSSL::SSL::VERIFY_NONE if skip_verify_ssl
    end

    def get(path, get_header = {})
      request(:get, path, get_header) do |url, header|
        http.headers(header).get(url, ssl_context: ssl_context)
      end
    end

    def post(path, post_body, post_header = {})
      request(:post, path, post_header, post_body) do |url, header|
        http.headers(header).post(url, json: post_body, ssl_context: ssl_context)
      end
    end

    def request_uuid_in_header?
      true
    end

    private

    def request(http_method, path, header = {}, body = {},  &_block)
      base_query = header.delete(:params) || {}
      as = header.delete(:as)

      header['Accept'] = 'application/json'

      with_retries RETRY_OPTIONS do |attempts|
        request_uuid = SecureRandom.uuid
        header['X-Request-ID'] = request_uuid if request_uuid_in_header?

        Ones.logger.info "[#{request_uuid}] #{http_method.upcase} request ( #{path} ) in attempts: #{attempts}"

        ts = Time.current.to_i
        sign = Ones::Helper.generate_signature(request_uuid, http_method, ts, path, base_query, header, body)
        query = base_query.merge(client_id: Ones.client_id, ts: ts, sign: sign).to_query
        url = URI.join(Ones.api_base_url, "#{path}?#{query}")

        Ones.logger.info "[#{request_uuid}] url: #{url}"
        Ones.logger.info "[#{request_uuid}] headers: #{header}"
        Ones.logger.info "[#{request_uuid}] payload: #{body}"

        response = yield(url, header)

        if response.status.success?
          handle_response(response, as || :json)
        elsif response.status.server_error?
          raise Ones::ServerError
        else
          Ones.logger.error "[#{request_uuid}] happen error: #{response.body}"
          raise ResponseError.new(response.status, response.body)
        end
      end
    end

    def handle_response(response, as)
      content_type = response.headers[:content_type]
      parse_as = {
        %r{^application\/json} => :json,
        %r{^image\/.*} => :file
      }.each_with_object([]) { |match, memo| memo << match[1] if content_type =~ match[0] }.first || as || :text

      body = response.body
      case parse_as
      when :file
        parse_as_file(body)
      when :json
        parse_as_json(body)
      else
        body
      end
    end

    def parse_as_json(body)
      Ones.logger.info "response body: #{body}"
      data = JSON.parse body.to_s
      result = Result.new(data)

      raise ::Ones::AccessTokenExpiredError if result.access_token_expired?

      result
    end

    def parse_as_file(body)
      file = Tempfile.new('tmp')
      file.binmode
      file.write(body)
      file.close

      file
    end
  end

  class Result
    attr_reader :code, :data

    def initialize(data)
      @code = data['code'].to_i rescue 0
      @data = data
    end

    def access_token_expired?
      [401].include?(code) && data.fetch('type') == 'AuthFailure'
    end

    def success?
      code.zero?
    end
  end
end
