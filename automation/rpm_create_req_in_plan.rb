###
# Request Name:
#   name: Name of the request
#   position: A1:B1
#   type: in-text
#   required: yes
# Environment:
#   name: environment name
#   position: A2:B2
#   type: in-external-single-select
#   external_resource: rpm_environment_list
#   required: yes
# Stage:
#   name: stage name
#   position: A3:B3
#   type: in-external-single-select
#   external_resource: rpm_plan_stage
#   required: yes
# Request template:
#   name: Request template name
#   position: E2:F2
#   type: in-external-single-select
#   external_resource: rpm_request_templates
#   required: yes
# Start request:
#   name: Start request or not after creation
#   type: in-list-single
#   list_pairs: 1,Yes|2,No
#   position: E1:F1
#   required: yes
# Request:
#   name: Link to component edition
#   type: out-url
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


stage_id = params["Stage"].split("|")[0]
req_temp_name = params["Request template"].split("|")[1]
env = params["Environment"].split("|")[1]
params["Environment"] = env
plan_id = params["request_plan_id"]

def sub_tokens(script_params,var_string)
  prop_val = var_string.match('rpm{[^{}]*}')
  while ! prop_val.nil? do
    var_string = var_string.sub(prop_val[0],script_params[prop_val[0][4..-2]])
    prop_val = var_string.match('rpm{[^{}]*}')
  end
  return var_string
end

req_name = sub_tokens(params,params["Request Name"])

start_req = case params["Start request"]
  when "Yes" then '<execute_now>true</execute_now>'
  when "No" then ""
end

f_name = params["request_requestor"].split[1]
l_name = params["request_requestor"].split[0][0..-2]
url = "#{RPM_BASE_URL}/users?filters[first_name]=#{f_name}&filters[last_name]=#{l_name}&token=#{RPM_TOKEN}"
response = RestClient::Request.new(
  :method => :get,
  :url => url,
  :user => SS_integration_username,
  :password => decrypt_string_with_prefix(SS_integration_password_enc),
  :headers => { :accept => :json, :content_type => "text/xml" }
).execute
hash_response=JSON.parse(response.to_str)
requestor_id = hash_response[0]["id"]

f_name = params["request_owner"].split[1]
l_name = params["request_owner"].split[0][0..-2]
url = "#{RPM_BASE_URL}/users?filters[first_name]=#{f_name}&filters[last_name]=#{l_name}&token=#{RPM_TOKEN}"
response = RestClient::Request.new(
  :method => :get,
  :url => url,
  :user => SS_integration_username,
  :password => decrypt_string_with_prefix(SS_integration_password_enc),
  :headers => { :accept => :json, :content_type => "text/xml" }
).execute
hash_response=JSON.parse(response.to_str)
coordinator_id = hash_response[0]["id"]

request_doc_xml = "<request><name>#{req_name}</name><deployment_coordinator_id>#{coordinator_id}</deployment_coordinator_id><requestor_id>#{requestor_id}</requestor_id><template_name>#{req_temp_name}</template_name><environment>#{env}</environment>#{start_req}<plan_member_attributes><plan_id>#{plan_id}</plan_id><plan_stage_id>#{stage_id}</plan_stage_id></plan_member_attributes></request>"
url = "#{RPM_BASE_URL}/requests?token=#{RPM_TOKEN}"
response = RestClient::Request.new(
  :method => :post,
  :url => url,
  :user => SS_integration_username,
  :password => decrypt_string_with_prefix(SS_integration_password_enc),
  :headers => { :accept => :json, :content_type => "text/xml" },
  :payload => request_doc_xml
).execute
hash_response=JSON.parse(response.to_str)

req_id = 1000 + hash_response["id"]

pack_response "Request","#{RPM_BASE_URL[0..-3]}requests/#{req_id}"