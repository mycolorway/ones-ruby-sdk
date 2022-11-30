module Ones
  module Apis
    module User
      # 批量获取指定用户信息
      def batch(org_uuid, user_uuids)
        post "app_platform/open_api/org/#{org_uuid}/user/batch", { user_uuids: user_uuids }
      end

      # 批量获取指定用户的所属团队
      def teams(org_uuid, user_uuids)
        post "app_platform/open_api/org/#{org_uuid}/team_member/batch", { user_uuids: user_uuids }
      end

      # 批量获取用户在指定团队的所属部门
      def departments(team_uuid, user_uuids)
        post "app_platform/open_api/team/#{team_uuid}/department_member/batch", { user_uuids: user_uuids }
      end
    end
  end
end
