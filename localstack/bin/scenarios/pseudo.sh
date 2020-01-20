#!/usr/bin/env bash

put $auth /role/user1 '{
  "roleId": "user1",
  "privileges": [
    "CREATE",
    "UPDATE",
    "READ",
    "DELETE"
  ],
  "namespacePrefixes": [
    "user1"
  ],
  "maxValuation": "SENSITIVE",
  "states": ["RAW", "INPUT", "PROCESSED", "OUTPUT", "PRODUCT"]
}' 201

put $auth '/user/user1' '{ "userId" : "user1", "roles" : [ "user1" ] }' 201

get $auth /role/user1

get $auth /user/user1
