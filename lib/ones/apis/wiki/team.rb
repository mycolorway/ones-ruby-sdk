module Ones
  module Apis
    module Wiki
      module Team
        # 查看团队类资源权限列表，主要关注资源类型为页面组的权限 context_type：space
        # view_page： 查看权限
        # create_page： 编辑权限
        def evaluated_permissions(team_uuid)
          get "project/api/wiki/team/#{team_uuid}/evaluated_permissions"
        end

        # 全局模版
        def templates(team_uuid)
          get "project/api/wiki/team/#{team_uuid}/templates"
        end

        # 最新使用模版
        def recent_templates(team_uuid)
          get "project/api/wiki/team/#{team_uuid}/recent_templates"
        end

        # 获取模版信息
        def templates(team_uuid, template_uuid)
          get "project/api/wiki/team/#{team_uuid}/template/#{template_uuid}"
        end

        # 团队创建页面的数量限制
        def limit(team_uuid)
          get "project/api/wiki/team/#{team_uuid}/team_space_limit"
        end
      end
    end
  end
end
