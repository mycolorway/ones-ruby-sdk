require 'retries'
require 'active_support/all'
require "#{File.dirname(__FILE__)}/core_ext/object/to_ones_query.rb"

require 'ones/version'
require 'ones/config'
require 'ones/api_mount'
require 'ones/error'
require 'ones/helper'

lib_path = "#{File.dirname(__FILE__)}/ones"
Dir["#{lib_path}/apis/**/*.rb", "#{lib_path}/requests/**/*.rb"].each { |path| require path }

require 'ones/api'
