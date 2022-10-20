module Ones
  module Requests
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
end
