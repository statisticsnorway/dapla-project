#!/usr/bin/env bash

. curl_wrapper.sh

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
    "skatt.person"
  ],
  "maxValuation": "SENSITIVE",
  "states": ["RAW", "INPUT", "PROCESSED", "OUTPUT", "PRODUCT"]
}' 201 || exit $?

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
    "skatt.person"
  ],
  "maxValuation": "SENSITIVE",
  "states": ["INPUT", "PROCESSED", "OUTPUT", "PRODUCT","OTHER"]
}' 201 || exit $?

## dataset-access
## get roles
get $auth /role/skatt.person.rawdata 200 || exit $?
get $auth /role/skatt.person.inndata 200 || exit $?


#
## dataset-access
## create users
put $auth '/user/user1' '{ "userId" : "user1", "roles" : [ "skatt.person.rawdata" ] }' 201 || exit $?

put $auth '/user/user2' '{ "userId" : "user2", "roles" : [ "skatt.person.inndata" ] }' 201 || exit $?

## dataset-access
## get user
get $auth '/user/user1' 200 || exit $?
get $auth '/user/user2' 200 || exit $?

## dataset-access
## get access
## should have access
get $auth '/access/user1?privilege=READ&namespace=skatt.person&valuation=SENSITIVE&state=RAW' 200 || exit $?
get $auth '/access/user2?privilege=READ&namespace=skatt.person&valuation=SENSITIVE&state=INPUT' 200 || exit $?

## should not have access
get $auth '/access/user2?privilege=READ&namespace=skatt.person&valuation=SENSITIVE&state=RAW' 403 || exit $?



## dapla-catalog
#
## map name to id
post $catalog '/name/skatt.person.2019.rawdata/341b03d6-5be6-4c9b-b381-8cf692aa8830' 200 || exit $?

## check mapping
get $catalog '/name/skatt.person.2019.rawdata' 200 || exit $?

## check listing
get $catalog '/prefix/skatt' 200 || exit $?

## create dataset
put $catalog '/dataset/341b03d6-5be6-4c9b-b381-8cf692aa8830' '{
  "id": {
    "id": "341b03d6-5be6-4c9b-b381-8cf692aa8830",
    "name": ["skatt.person.2019.rawdata"]
  },
  "state": "RAW",
  "locations": ["gs://dev-datalager-store/datastore/skatt/person/rawdata-2019"]
}' 201 || exit $?

## dapla-catalog
## read dataset
get $catalog '/dataset/341b03d6-5be6-4c9b-b381-8cf692aa8830' 200 || exit $?

## dapla-spark
## read dataset meta
get $spark '/dataset-meta?name=skatt.person.2019.rawdata&operation=READ&userId=user1' 200 || exit $?
