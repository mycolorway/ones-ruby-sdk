require "test_helper"

class OnesTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Ones::VERSION
  end

  def test_it_does_requests_successfully
    Ones::Api.default.app_center.check_user('user_uuid', 'token')
  end
end
