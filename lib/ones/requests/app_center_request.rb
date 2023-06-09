require 'core_ext/object/to_ones_query'
require 'ones/requests/base'

module Ones
  module Requests
    class AppCenterRequest < Base
      def initialize(client, skip_verify_ssl: true, http_proxy: nil)
        super(client, skip_verify_ssl: skip_verify_ssl, http_proxy: http_proxy)
        @http = @http.basic_auth(user: client.client_id, pass: client.client_secret)
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

      private

      def request(http_method, path, header = {}, body = {}, &_block)
        base_query = header.delete(:params) || {}
        as = header.delete(:as)

        header['Accept'] = 'application/json'

        with_retries RETRY_OPTIONS do |attempts|
          request_uuid = SecureRandom.uuid
          header['X-Request-ID'] = request_uuid if request_uuid_in_header?

          Ones.logger.info "[#{request_uuid}][#{api_mode}] #{http_method.upcase} request ( #{path} ) in attempts: #{attempts}"

          ts = Time.current.to_i
          string_to_sign, sign = Ones::Helper.generate_signature(client, http_method, ts, path, base_query, header, body)
          query = base_query.merge(client_id: client.client_id, ts: ts, sign: sign).to_query
          url = URI.join(Ones.app_center_base_url, "#{path}?#{query}")

          Ones.logger.info "[#{request_uuid}][#{api_mode}] string to sign: #{string_to_sign}"
          Ones.logger.info "[#{request_uuid}][#{api_mode}] url: #{url}"
          Ones.logger.info "[#{request_uuid}][#{api_mode}] headers: #{header}"
          Ones.logger.info "[#{request_uuid}][#{api_mode}] payload: #{body}"

          response = yield(url, header)

          handle_response(request_uuid, response, as || :json)
        end
      end
    end
  end
end
