module Ones
  module Apis
    module User
      def batch(org_uuid, user_uuids)
        post "appcenter/org/#{org_uuid}/user/batch", { user_uuids: user_uuids }
      end

      def teams(org_uuid, user_uuids)
        post "appcenter/org/#{org_uuid}/team_member/batch", { user_uuids: user_uuids }
      end
    end
  end
end
