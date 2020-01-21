#!/usr/bin/env bash

put $auth /role/demo.pseudo.before '{
  "roleId": "demo.pseudo.before",
  "privileges": [
    "CREATE",
    "UPDATE",
    "READ",
    "DELETE"
  ],
  "namespacePrefixes": [
    "demo.pseudo.before"
  ],
  "maxValuation": "SENSITIVE",
  "states": ["RAW", "INPUT", "PROCESSED", "OUTPUT", "PRODUCT"]
}' 201

put $auth /role/demo.pseudo.after '{
  "roleId": "demo.pseudo.after",
  "privileges": [
    "CREATE",
    "UPDATE",
    "READ",
    "DELETE"
  ],
  "namespacePrefixes": [
    "demo.pseudo.after"
  ],
  "maxValuation": "SENSITIVE",
  "states": ["INPUT", "PROCESSED", "OUTPUT", "PRODUCT"]
}' 201


put $auth '/user/user1' '{ "userId" : "user1", "roles" : [ "demo.pseudo.before", "demo.pseudo.after"] }' 201
put $auth '/user/user2' '{ "userId" : "user2", "roles" : [ "demo.pseudo.after" ] }' 201

get $auth /role/demo.pseudo.before 200
get $auth /role/demo.pseudo.after 200


## get access
## should have access
get $auth '/access/user1?privilege=READ&namespace=demo.pseudo.before&valuation=SENSITIVE&state=RAW' 200
get $auth '/access/user1?privilege=READ&namespace=demo.pseudo.after&valuation=SENSITIVE&state=INPUT' 200

## should not have access
get $auth '/access/user2?privilege=READ&namespace=demo.pseudo.before&valuation=SENSITIVE&state=RAW' 403

