#!/usr/bin/env bash

# dataset-access
## create role for rawdata
put $auth '/role/skatt.person.rawdata' '{
  "roleId": "skatt.person.rawdata",
  "description": "",
  "privileges": {
    "includes": []
  },
  "paths": {
    "includes": ["/skatt/person"]
  },
  "maxValuation": "SENSITIVE",
  "states": {
    "excludes": ["OTHER"]
  }
}' 201

## create role for indata
put $auth '/role/skatt.person.inndata' '{
  "roleId": "skatt.person.inndata",
  "description": "",
  "privileges": {
    "includes": []
  },
  "paths": {
    "includes": ["/skatt/person"]
  },
  "maxValuation": "SENSITIVE",
  "states": {
    "excludes": ["RAW"]
  }
}' 201

## get roles
get $auth '/role/skatt.person.rawdata' 200
get $auth '/role/skatt.person.inndata' 200

## create groups
put $auth '/group/skatt.person.collect' '{
  "groupId": "skatt.person.collect",
  "description": "",
  "roles": ["skatt.person.rawdata"]
}' 201

# get groups
get $auth '/group/skatt.person.collect' 200

## create users
put $auth '/user/user1' '{ "userId" : "user1", "groups" : [ "skatt.person.collect" ] }' 201
put $auth '/user/user2' '{ "userId" : "user2", "roles" : [ "skatt.person.inndata" ] }' 201

## get user
get $auth '/user/user1' 200
get $auth '/user/user2' 200

## get access
## should have access
get $auth '/access/user1?privilege=READ&path=skatt/person&valuation=SENSITIVE&state=RAW' 200
get $auth '/access/user2?privilege=READ&path=skatt/person&valuation=SENSITIVE&state=INPUT' 200

## should not have access
get $auth '/access/user2?privilege=READ&path=skatt/person/inndata&valuation=SENSITIVE&state=RAW' 403

## dapla-catalog
## create dataset
post $catalog '/rpc/CatalogService/save' '{
  "dataset": {
    "id": {
      "path": "/skatt/person/rawdata-2019",
      "timestamp": "1582719098762"
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
target=$(dirname $BASH_SOURCE)/../../data/datastore/skatt/person/rawdata-2019/1582719098762
mkdir -p $target
cp $(dirname $BASH_SOURCE)/../testdata/skatt/person/rawdata-2019/1582719098762/*.parquet $target/.
