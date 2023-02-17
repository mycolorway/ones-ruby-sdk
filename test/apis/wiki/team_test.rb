require 'test_helper'

module Apis
  module Wiki
    class TeamTest < Minitest::Test
      def test_evaluated_permissions_api
        response_body = {
          "evaluated_permissions": [
            {
              "key":"1103-FHoqP4rp-:2007",
              "context_type":"space",
              "context_param":{"page_uuid":"FHoqP4rp"},
              "permission":"view_page"
            },
            {
              "key": "1102-FHoqP4rp-:2002",
              "context_type": "space",
              "context_param": {
                "space_uuid": "FHoqP4rp"
              },
              "permission": "create_page"
            }
          ],
          "server_update_stamp": 1675848067609278
        }

        stub_request(:get, %r[wiki/team/team_uuid/evaluated_permissions]).to_return(status: 200, body: response_body.to_json)
        result = $ones_api.wiki_team.evaluated_permissions('team_uuid')
        assert_equal 2, result.data['evaluated_permissions'].size
      end

      def test_templates_api
        response_body = {
          "total": 0,
          "start": 0,
          "count": 0,
          "templates": [],
          "categories": nil
        }

        stub_request(:get, %r[project/api/wiki/team/team_uuid/templates]).to_return(status: 200, body: response_body.to_json)
        result = $ones_api.wiki_team.templates('team_uuid')
        assert_equal 0, result.data['total']
        assert_equal [], result.data['templates']
      end

      def test_limit_api
        response_body = {
          "is_over_page_limit": false,
          "max_page_count": -1
        }

        stub_request(:get, %r[project/api/wiki/team/team_uuid/team_space_limit]).to_return(status: 200, body: response_body.to_json)
        result = $ones_api.wiki_team.limit('team_uuid')
        assert_equal false, result.data['is_over_page_limit']
        assert_equal -1, result.data['max_page_count']
      end
    end
  end
end
