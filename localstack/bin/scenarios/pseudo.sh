#!/usr/bin/env bash

put $auth /role/demo.pseudo.raw '{
  "roleId": "demo.pseudo.raw",
  "privileges": [
    "CREATE",
    "UPDATE",
    "READ",
    "DELETE"
  ],
  "namespacePrefixes": [
    "/demo.pseudo"
  ],
  "maxValuation": "SENSITIVE",
  "states": ["RAW", "INPUT", "PROCESSED", "OUTPUT", "PRODUCT"]
}' 201

put $auth /role/demo.pseudo.input '{
  "roleId": "demo.pseudo.input",
  "privileges": [
    "CREATE",
    "UPDATE",
    "READ",
    "DELETE"
  ],
  "namespacePrefixes": [
    "/demo.pseudo"
  ],
  "maxValuation": "SENSITIVE",
  "states": ["INPUT", "PROCESSED", "OUTPUT", "PRODUCT"]
}' 201


put $auth '/user/user1' '{ "userId" : "user1", "roles" : [ "demo.pseudo.raw", "demo.pseudo.input"] }' 201
put $auth '/user/user2' '{ "userId" : "user2", "roles" : [ "demo.pseudo.input" ] }' 201

get $auth /role/demo.pseudo.raw 200
get $auth /role/demo.pseudo.input 200


## get access
## should have access
get $auth '/access/user1?privilege=READ&namespace=demo.pseudo.raw&valuation=SENSITIVE&state=RAW' 200
get $auth '/access/user1?privilege=READ&namespace=demo.pseudo.input&valuation=SENSITIVE&state=INPUT' 200
get $auth '/access/user2?privilege=READ&namespace=demo.pseudo.input&valuation=SENSITIVE&state=INPUT' 200

## should not have access
get $auth '/access/user2?privilege=READ&namespace=demo.pseudo.raw&valuation=SENSITIVE&state=RAW' 403



## dapla-catalog
#
## map name to id
get $catalog '/name/demo.pseudo.input'


post $catalog '/name/demo.pseudo.input' '{"proposedId":"e1aa16a0-73ab-47de-a301-6079618a4172"}' 200

## check mapping
get $catalog '/name/demo.pseudo.input' 200

## check listing
get $catalog '/prefix/demo.pseudo' 200

## create dataset
put $catalog '/dataset/e1aa16a0-73ab-47de-a301-6079618a4172?userId=user1' '{
  "id": {
    "id": "e1aa16a0-73ab-47de-a301-6079618a4172",
    "name": ["demo.pseudo.input"]
  },
  "valuation": "SHIELDED",
  "state": "INPUT",
  "locations": ["file:///data/datastore/demo.pseudo.input"]
}' 201

## dapla-catalog
## read dataset
get $catalog '/dataset/e1aa16a0-73ab-47de-a301-6079618a4172' 200

## dapla-spark
## read dataset meta
get $spark '/dataset-meta?name=demo.pseudo.input&operation=READ&userId=user1' 200
