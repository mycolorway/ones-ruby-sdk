require 'test_helper'

module Apis
  class OrgTest < Minitest::Test
    def test_app_credential_api
      response_body = {
        "uuid": "xxxxyyyy",      # 应用账号的UUID（一个特殊的用户）
        "org_uuid": "org_uuid",  # 组织的UUID
        "name": "ONES Task",     # 应用账号的名称（也是应用名称）
        "token": "xxxx",         # 应用账号的Token
        "expired_at": 1663315463 # 应用账号Token的过期时间（秒级时间戳）
      }
      stub_request(:get, %r[app_platform/open_api/org/org_uuid/app_credential]).to_return(status: 200, body: response_body.to_json)
      result = Ones::Api.default.org.app_credential('org_uuid')
      assert_equal 'xxxxyyyy', result.data.dig('uuid')
    end

    def test_constraint_by_user_api
      response_body = {
        "ones:app:task:enable": true # 具体的constraint配置项由实际证书决定, 至少会包含这一条
      }
      stub_request(:get, %r[app_platform/open_api/org/org_uuid/constraint/by_user/user_uuid]).to_return(status: 200, body: response_body.to_json)
      result = Ones::Api.default.org.constraint_by_user('org_uuid', 'user_uuid')
      assert_equal true, result.data.dig('ones:app:task:enable')
    end

    def test_license_api
      response_body = {
        "type": 15,               # License类型
        "edition": "enterprise",  # License版本
        "scale": 100,             # 许可人数
        "expire_time": 1663315463 # 到期时间（秒级时间戳）
      }
      stub_request(:get, %r[app_platform/open_api/org/org_uuid/license]).to_return(status: 200, body: response_body.to_json)
      result = Ones::Api.default.org.license('org_uuid')
      assert_equal 'enterprise', result.data.dig('edition')
    end

    def test_grant_uuids_api
      response_body = ["xxxxyyyy", "aaaabbbb"]
      stub_request(:get, %r[app_platform/open_api/org/org_uuid/license/grant]).to_return(status: 200, body: response_body.to_json)
      result = Ones::Api.default.org.grant_uuids('org_uuid')
      assert_equal 2, result.data.size
      assert_equal ["xxxxyyyy", "aaaabbbb"], result.data
    end
  end
end
