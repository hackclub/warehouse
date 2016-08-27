require 'base64'
require 'json'

require 'rest-client'

class StreakClient
  BASE_URL = 'https://www.streak.com/api/v1'

  def initialize(api_key)
    @api_key = api_key
  end

  def pipelines
    make_request(:get, '/pipelines')
  end

  def current_user
    make_request(:get, '/users/me')
  end

  def user(user_key)
    make_request(:get, "/users/#{user_key}")
  end

  def boxes_in(pipeline_key)
    make_request(:get, "/pipelines/#{pipeline_key}/boxes")
  end

  protected

  def make_request(method, path, body=nil)
    params = {}
    headers = {}
    payload = nil
    url = BASE_URL + path

    headers['Authorization'] = construct_http_auth_header(@api_key, '')

    case method
    when :post
      headers['Content-Type'] = 'application/json'
      payload = body.to_json
    when :get
      headers[:params] = body
    end

    resp = RestClient::Request.execute(method: method, url: url,
                                       headers: headers, payload: payload)
    JSON.parse(resp.body)
  end

  def construct_http_auth_header(username, password)
    "Basic #{Base64.encode64(username + ':' + password)}"
  end
end
