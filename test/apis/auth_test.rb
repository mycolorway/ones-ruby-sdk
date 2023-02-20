require 'test_helper'

module Apis
  class AuthTest < Minitest::Test
    def test_token_info_api
      response_body = {
        "user": {
            "uuid": "NjXc5i8T",
            "email": "dingnan@ones.cn",
            "name": "丁楠",
            "name_pinyin": "ding1nan2",
            "title": "研发工程师",
            "avatar": "https://dlonespublic.ones.pro/FnTc_M1oojAt-NPFKFpw4o3vJ-Go",
            "phone": "",
            "create_time": 1606729457130055,
            "status": 1,
            "channel": "uNjXc5i8T4vTNT2TrW9blLSgGVZC9Dzl",
            "token": "QFCUntX9iBO7LyIfh2jpSXt6u8TE5KS6sZOk6V7mLSDdIfPrOq3LUmpg6hfArJxs",
            "license_types": [
                9,
                13,
                14,
                3,
                5,
                7,
                8,
                12,
                16,
                1,
                4,
                6,
                2,
                15,
                10,
                11
            ],
            "imported_jira_user": false,
            "is_init_password": false,
            "language": "zh"
        },
        "teams": []
      }

      stub_request(:get, %r[project/api/project/auth/token_info]).to_return(status: 200, body: response_body.to_json)
      result = $ones_api.auth.token_info
      assert_equal 16, result.data['user']['license_types'].size
    end
  end
end
