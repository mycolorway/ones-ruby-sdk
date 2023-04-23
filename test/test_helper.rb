$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "ones"

require "minitest/autorun"
require 'webmock/minitest'

Ones.configure do |config|
  config.default_client_id     = 'some_client_id'
  config.default_client_secret = 'this_is_a_client_secret'
  config.app_center_base_url   = 'http://localhost:3002/project/api/project/'

  config.api_base_url          = 'http://localhost:3002/project/api/'

  config.http_timeout_options  = { write: 2, connect: 5, read: 15 }
end

$ones_api = Ones::Api.new(client_id: :user_id, client_secret: :user_token, mode: :api)
