module Ones
  module Apis
    module AppCenter
      # 用户凭证校验
      # 用来校验网关发过来的用户凭证，校验成功会返回token对应的用户信息
      def check_user(uuid, token)
        post 'app_platform/open_api/check_user', { user_uuid: uuid, token: token }
      end
    end
  end
end
