module Ones
  module Apis
    module Attachment
      # 上传资源
      def create(team_uuid, params = {})
        post "project/api/project/team/#{team_uuid}/res/attachments/upload", {
          type: :attachment,
          ref_type: params[:ref_type].presence || :user,
          ref_id: params[:ref_id].presence || client_id,
          name: params[:name],
          hash: params[:hash],
          description: params[:description]
        }.compact
      end

      # 上传文件
      def upload(upload_url, token, file)
        request_uuid = SecureRandom.uuid
        header = { 'X-Request-ID':  request_uuid }
        form_data = {
          token: token,
          file: HTTP::FormData::File.new(file)
        }
        Ones.logger.info "[#{request_uuid}][#{request.api_mode}] POST_FORM request ( #{upload_url} )"
        Ones.logger.info "[#{request_uuid}][#{request.api_mode}] form data: #{ form_data }"
        response = request.http.headers(header).post(upload_url, form: HTTP::FormData::Multipart.new(form_data))
        request.handle_response(request_uuid, response, :json)
      rescue ResponseError => e
        e.error_code == 579 ? Ones::Requests::Result.new({ code: 579, message: 'file exists'}) : raise(e)
      end

      # 获取附件资源
      def fetch(team_uuid, attachment_uuid, params = {})
        get "project/api/project/team/#{team_uuid}/res/attachment/#{attachment_uuid}", params: params
      end
    end
  end
end
