require 'test_helper'

class OnesTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Ones::VERSION
  end

  # 验证 Ones 文档中的请求，是否能生成正确的签名
  # https://our.ones.pro/wiki/#/team/RDjYMhKq/space/FHoqP4rp/page/PXbVCYqS
  def test_sample_post
    post_header = {
      params: { some: 'attr',another: 'param' },
      'Ones-User-Id' => 'xxxxyyyy'
    }

    sample_payload = {
      foo: 'bar',
      abnormal: ['absent', 'acquire'],
      alpha: [
        { bravo: 'charlie', delta: 'echo' },
        { foxtrot: 'golf' }
      ],
      foobar: { john: 'doae', baz: 'boo' },
      baz: 'bar',
      nil: nil,
      bool: true
    }

    stub_request(:post, %r[example/api]).to_return(status: 200, body: {}.to_json)

    ones_request = Ones::Api.default.request
    def ones_request.request_uuid_in_header?; false; end

    Time.stub(:current, Time.at(1663301441)) do
      ones_request.send(:request, :post, 'example/api', post_header, sample_payload) do |url, header|
        assert_match 'bc987b8bc7e601b5350da7598615fa92825cfd0a', url.to_s
        assert_equal ({ 'Ones-User-Id' => 'xxxxyyyy', 'Accept' => 'application/json'}), header
        ones_request.http.headers(header).post(url, json: sample_payload, ssl_context: ones_request.ssl_context)
      end
    end
  end
end
