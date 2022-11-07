module Ones
  class Helper
    class << self
      def generate_signature(client, http_method, ts, path, base_query, header, body)
        # 10-27 日讨论，header 不参与签名运算
        header = defined?(Rails) ? {} : header.reject { |k, _v| %w[Accept].include?(k) }
        params = base_query.merge(header).merge(body)
        string_to_sign = [
          client.client_id,
          ts,
          http_method.upcase,
          "/#{path}",
          params.to_ones_query,
          client.client_secret
        ].join('|')
        [string_to_sign, OpenSSL::HMAC.hexdigest('SHA1', client.client_secret, string_to_sign)]
      end
    end
  end
end
