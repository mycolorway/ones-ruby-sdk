require 'test_helper'

module Apis
  class UserTest < Minitest::Test
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

    def test_teams_api
      response_body = {
        aaaabbbb: ['1a2b3c4d'],    # key为userUUID, value为teamUUID
        xxxxyyyy: ['1a2b3c3d']
      }

      stub_request(:post, %r[appcenter/org/org_uuid/team_member/batch])
        .with(body: { user_uuids: %w[xxxxyyyy aaaabbbb] })
        .to_return(status: 200, body: response_body.to_json)

      result = Ones::Api.default.user.teams('org_uuid', %w[xxxxyyyy aaaabbbb])
      assert_equal ['1a2b3c3d'], result.data.dig('xxxxyyyy')
      assert_equal ['1a2b3c4d'], result.data.dig('aaaabbbb')
    end

    def test_departments_api
      response_body = {
        aaaabbbb: ['1a2b3c4d'],    # key为userUUID, value为teamUUID
        xxxxyyyy: ['MNZj4TvY']
      }

      stub_request(:post, %r[appcenter/team/team_uuid/department_member/batch])
        .with(body: { user_uuids: %w[xxxxyyyy aaaabbbb] })
        .to_return(status: 200, body: response_body.to_json)

      result = Ones::Api.default.user.departments('team_uuid', %w[xxxxyyyy aaaabbbb])
      assert_equal ['MNZj4TvY'], result.data.dig('xxxxyyyy')
      assert_equal ['1a2b3c4d'], result.data.dig('aaaabbbb')
    end
  end
end
