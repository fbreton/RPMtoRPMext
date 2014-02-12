RPMtoRPMActions
===============

Resource automation and automation script for integration within RPM

Install
=======

Copy automation and resource automation directory to <BRPM install dir>/WEB-INF/lib/script_support/LIBRARY/automation/RPMtoRPM

Setup
=====

You need to create an integration server pointing to your BRPM server to point the API (if not already done):
  Server Name:  <up to you>
  Server URL:   <BRPM Webservice url; example: http://bl-rpmserver:8080/brpm/v1>
  Username:     <API Key for BRPM>
  password:     any value will do here
  Details:		  leave blank
  
You need to import in automation (Environment -> Automation):
  1. The resource automation scripts that you associate with the previously defined integration server.
      
  2. The automation scripts that you associated with the previously defined integration server.      

BugFixes
========


Improvements
============

Removed dependency on curl