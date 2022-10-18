require 'test_helper'

class DepartmentApiTest < Minitest::Test
  def test_list_api
    response_body = [
      {
        "uuid": "T2dyKELb",
        "parent_uuid": "",
        "name": "草帽海贼",
        "name_pinyin": "cao3mao4hai3zei2",
        "next_uuid": "MNZj4TvY",
        "sync_type": 0
      },
      {
        "uuid": "StM3ZoDJ",
        "parent_uuid": "",
        "name": "船",
        "name_pinyin": "chuan2",
        "next_uuid": "T2dyKELb",
        "sync_type": 0
      },
      {
        "uuid": "6Mh4DVYE",
        "parent_uuid": "",
        "name": "海军",
        "name_pinyin": "hai3jun1",
        "next_uuid": "StM3ZoDJ",
        "sync_type": 0
      },
      {
        "uuid": "MNZj4TvY",
        "parent_uuid": "",
        "name": "test",
        "name_pinyin": "test",
        "next_uuid": "",
        "sync_type": 0
      }
    ]

    stub_request(:get, %r[appcenter/team/team_uuid/departments]).to_return(status: 200, body: response_body.to_json)

    result = Ones::Api.default.department.list('team_uuid')
    assert_equal 4, result.data.size
    assert_equal ['T2dyKELb', 'StM3ZoDJ', '6Mh4DVYE', 'MNZj4TvY'], result.data.map{ |d| d['uuid'] }
  end
end
