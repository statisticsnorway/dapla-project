#!/usr/bin/env bash

# dataset-access
## create role for rawdata
put $auth '/role/demo.pseudo.raw' '{
  "roleId": "demo.pseudo.raw",
  "description": "",
  "privileges": {
    "includes": []
  },
  "paths": {
    "includes": ["/demo/pseudo"]
  },
  "maxValuation": "SENSITIVE",
  "states": {
    "excludes": ["OTHER"]
  }
}' 201

## create role for indata
put $auth '/role/demo.pseudo.input' '{
  "roleId": "demo.pseudo.input",
  "description": "",
  "privileges": {
    "includes": []
  },
  "paths": {
    "includes": ["/demo/pseudo"]
  },
  "maxValuation": "SENSITIVE",
  "states": {
    "excludes": ["RAW", "OTHER"]
  }
}' 201

## create role for outdata
put $auth '/role/demo.pseudo.output' '{
  "roleId": "demo.pseudo.output",
  "description": "",
  "privileges": {
    "includes": ["READ", "CREATE"]
  },
  "paths": {
    "includes": ["/demo/pseudo"]
  },
  "maxValuation": "INTERNAL",
  "states": {
    "excludes": ["RAW", "OTHER"]
  }
}' 201

## get roles
get $auth '/role/demo.pseudo.raw' 200
get $auth '/role/demo.pseudo.input' 200
get $auth '/role/demo.pseudo.output' 200

## create groups
put $auth '/group/demo.pseudo' '{
  "groupId": "demo.pseudo",
  "description": "",
  "roles": ["demo.pseudo.raw", "demo.pseudo.input"]
}' 201

# get groups
get $auth '/group/demo.pseudo' 200

## create users
put $auth '/user/user1' '{ "userId" : "user1", "groups" : [ "demo.pseudo"] }' 201
put $auth '/user/user2' '{ "userId" : "user2", "roles" : [ "demo.pseudo.input" ] }' 201
put $auth '/user/user3' '{ "userId" : "user3", "roles" : [ "demo.pseudo.output" ] }' 201

## get access
## should have access
get $auth '/access/user1?privilege=READ&path=/demo/pseudo/raw&valuation=SENSITIVE&state=RAW' 200
get $auth '/access/user1?privilege=READ&path=/demo/pseudo/input&valuation=SENSITIVE&state=INPUT' 200
get $auth '/access/user2?privilege=READ&path=/demo/pseudo/input&valuation=SENSITIVE&state=INPUT' 200
get $auth '/access/user1?privilege=CREATE&path=/demo/pseudo/input&valuation=SHIELDED&state=INPUT' 200
get $auth '/access/user3?privilege=READ&path=/demo/pseudo/output&valuation=INTERNAL&state=OUTPUT' 200

## should not have access
get $auth '/access/user2?privilege=READ&path=/demo/pseudo/raw&valuation=SENSITIVE&state=RAW' 403
