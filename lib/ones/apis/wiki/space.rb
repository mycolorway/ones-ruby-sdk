module Ones
  module Apis
    module Wiki
      module Space
        def list(team_uuid)
          get "wiki/team/#{team_uuid}/my_spaces"
        end

        def templates(team_uuid, space_uuid)
          get "wiki/team/#{team_uuid}/space/#{space_uuid}/templates"
        end
      end
    end
  end
end
