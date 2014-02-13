RPMtoRPMActions
===============

Resource automation and automation script for integration within RPM

Install
=======

Copy resource automation files to <BRPM install dir>/WEB-INF/lib/script_support/LIBRARY/resource_automation/RPM
Copy automation files to <BRPM install dir>/WEB-INF/lib/script_support/LIBRARY/automation/RPM

Setup
=====

You need to create an integration category for RPM. In Environment, Choose Metadata and then Manage Lists. The list you need to look at is "Automation Category". Add a category called RPM

You need to create an integration server pointing to your BRPM server to point the API (if not already done):
  Server Type: StreamStep
  Server Name:  <up to you>
  Server URL:   <BRPM Webservice url; example: http://bl-rpmserver:8080/brpm/v1>
  Username:     <API Key for BRPM>
  password:     any value will do here
  Details:		  leave blank
  
Import Scripts doesn't work. The resource automations need to be installed manually.

The resource automation id's are: rpm_environment_list, rpm_installed_component_list, rpm_plan_stage, rpm_property_list and rpm_request_templates

The API Key can be obtained by clicking on "Profile" on the top right of the BRPM web page, clicking on the Show link for the API Key. Be careful using copy/paste, as a trailing space is often added.

BugFixes
========

Improvements
============

Removed dependency on curl

To-Do
=====

Provide option from resource automations to take [Default], and add option for Application.