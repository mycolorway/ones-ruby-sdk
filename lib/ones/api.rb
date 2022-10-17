require 'ones/request'

module Ones
  class Api
    include ApiMount

    api_mount :app_center

    attr_reader :options

    def initialize(options = {})
      @options = options
    end

    def request
      @request ||= Ones::Request.new
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
        @default ||= new
      end
    end
  end
end
