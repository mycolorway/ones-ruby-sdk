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

      stub_request(:post, %r[app_platform/open_api/org/org_uuid/user/batch])
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

      stub_request(:post, %r[app_platform/open_api/org/org_uuid/team_member/batch])
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

      stub_request(:post, %r[app_platform/open_api/team/team_uuid/department_member/batch])
        .with(body: { user_uuids: %w[xxxxyyyy aaaabbbb] })
        .to_return(status: 200, body: response_body.to_json)

      result = Ones::Api.default.user.departments('team_uuid', %w[xxxxyyyy aaaabbbb])
      assert_equal ['MNZj4TvY'], result.data.dig('xxxxyyyy')
      assert_equal ['1a2b3c4d'], result.data.dig('aaaabbbb')
    end

    def test_queue_list_api
      response_body = {
        "batch_tasks": [
          {
            "uuid": "Tpzv8743",
            "team_uuid": "Gt1wX8M2",
            "owner": "2Rn8jQN2",
            "job_type": "import_wps",
            "job_status": "done",
            "batch_type": "none",
            "status": "show",
            "start_time": 1676533119,
            "end_time": 1676533120,
            "extra": "{\"resource_uuid\":\"WHajJU6f\",\"backup_file_url\":\"\",\"err_record_file_path\":\"\",\"backup_file_name\":\"Archive 2.zip\",\"ref_id\":\"\",\"space_uuid\":\"PDErYCSh\",\"page_uuid\":\"CYtrBvTw\",\"token\":\"svQaxLVOCqbilcNi2zf6RZYd0NAYwBKvE4rzOEJX5FeifFghZVJ1RQXL09qAuVVM\",\"post_actions\":[{\"action\":\"bind_task\",\"args\":{\"task_uuid\":\"PaYNBtv9RoKtUsqj\"}}]}",
            "payload": "",
            "successful_count": 2,
            "unsuccessful_count": 0,
            "unprocessed_count": 0,
            "sub_tasks_map": "",
            "errors_affect_count": nil,
            "successful": 2,
            "unsuccessful": 0,
            "unprocessed": 0,
            "successful_objects": []
          },
        ]
      }

      stub_request(:get, %r[project/api/project/team/team_uuid/queues/list]).to_return(status: 200, body: response_body.to_json)

      result = $ones_api.user.queue_list('team_uuid')
      assert_equal 1, result.data.dig('batch_tasks').size
    end
  end
end
