module Ones
  # Errors
  class RedisNotConfigError < RuntimeError; end
  class AppNotConfigError < RuntimeError; end
  class AccessTokenExpiredError < RuntimeError; end
  class ResultError < RuntimeError; end
  class InternalError < RuntimeError; end
  class ServerError < RuntimeError; end
  class ResponseError < StandardError
    attr_reader :error_code
    def initialize(errcode, errmsg='')
      @error_code = errcode
      super "(#{error_code}) #{errmsg}"
    end
  end
end
