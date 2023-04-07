module Ones
  module Apis
    module Auth
      # 获取 license 信息
      # user.license_types 中 2 代表 wiki，16 代表 ones_task，该字段会变更为字符串
      def token_info
        get "project/auth/token_info"
      end
    end
  end
end
