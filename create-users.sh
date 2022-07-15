#!/bin/bash

set -x 

HOST='https://elastic:changeme@localhost:9200'
CONTENT_TYPE='Content-Type: application/json'

send_request () {
  curl -X POST -H "${CONTENT_TYPE}" "${HOST}$1" -d "${2}" --cacert certs/ca/ca.crt
  echo
}

# roles
send_request /_security/role/data_user '
{"applications":[{"application":"kibana-.kibana","privileges":["space_read"],"resources":["space:default"]}],"cluster":[],"indices":[
    {
      "allow_restricted_indices": false,
      "field_security": { "except": [], "grant": [ "*" ] },
      "names": [ "kibana_sample_data*", "ecommerce*", "test*" ],
      "privileges": [ "all" ]
    }
  ],"metadata":{},"run_as":[],"transient_metadata":{"enabled":true}}
'

send_request /_security/role/dev_reporting_user '
{ "applications": [ { "application": "kibana-.kibana", "privileges": [ "feature_discover.minimal_read", "feature_discover.generate_report", "feature_dashboard.minimal_read", "feature_dashboard.generate_report", "feature_dashboard.download_csv_report", "feature_canvas.read", "feature_canvas.generate_report", "feature_visualize.minimal_read", "feature_visualize.generate_report" ], "resources": [ "*" ] } ], "cluster": [], "indices": [], "metadata": {}, "run_as": [], "transient_metadata": { "enabled": true } }
'

# useres
send_request /_security/user/test_user '
{"email":"test@example.com","enabled":true,"full_name":"Test T. User","metadata":{},"password":"changeme","roles":["data_user","dev_reporting_user"]}
'
