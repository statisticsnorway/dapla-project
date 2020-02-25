#!/usr/bin/env bash

# dataset-access
# create role for rawdata
post $auth /rpc/RoleService/putRole '{"role":{
  "roleId": "skatt.person.rawdata",
  "privileges": [
    "CREATE",
    "UPDATE",
    "READ",
    "DELETE"
  ],
  "namespacePrefixes": [
    "/skatt/person"
  ],
  "maxValuation": "SENSITIVE",
  "states": ["RAW", "INPUT", "PROCESSED", "OUTPUT", "PRODUCT"]
}}' 200

# create role for indata
post $auth /rpc/RoleService/putRole '{"role":{
  "roleId": "skatt.person.inndata",
  "privileges": [
    "CREATE",
    "UPDATE",
    "READ",
    "DELETE"
  ],
  "namespacePrefixes": [
    "/skatt/person"
  ],
  "maxValuation": "SENSITIVE",
  "states": ["INPUT", "PROCESSED", "OUTPUT", "PRODUCT","OTHER"]
}}' 200

## dataset-access
## get roles
post $auth /rpc/RoleService/getRole '{"roleId": "skatt.person.rawdata"}' 200
post $auth /rpc/RoleService/getRole '{"roleId": "skatt.person.inndata"}' 200


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
get $auth '/access/user1?privilege=READ&namespace=skatt/person&valuation=SENSITIVE&state=RAW' 200
get $auth '/access/user2?privilege=READ&namespace=skatt/person&valuation=SENSITIVE&state=INPUT' 200

## should not have access
get $auth '/access/user2?privilege=READ&namespace=skatt/person&valuation=SENSITIVE&state=RAW' 403

## create dataset
post $catalog '/rpc/CatalogService/save' '{
  "dataset": {
    "id": {
      "path": "/skatt/person/rawdata-2019"
    },
    "type": "BOUNDED",
    "valuation": "SHIELDED",
    "state": "RAW",
    "parentUri": "file:///data/datastore"
  },
  "userId": "user1"
}' 200

## dapla-catalog
## read dataset
post $catalog '/rpc/CatalogService/get' '{"path": "/skatt/person/rawdata-2019"}' 200

## check listing
post $catalog '/rpc/CatalogService/listByPrefix' '{
  "prefix": "/skatt/person",
  "limit": 10
}' 200

## Copy testdata to datastore folder
target=$(dirname $BASH_SOURCE)/../../data/datastore/skatt/person/rawdata-2019
mkdir -p $target
cp $(dirname $BASH_SOURCE)/../testdata/*.parquet $target/.
