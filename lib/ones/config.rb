require 'logger'
require 'uri'

module Ones
  class << self
    def configure
      yield config
    end

    def config
      @config ||= Config.new
    end

    def logger
      @logger ||= if config.logger.nil?
                    defined?(Rails) && Rails.logger ? Rails.logger : Logger.new(STDOUT)
                  else
                    config.logger
                  end
    end

    def http_timeout_options
      config.http_timeout_options || { write: 2, connect: 5, read: 10 }
    end

    def api_base_url
      return @api_base_url if defined?(@api_base_url)

      @api_base_url = config.api_base_url.presence || raise(AppNotConfigError)
    end

    def client_id
      return @client_id if defined?(@client_id)

      @client_id = config.default_client_id.presence || raise(AppNotConfigError)
    end

    def client_secret
      return @client_secret if defined?(@client_secret)

      @client_secret = config.default_client_secret.presence || raise(AppNotConfigError)
    end

    def app_center_base_url
      return @app_center_base_url if defined?(@app_center_base_url)

      @app_center_base_url = config.app_center_base_url.presence || raise(AppNotConfigError)
    end

    def http_proxy
      return @http_proxy if defined?(@http_proxy)

      @http_proxy = if config.http_proxy_uri.present?
                      uri = URI.parse(config.http_proxy_uri)
                      { host: uri.host, port: uri.port, user: uri.user, password: uri.password }.compact
                    end
    end
  end

  class Config
    attr_accessor :default_client_id, :default_client_secret, :app_center_base_url, :api_base_url, :http_timeout_options, :logger, :http_proxy_uri
  end
end
