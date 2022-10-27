module Ones
  module Apis
    module Team
      # 获取组织下属团队列表
      def list(org_uuid)
        get "app_center/org/#{org_uuid}/teams"
      end

      # 批量获取团队信息
      # 当指定的team_uuid不存在时，返回的map中不会包含该团队的信息，即返回的map大小不一定等于传入的uuid数量
      def batch(org_uuid, team_uuids)
        get "app_center/org/#{org_uuid}/team/batch", params: { team_uuids: team_uuids.join(',') }
      end
    end
  end
end
