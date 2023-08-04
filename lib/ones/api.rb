module Ones
  class Api
    include ApiMount

    api_mount :app_center
    api_mount :org
    api_mount :user
    api_mount :team
    api_mount :department
    api_mount :attachment
    api_mount :auth
    api_mount :task
    api_mount 'wiki/team'
    api_mount 'wiki/space'
    api_mount 'wiki/page'

    attr_reader :client_id, :client_secret, :mode, :options, :http_proxy

    def initialize(options = {})
      @client_id = options.delete(:client_id) || Ones.client_id
      @client_secret = options.delete(:client_secret) || Ones.client_secret
      @mode = options.delete(:mode) || :app_center
      @http_proxy = options.delete(:http_proxy) || Ones.http_proxy
      @options = options
    end

    def request
      @request ||= "Ones::Requests::#{@mode.to_s.camelize}Request".constantize.new(self, http_proxy: http_proxy)
    end

    def get(path, headers = {})
      request.get path, headers
    end

    def post(path, payload = {}, headers = {})
      request.post path, payload, headers
    end

    private

    class << self
      def default
        @default ||= new(mode: :app_center)
      end
    end
  end
end
