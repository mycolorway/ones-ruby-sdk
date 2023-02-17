module Ones
  module Apis
    module Org
      # 获取服务凭证
      # 用来获取以应用身份调用ONES API使用的应用凭证
      def app_credential(org_uuid)
        get "app_platform/open_api/org/#{org_uuid}/app_credential"
      end

      # 获取当前应用在指定组织指定用户下的ConstraintMap
      # 包含应用级别的constraint
      def constraint_by_user(org_uuid, user_uuid)
        get "app_platform/open_api/org/#{org_uuid}/constraint/by_user/#{user_uuid}"
      end

      # 获取当前应用在指定组织的有效 License
      # 如果License已过期，该接口会返回null
      def license(org_uuid)
        get "app_platform/open_api/org/#{org_uuid}/license"
      end

      # 获取当前应用在指定组织已授权用户的UUID列表
      def grant_uuids(org_uuid)
        get "app_platform/open_api/org/#{org_uuid}/license/grant"
      end

      # 当前团队的 Wiki 配置
      # 主要关注：wps_config、wiz_config、wiki_config
      def stamps_data(org_uuid)
        post "project/api/project/organization/#{org_uuid}/stamps/data",
             { "org_configs": 0 },
             { params: { t: :organization } }
      end
    end
  end
end
