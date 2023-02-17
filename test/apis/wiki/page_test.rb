require 'test_helper'

module Apis
  module Wiki
    class PageTest < Minitest::Test
      def test_list_api
        response_body = [
          {
            "uuid": "Fpi4rcHw",
            "space_uuid": "tzr7xfZw",
            "owner_uuid": "",
            "title": "主页",
            "parent_uuid": "",
            "encrypt_status": 1,
            "evaluated_permissions": [],
            "is_can_edit": true,
            "ref_type": 1,
            "ref_uuid": "",
            "updated_time": 1673349631,
            "creator": "TFaRgGsy"
          }
        ]

        stub_request(:post, %r[project/api/wiki/team/team_uuid/space/space_uuid/pages\?status=1]).to_return(status: 200, body: response_body.to_json)
        result = $ones_api.wiki_page.list('team_uuid', 'space_uuid')
        assert_equal 1, result.data.size
        assert_equal 'Fpi4rcHw', result.data.first['uuid']
      end

      def test_check_status_api
        response_body = {
          "results": [
            {
              "page_uuid": "7mG12EWa",
              "info": {
                "uuid": "7mG12EWa",
                "space_uuid": "",
                "owner_uuid": "",
                "title": "测试 wiki 权限",
                "content": "",
                "version": 0,
                "draft_uuid": "",
                "updated_time": 0,
                "watch_users": nil,
                "encrypt_status": 0,
                "is_can_edit": false,
                "share_uuid": "",
                "is_can_share": false,
                "is_can_edit_share": false,
                "space_view_page_permission": false,
                "share_view_page_permission": false,
                "ref_type": 0,
                "ref_uuid": "",
                "edit_users": nil,
                "space_view_permission": false
              },
              "err": {
                "Code": "PermissionDenied.ViewPage"
              }
            }
          ]
        }

        stub_request(:post, %r[project/api/wiki/team/team_uuid/check_pages_status]).to_return(status: 200, body: response_body.to_json)
        result = $ones_api.wiki_page.check_status('team_uuid', ['7mG12EWa'])
        assert_equal 1, result.data['results'].size
        assert_equal '7mG12EWa', result.data['results'].first['page_uuid']
      end

      def test_create_wiz_api
        response_body = {
          "uuid": "88SbRMFS",
          "team_uuid": "RDjYMhKq",
          "space_uuid": "sAu71Zfs",
          "owner_uuid": "NjXc5i8T",
          "title": "创建 Wiki 协同页面",
          "parent_uuid": "R7bTMyWa",
          "status": 1,
          "position": 683030,
          "create_time": 1676019438,
          "updated_time": 1676019438,
          "old_parent_uuid": "",
          "old_previous_uuid": "",
          "encrypt_status": 1,
          "ref_type": 6,
          "ref_uuid": "C6jAZXxp",
          "edit_users": ""
        }

        stub_request(:post, %r[project/api/wiki/team/team_uuid/online_pages/add]).to_return(status: 200, body: response_body.to_json)
        result = $ones_api.wiki_page.create_wiz('team_uuid', title: "创建 Wiki 协同页面", space_uuid: 'space_uuid', parent_uuid: 'parent_uuid')
        assert_equal '88SbRMFS', result.data['uuid']
      end

      def test_create_wiki_api
        response_body = {
          "uuid": "8VYfX2FD",
          "team_uuid": "3PiCTBg3",
          "space_uuid": "tzr7xfZw",
          "owner_uuid": "4ZFsxWKK",
          "title": "创建 Wiki 页面",
          "parent_uuid": "96zo6dpC",
          "status": 1,
          "position": 100000,
          "create_time": 1676019226,
          "updated_time": 1676019226,
          "old_parent_uuid": "",
          "old_previous_uuid": "",
          "encrypt_status": 1,
          "ref_type": 1,
          "ref_uuid": "",
          "edit_users": ""
        }

        stub_request(:post, %r[project/api/wiki/team/team_uuid/space/space_uuid/add_wiki_page]).to_return(status: 200, body: response_body.to_json)
        result = $ones_api.wiki_page.create_wiki('team_uuid', title: "创建 Wiki 页面", space_uuid: 'space_uuid', parent_uuid: 'parent_uuid')
        assert_equal '8VYfX2FD', result.data['uuid']
      end

      def test_import_api
        response_body = {
          "code": 200,
          "errcode": "OK",
          "type": "OK"
        }
        stub_request(:post, %r[project/api/wiki/team/team_uuid/word/import]).to_return(status: 200, body: response_body.to_json)
        result = $ones_api.wiki_page.import('team_uuid', parent_uuid: 'parent_uuid', resource_uuid: 'resource_uuid')
        assert_equal 200, result.data['code']

        result = $ones_api.wiki_page.import('team_uuid', parent_uuid: 'parent_uuid', resource_uuid: 'resource_uuid', type: :word)
        assert_equal 200, result.data['code']
      end
    end
  end
end
