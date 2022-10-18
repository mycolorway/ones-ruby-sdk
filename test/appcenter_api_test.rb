require 'test_helper'

class AppcenterApiTest < Minitest::Test
  def test_check_user_api
    response_body = {
      "uuid": "DU6krHBN",
      "email": "niuqiang@ones.cn",
      "name": "会飞的犀牛长",
      "name_pinyin": "hui4fei1dexi1niu2zhang3",
      "title": "",
      "avatar": "",
      "phone": "",
      "create_time": 1565770697227728,
      "access_time": 0,
      "status": 1,
      "org_uuid": "AbsatFo2",
      "language": "zh"
    }
    stub_request(:post, %r[/appcenter/check_user]).to_return(status: 200, body: response_body.to_json)
    result = Ones::Api.default.app_center.check_user('user_uuid', 'token')
    assert_equal 'DU6krHBN', result.data.dig('uuid')
  end
end
