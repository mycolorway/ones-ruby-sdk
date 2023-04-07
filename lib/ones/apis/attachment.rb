module Ones
  module Apis
    module Attachment
      # 上传资源
      def create(team_uuid, params = {}, header = {})
        post "project/team/#{team_uuid}/res/attachments/upload", {
          type: :attachment,
          ref_type: params[:ref_type].presence || :app,
          ref_id: params[:ref_id].presence || client_id,
          ctype: params[:ctype],
          name: params[:name],
          hash: params[:hash],
          description: params[:description]
        }.compact, header
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
      def fetch(team_uuid, attachment_uuid, header = {})
        base_query = header.delete(:params) || {}
        attachment_url = if base_query.present?
                           "project/team/#{team_uuid}/res/attachment/#{attachment_uuid}?#{base_query.to_query}"
                         else
                           "project/team/#{team_uuid}/res/attachment/#{attachment_uuid}"
                         end
        get attachment_url, header
      end
    end
  end
end
