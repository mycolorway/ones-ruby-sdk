module Ones
  module Apis
    module Task
      def list(team_uuid, uuids: [])
        query = %(
          {
            tasks(filter: $filter) {
              uuid
              name
              statusCategory
              status {
                name
                category
              }
              issueType {
                detailType
                icon
                name
                subIssueType
              }
              subIssueType {
                detailType
                icon
                name
                subIssueType
              }
            }
          }
        )
        post "project/team/#{team_uuid}/items/graphql", {
          query: query,
          variables: { filter: { uuid_in: uuids } }
        }
      end
    end
  end
end
