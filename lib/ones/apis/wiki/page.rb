module Ones
  module Apis
    module Wiki
      module Page
        # 获取页面组内所有页面
        # PageStructureStatusNormal = 1
        # PageStructureStatusDeleted = 2
        # PageStructureStatusInRecycler = 3
        def list(team_uuid, space_uuid, status: 1)
          post "project/api/wiki/team/#{team_uuid}/space/#{space_uuid}/pages",
               {},
               { params: { status: status } }
        end

        # 检查页面状态
        # PermissionDenied.ViewPage
        #   没有查看权限
        #   配置查看权限后，删除页面组
        # NotFound.Page
        #   页面删除
        # 若参数中有不存在的页面 uuid，则会报 400 错误
        def check_status(team_uuid, page_uuids = [])
          post "project/api/wiki/team/#{team_uuid}/check_pages_status",
               { "page_uuids": page_uuids }
        end

        # 创建 Wiki 协同页面
        def create_wiz(team_uuid, title:, space_uuid:, parent_uuid:)
          post "project/api/wiki/team/#{team_uuid}/online_pages/add",
               { title: title, space_uuid: space_uuid, parent_uuid: parent_uuid }
        end

        # 创建 Wiki 页面
        def create_wiki(team_uuid, title:, space_uuid:, parent_uuid:, content: '', src_type: 'template', src_uuid: '')
          post "project/api/wiki/team/#{team_uuid}/space/#{space_uuid}/add_wiki_page",
               {
                 parent_page_uuid: parent_uuid,
                 title: title,
                 content: content,
                 src_type: src_type,
                 src_uuid: src_uuid
               }
        end

        # 创建 WPS 页面：文稿、表格、幻灯片
        # 其中 src_uuid 取值: wps-word、wps-sheet、wps-ppt
        def create_wps(team_uuid, title:, space_uuid:, parent_uuid:, src_type: 'template', src_uuid: 'wps-word')
          post "project/api/wiki/team/#{team_uuid}/space/#{space_uuid}/page_add",
               {
                 page_uuid: parent_uuid,
                 title: title,
                 src_type: src_type,
                 src_uuid: src_uuid
               }
        end

        # 「异步接口」导入 Wiki 协同页面
        def import_wiz(team_uuid, parent_uuid:, resource_uuid:)
          post "project/api/wiki/team/#{team_uuid}/word/import",
               { type: :wiz, ref_id: parent_uuid, resource_uuids: [resource_uuid] }
        end


        # 「异步接口」导入 Wiki 页面
        def import_wiki(team_uuid, parent_uuid:, resource_uuid:)
          post "project/api/wiki/team/#{team_uuid}/word/import",
               { type: :word, ref_id: parent_uuid, resource_uuids: [resource_uuid] }
        end


        # 「同步接口」导入办公协同文件
        def import_wps(team_uuid, space_uuid:, parent_uuid:, resource_uuid:)
          post "project/api/wiki/team/#{team_uuid}/space/#{space_uuid}/import_wps",
               { resource_uuid: resource_uuid, page_uuid: parent_uuid }
        end
      end
    end
  end
end
