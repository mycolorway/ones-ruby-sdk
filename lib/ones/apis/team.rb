module Ones
  module Apis
    module Team
      # 获取组织下属团队列表
      def list(org_uuid)
        get "app_platform/open_api/org/#{org_uuid}/teams"
      end

      # 批量获取团队信息
      # 当指定的team_uuid不存在时，返回的map中不会包含该团队的信息，即返回的map大小不一定等于传入的uuid数量
      # 单次 100 个 uuid
      def batch(org_uuid, team_uuids)
        post "app_platform/open_api/org/#{org_uuid}/teams/batch", params: { team_uuids: team_uuids }
      end

      # 获取应用管理员列表
      def app_admin(team_uuid)
        get "app_platform/open_api/team/#{team_uuid}/permission/app_admin"
      end
    end
  end
end
