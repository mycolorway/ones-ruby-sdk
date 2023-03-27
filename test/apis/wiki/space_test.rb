require 'test_helper'

module Apis
  module Wiki
    class SpaceTest < Minitest::Test
      def test_list_api
        response_body = [
          {
            "uuid": "tzr7xfZw",
            "owner_uuid": "TFaRgGsy",
            "is_archive": false,
            "title": "示例知识库",
            "description": "",
            "create_time": 1673349631,
            "updated_time": 1675934015,
            "admins": [
              "TFaRgGsy"
            ],
            "space_category_uuid": "",
            "page_count": 13,
            "is_pin": false,
            "is_open_share_page": false,
            "is_sample": true
          }
        ]

        stub_request(:get, %r[project/api/wiki/team/team_uuid/my_spaces]).to_return(status: 200, body: response_body.to_json)
        result = $ones_api.wiki_space.list('team_uuid')
        assert_equal 1, result.data.size
        assert_equal 'tzr7xfZw', result.data.first['uuid']
      end

      def test_templates_api
        response_body = {
          "total": 0,
          "start": 0,
          "count": 0,
          "templates": [],
          "categories": nil
        }

        stub_request(:get, %r[project/api/wiki/team/team_uuid/space/space_uuid/templates]).to_return(status: 200, body: response_body.to_json)
        result = $ones_api.wiki_space.templates('team_uuid', 'space_uuid')
        assert_equal 0, result.data['total']
        assert_equal [], result.data['templates']
      end
    end
  end
end
