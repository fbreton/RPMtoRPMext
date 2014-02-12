###
# Environment:
#   name: environment name
#   position: A1:B1
#   type: in-external-single-select
#   external_resource: rpm_environment_list
#   required: yes
# Component:
#   name: Component name
#   position: E1:F1
#   type: in-external-single-select
#   external_resource: rpm_installed_component_list
#   required: yes
# Property:
#   name: Property name
#   position: A2:B2
#   type: in-external-single-select
#   external_resource: rpm_property_list
#   required: yes
# Value:
#   name: Property value to set
#   position: E2:F2
#   type: in-text
#   required: yes
# Result:
#   name: Link to component edition
#   type: out-text
#   position: A1:F1
###

require 'active_support/all'
require 'yaml'
require 'uri'
require 'rest-client'
require 'json'

params["direct_execute"] = true

RPM_TOKEN = decrypt_string_with_prefix(SS_integration_password_enc)
RPM_BASE_URL = SS_integration_dns

def sub_tokens(script_params,var_string)
  prop_val = var_string.match('rpm{[^{}]*}')
  while ! prop_val.nil? do
    var_string = var_string.sub(prop_val[0],script_params[prop_val[0][4..-2]])
    prop_val = var_string.match('rpm{[^{}]*}')
  end
  return var_string
end

prop = params["Property"].split("|")[1]
params["Property"] = prop
comp_id = params["Component"].split("|")[0]
comp = params["Component"].split("|")[1]
params["Component"] = comp
env = params["Environment"].split("|")[1]
params["Environment"] = env
prop_val = sub_tokens(params,params["Value"])

request_doc_xml = "<installed_component><properties_with_values><#{prop}>#{prop_val}</#{prop}></properties_with_values></installed_component>"
url = "#{RPM_BASE_URL}/installed_components/#{comp_id}?token=#{RPM_TOKEN}"

response = RestClient::Request.new(
  :method => :post,
  :url => url,
  :user => SS_integration_username,
  :password => decrypt_string_with_prefix(SS_integration_password_enc),
  :headers => { :accept => :json, :content_type => "text/xml" },
  :payload => request_doc_xml
).execute
hash_response=JSON.parse(response.to_str)

pack_response "Result","#{params["application"]}/#{env}/#{comp}/#{prop} set to: #{prop_val}"