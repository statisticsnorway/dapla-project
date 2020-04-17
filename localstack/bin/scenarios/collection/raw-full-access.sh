#!/usr/bin/env bash

## create role for raw_full
put $auth '/role/raw_full' '{
  "roleId": "raw_full",
  "description": "",
  "privileges": {
    "includes": []
  },
  "paths": {
    "includes": ["/raw"]
  },
  "maxValuation": "SENSITIVE",
  "states": {
    "includes": ["RAW"]
  }
}' 201

## create and read users
for user in "raw"; do
  put $auth '/user/'$user '{ "userId" : "'$user'", "roles" : [ "raw_full" ] }' 201
done
