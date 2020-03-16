#!/usr/bin/env bash

post $auth /rpc/RoleService/putRole '{"role":{
  "roleId": "raw_full",
  "privileges": [
    "CREATE",
    "UPDATE",
    "READ",
    "DELETE"
  ],
  "namespacePrefixes": [
    "/raw/"
  ],
  "maxValuation": "SENSITIVE",
  "states": ["RAW"]
}}' 200

#
## dataset-access
## create and read users
for user in "raw"; do
  put $auth '/user/'$user '{ "userId" : "'$user'", "roles" : [ "raw_full" ] }' 201
done
