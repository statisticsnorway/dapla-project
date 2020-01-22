#!/usr/bin/env bash

# dataset-access
# create role for rawdata
put $auth /role/skatt.person.rawdata '{
  "roleId": "skatt.person.rawdata",
  "privileges": [
    "CREATE",
    "UPDATE",
    "READ",
    "DELETE"
  ],
  "namespacePrefixes": [
    "/skatt.person"
  ],
  "maxValuation": "SENSITIVE",
  "states": ["RAW", "INPUT", "PROCESSED", "OUTPUT", "PRODUCT"]
}' 201

# create role for indata
put $auth /role/skatt.person.inndata '{
  "roleId": "skatt.person.inndata",
  "privileges": [
    "CREATE",
    "UPDATE",
    "READ",
    "DELETE"
  ],
  "namespacePrefixes": [
    "/skatt.person"
  ],
  "maxValuation": "SENSITIVE",
  "states": ["INPUT", "PROCESSED", "OUTPUT", "PRODUCT","OTHER"]
}' 201

## dataset-access
## get roles
get $auth /role/skatt.person.rawdata 200
get $auth /role/skatt.person.inndata 200


#
## dataset-access
## create users
put $auth '/user/user1' '{ "userId" : "user1", "roles" : [ "skatt.person.rawdata" ] }' 201

put $auth '/user/user2' '{ "userId" : "user2", "roles" : [ "skatt.person.inndata" ] }' 201

## dataset-access
## get user
get $auth '/user/user1' 200
get $auth '/user/user2' 200

## dataset-access
## get access
## should have access
get $auth '/access/user1?privilege=READ&namespace=skatt.person&valuation=SENSITIVE&state=RAW' 200
get $auth '/access/user2?privilege=READ&namespace=skatt.person&valuation=SENSITIVE&state=INPUT' 200

## should not have access
get $auth '/access/user2?privilege=READ&namespace=skatt.person&valuation=SENSITIVE&state=RAW' 403


## dapla-catalog
#
## map name to id
post $catalog '/name/skatt.person.2019.rawdata' '{"proposedId":"341b03d6-5be6-4c9b-b381-8cf692aa8830"}' 200

## check mapping
get $catalog '/name/skatt.person.2019.rawdata' 200

## check listing
get $catalog '/prefix/skatt' 200

## create dataset
put $spark '/dataset-meta?userId=user1' '{
  "id": {
    "id": "341b03d6-5be6-4c9b-b381-8cf692aa8830",
    "name": ["skatt.person.2019.rawdata"]
  },
  "valuation": "SHIELDED",
  "state": "RAW",
  "locations": ["gs://dev-datalager-store/datastore/skatt/person/rawdata-2019"]
}' 200

## dapla-catalog
## read dataset
get $catalog '/dataset/341b03d6-5be6-4c9b-b381-8cf692aa8830' 200

## dapla-spark
## read dataset meta
get $spark '/dataset-meta?name=skatt.person.2019.rawdata&operation=READ&userId=user1' 200
