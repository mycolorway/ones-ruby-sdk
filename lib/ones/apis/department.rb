module Ones
  module Apis
    module Department
      # 获取指定团队的部门列表（产品确认过可以接受空部门）
      def list(team_uuid)
        get "app_center/team/#{team_uuid}/departments"
      end
    end
  end
end
