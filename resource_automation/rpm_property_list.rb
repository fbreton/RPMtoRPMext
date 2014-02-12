###
# Environment:
#   name: environment name
#   type: in-external-single-select
#   external_resource: rpm_environment_list
#   required: yes
# Component:
#   name: Component name
#   type: in-external-single-select
#   external_resource: rpm_installed_component_list
#   required: yes
###

require 'yaml'
require 'uri'
require 'rest-client'
require 'json'
#require 'active_support/all'

RPM_TOKEN = decrypt_string_with_prefix(SS_integration_password_enc)
RPM_BASE_URL = SS_integration_dns

def execute(script_params, parent_id, offset, max_records)

  comp = script_params["Component"].split("|")[1]

  url = "#{RPM_BASE_URL}/properties?filters[name]=#{comp}&token=#{RPM_TOKEN}"

  response = RestClient::Request.new(
    :method => :get,
    :url => url,
    :user => SS_integration_username,
    :password => decrypt_string_with_prefix(SS_integration_password_enc),
    :headers => { :accept => :json, :content_type => "text/xml" }
  ).execute

  hash_response=JSON.parse(response.to_str)

  result = [{'Select' => ''}]
  hash_response.each do |elt|
    result << {elt["name"] => "#{elt["id"]}|#{elt["name"]}"}
  end
  return result
end

def import_script_parameters
  { "render_as" => "List" }
end
