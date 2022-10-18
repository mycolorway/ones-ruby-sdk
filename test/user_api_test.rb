require 'test_helper'

class UserApiTest < Minitest::Test
  def test_list_api
    response_body = {
      "xxxxyyyy": {
        "uuid": "DU6krHBN0",
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
      },
      "aaaabbbb": {
        "uuid": "DU6krHBN1",
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
    }

    stub_request(:post, %r[appcenter/org/org_uuid/user/batch])
      .with(body: { user_uuids: %w[xxxxyyyy aaaabbbb] })
      .to_return(status: 200, body: response_body.to_json)

    result = Ones::Api.default.user.batch('org_uuid', %w[xxxxyyyy aaaabbbb])
    assert_equal 'DU6krHBN0', result.data.dig('xxxxyyyy', 'uuid')
    assert_equal 'DU6krHBN1', result.data.dig('aaaabbbb', 'uuid')
  end
end
