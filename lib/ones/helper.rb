module Ones
  class Helper
    class << self
      def generate_signature(request_uuid, http_method, ts, path, base_query, header, body)
        header = header.reject { |k, _v| %w[Accept].include?(k) }
        params = base_query.merge(header).merge(body)
        string_to_sign = [
          Ones.client_id,
          ts,
          http_method.upcase,
          "/#{path}",
          params.to_ones_query,
          Ones.client_secret
        ].join('|')
        Ones.logger.info "[#{request_uuid}] string to sign: #{string_to_sign}"
        OpenSSL::HMAC.hexdigest('SHA1', Ones.client_secret, string_to_sign)
      end
    end
  end
end
