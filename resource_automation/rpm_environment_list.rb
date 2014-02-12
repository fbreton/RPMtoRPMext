require 'yaml'
require 'uri'
require 'rest-client'
# require 'active_support/all'
require 'json'
#require 'active_support/all'

RPM_TOKEN = decrypt_string_with_prefix(SS_integration_password_enc)
RPM_BASE_URL = SS_integration_dns
  
def execute(script_params, parent_id, offset, max_records)

  app_name = script_params["application"]

  url = "#{RPM_BASE_URL}/apps?token=#{RPM_TOKEN}?filters[name]=#{app_name}"

  response = RestClient::Request.new(
    :method => :get,
    :url => url,
    :user => SS_integration_username,
    :password => decrypt_string_with_prefix(SS_integration_password_enc),
    :headers => { :accept => :json, :content_type => "text/xml" }
  ).execute

  hash_response=JSON.parse(response.to_str)
  result = [{'Select' => ''}]
  hash_response[0]["environments"].each do |elt|
    result << {elt["name"] => "#{elt["id"]}|#{elt["name"]}"}
  end
  return result
end

def import_script_parameters
  { "render_as" => "List" }
end
