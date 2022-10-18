require 'test_helper'

module Apis
  class TeamTest < Minitest::Test
    def test_list_api
      response_body = [
        {
          "uuid": "BDfDqJU7",
          "status": 1,
          "name": "onePiece",
          "owner": "FtuS5ApR",
          "logo": "",
          "cover_url": "",
          "domain": "",
          "create_time": 1535539298664608,
          "org_uuid": "75tuQaF7"
        }, {
          "uuid": "BDfDqJU8",
          "status": 1,
          "name": "onePiece",
          "owner": "FtuS5ApR",
          "logo": "",
          "cover_url": "",
          "domain": "",
          "create_time": 1535539298664608,
          "org_uuid": "75tuQaF7"
        }
      ]

      stub_request(:get, %r[appcenter/org/org_uuid/teams]).to_return(status: 200, body: response_body.to_json)

      result = Ones::Api.default.team.list('org_uuid')
      assert_equal 2, result.data.size
      assert_equal ['BDfDqJU7', 'BDfDqJU8'], result.data.map{ |d| d['uuid'] }
    end

    def test_teams_api
      response_body = {
        "aaaabbbb": {
          "uuid": "BDfDqJU7",
          "status": 1,
          "name": "onePiece",
          "owner": "FtuS5ApR",
          "logo": "",
          "cover_url": "",
          "domain": "",
          "create_time": 1535539298664608,
          "org_uuid": "75tuQaF7"
        },
        "xxxxyyyy": {
          "uuid": "BDfDqJU8",
          "status": 1,
          "name": "onePiece",
          "owner": "FtuS5ApR",
          "logo": "",
          "cover_url": "",
          "domain": "",
          "create_time": 1535539298664608,
          "org_uuid": "75tuQaF7"
        }
      }

      stub_request(:post, %r[appcenter/org/org_uuid/team_member/batch])
        .with(body: { user_uuids: ["aaaabbbb","xxxxyyyy"] },)
        .to_return(status: 200, body: response_body.to_json)

      result = Ones::Api.default.user.teams('org_uuid', %w[aaaabbbb xxxxyyyy])
      assert_equal 2, result.data.size
      assert_equal 'BDfDqJU8', result.data.dig('xxxxyyyy', 'uuid')
      assert_equal 'BDfDqJU7', result.data.dig('aaaabbbb', 'uuid')
    end
  end
end
