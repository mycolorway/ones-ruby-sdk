require 'http'

module Ones
  module Requests
    class Base
      RETRY_OPTIONS = {
        max_tries: 5,
        base_sleep_seconds: 0.5,
        max_sleep_seconds: 3.0,
        rescue: [Ones::InternalError, Ones::ServerError, HTTP::TimeoutError]
      }.freeze

      attr_reader :client, :ssl_context, :http

      def initialize(client, skip_verify_ssl = true)
        @client = client
        @http = HTTP.timeout(**Ones.http_timeout_options)
        @ssl_context = OpenSSL::SSL::SSLContext.new
        @ssl_context.verify_mode = OpenSSL::SSL::VERIFY_NONE if skip_verify_ssl
      end

      def get(path, get_header = {})
        raise NotImplementedError
      end

      def post(path, post_body, post_header = {})
        raise NotImplementedError
      end

      def request_uuid_in_header?
        true
      end

      def api_mode
        self.class.name.demodulize
      end

      def handle_response(request_uuid, response, as)
        Ones.logger.info "[#{request_uuid}][#{api_mode}] response headers: #{response.headers.inspect}"

        unless response.status.success?
          Ones.logger.error "[#{request_uuid}][#{api_mode}] happen error #{response.code}: #{response.body}"
          raise ResponseError.new(response.status, response.body)
        end

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
          Ones.logger.info "[#{request_uuid}][#{api_mode}] response body: #{body}"
          parse_as_json(body)
        else
          body
        end
      end

      private

      def parse_as_json(body)
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
  end
end
