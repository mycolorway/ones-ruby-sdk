$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "ones"

require "minitest/autorun"

Ones.configure do |config|
  config.default_client_id     = 'tes_ones_client_id'
  config.default_client_secret = 'tes_ones_client_secret'
  config.api_base_url          = 'http://localhost:3001'

  config.http_timeout_options  = { write: 2, connect: 5, read: 15 }
end
