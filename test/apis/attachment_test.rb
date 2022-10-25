require 'test_helper'

module Apis
  class AttachmentTest < Minitest::Test
    def setup
      @api = Ones::Api.new(client_id: 'user_uuid', client_secret: 'user_access_token', mode: :api)
      @resource_uuid = 'Q1ZE77v9'
    end

    def test_attachment_create_api
      response_body = {
        "need_upload": true,
        "base_url": "https://your-host-name/project/api/project",
        "upload_url": "https://up.qbox.me",
        "token": "3Ub47hHnTjuEuV7uF9IS:HfITwb71foZJr0lv0=:eyJzY29wZSI6Im9uZXMtZG==", # 模拟的 token
        "resource_uuid": @resource_uuid,
        "size_limit": 314572800
      }

      stub_request(:post, %r[/project/api/project/team/team_uuid/res/attachments/upload])
        .with(headers: { 'Ones-Auth-Token': 'user_access_token', 'Ones-User-Id': 'user_uuid' })
        .to_return(status: 200, body: response_body.to_json)
      result = @api.attachment.create('team_uuid', { name: 'example.ppt', hash: 'FhafioiyVcbR2ORJG1lPWlTqT8Tn' })

      assert_equal 'Q1ZE77v9', result.data.dig('resource_uuid')
      assert_equal 'https://up.qbox.me', result.data.dig('upload_url')
      assert_equal '3Ub47hHnTjuEuV7uF9IS:HfITwb71foZJr0lv0=:eyJzY29wZSI6Im9uZXMtZG==', result.data.dig('token')
    end

    def test_attachment_create_api_with_specify_ones_auth
      response_body = {
        "need_upload": true,
        "base_url": "https://your-host-name/project/api/project",
        "upload_url": "https://up.qbox.me",
        "token": "3Ub47hHnTjuEuV7uF9IS:HfITwb71foZJr0lv0=:eyJzY29wZSI6Im9uZXMtZG==", # 模拟的 token
        "resource_uuid": @resource_uuid,
        "size_limit": 314572800
      }
      stub_request(:post, %r[/project/api/project/team/team_uuid/res/attachments/upload])
        .with(headers: { 'Ones-Auth-Token': 'another_ones_auth_token', 'Ones-User-Id': 'another_user_uuid' })
        .to_return(status: 200, body: response_body.to_json)
      result = @api.attachment.create(
        'team_uuid',
        { name: 'example.ppt', hash: 'FhafioiyVcbR2ORJG1lPWlTqT8Tn' },
        { ones_user_uuid: 'another_user_uuid', ones_auth_token: 'another_ones_auth_token' }
      )

      assert_equal 'Q1ZE77v9', result.data.dig('resource_uuid')
      assert_equal 'https://up.qbox.me', result.data.dig('upload_url')
      assert_equal '3Ub47hHnTjuEuV7uF9IS:HfITwb71foZJr0lv0=:eyJzY29wZSI6Im9uZXMtZG==', result.data.dig('token')
    end

    def test_attachment_upload_api
      response_body = {
        "hash": "Fj3GlNDc6g81Mas7UBghxXmvD-9L",
        "mime": "application/octet-stream",
        "name": "untitled",
        "size": 1184,
        "url": "https://your-host-name/project/api/project/Fj3GlNDc6g81Mas7UBghxXmvD-9L"
      }

      stub_request(:post, %r[up.qbox.me]).to_return(status: 200, body: response_body.to_json)
      result = @api.attachment.upload('https://up.qbox.me', '3Ub47hHnTjuEuV7uF9IS:HfITwb71foZJr0lv0=:eyJzY29wZSI6Im9uZXMtZG==', __FILE__)

      assert_equal 'https://your-host-name/project/api/project/Fj3GlNDc6g81Mas7UBghxXmvD-9L', result.data.dig('url')
    end

    def test_attachment_get_api
      response_body = {
        "name": "example.ppt",
        "hash": "FhafioiyVcbR2ORJG1lPWlTqT8Tn",
        "mime": "application/vnd.ms-powerpoint",
        "size": 1268382,
        "url": "http://7xshmn.com1.z0.glb.clouddn.com/FhafioiyVcbR2ORJG1lPWlTqT8Tn"
      }

      stub_request(:get, %r[/project/api/project/team/team_uuid/res/attachment/Q1ZE77v9])
        .with(headers: { 'Ones-Auth-Token': 'user_access_token', 'Ones-User-Id': 'user_uuid' })
        .to_return(status: 200, body: response_body.to_json)

      result = @api.attachment.fetch('team_uuid', @resource_uuid)
      assert_equal 'http://7xshmn.com1.z0.glb.clouddn.com/FhafioiyVcbR2ORJG1lPWlTqT8Tn', result.data.dig('url')
    end

    def test_attachment_get_api_with_specify_ones_auth
      response_body = {
        "name": "example.ppt",
        "hash": "FhafioiyVcbR2ORJG1lPWlTqT8Tn",
        "mime": "application/vnd.ms-powerpoint",
        "size": 1268382,
        "url": "http://7xshmn.com1.z0.glb.clouddn.com/FhafioiyVcbR2ORJG1lPWlTqT8Tn"
      }

      stub_request(:get, %r[/project/api/project/team/team_uuid/res/attachment/Q1ZE77v9])
        .with(headers: { 'Ones-Auth-Token': 'another_ones_auth_token', 'Ones-User-Id': 'another_user_uuid' })
        .to_return(status: 200, body: response_body.to_json)

      result = @api.attachment.fetch('team_uuid', @resource_uuid, { ones_user_uuid: 'another_user_uuid', ones_auth_token: 'another_ones_auth_token' })
      assert_equal 'http://7xshmn.com1.z0.glb.clouddn.com/FhafioiyVcbR2ORJG1lPWlTqT8Tn', result.data.dig('url')
    end
  end
end
