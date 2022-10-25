require 'ones/requests/base'

module Ones
  module Requests
    class ApiRequest < Base
      def get(path, get_header = {})
        request(:get, path, get_header) do |url, header|
          http.headers(header).get(url, ssl_context: ssl_context)
        end
      end

      def post(path, post_body, post_header = {})
        request(:post, path, post_header) do |url, header|
          Ones.logger.info "[#{header['X-Request-ID']}][#{api_mode}] payload: #{post_body}"
          http.headers(header).post(url, json: post_body, ssl_context: ssl_context)
        end
      end

      private

      def request(http_method, path, header = {}, &_block)
        base_query = header.delete(:params) || {}

        ones_user_uuid = header.delete(:ones_user_uuid) || client.client_id
        ones_auth_token = header.delete(:ones_auth_token) || client.client_secret

        url = if base_query.present?
                URI.join(Ones.api_base_url, "#{path}?#{base_query.to_query}")
              else
                URI.join(Ones.api_base_url, path)
              end
        as = header.delete(:as)
        header['Content-Type'] = 'application/json'
        header['Ones-User-Id'] = ones_user_uuid
        header['Ones-Auth-Token'] = ones_auth_token

        with_retries RETRY_OPTIONS do |attempts|
          request_uuid = SecureRandom.uuid
          header['X-Request-ID'] = request_uuid

          Ones.logger.info "[#{request_uuid}][#{api_mode}] #{http_method.upcase} request ( #{url} ) in attempts: #{attempts}"
          Ones.logger.info "[#{request_uuid}][#{api_mode}] headers: #{header}"

          response = yield(url, header)

          handle_response(request_uuid, response, as || :json)
        end
      end
    end
  end
end
