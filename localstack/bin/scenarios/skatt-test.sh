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
  "states": ["RAW", "INPUT", "PROCESSED", "OUTPUT", "PRODUCT", "OTHER"]
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
  "states": ["INPUT", "PROCESSED", "OUTPUT", "PRODUCT", "OTHER"]
}}' 200

post $auth /rpc/RoleService/putRole '{"role":{
  "roleId": "tmp.public",
  "privileges": [
    "CREATE",
    "UPDATE",
    "READ",
    "DELETE"
  ],
  "namespacePrefixes": [
    "/tmp/public/"
  ],
  "maxValuation": "SENSITIVE",
  "states": ["RAW", "INPUT", "PROCESSED", "OUTPUT", "PRODUCT", "OTHER"]
}}' 200

## dataset-access
## get roles
post $auth /rpc/RoleService/getRole '{"roleId": "skatt.person.rawdata"}' 200
post $auth /rpc/RoleService/getRole '{"roleId": "skatt.person.inndata"}' 200
post $auth /rpc/RoleService/getRole '{"roleId": "tmp.public"}' 200


#
## dataset-access
## create and read users
for user in "arlid" "bjornandre" "hadrien" "kenneth" "kim" "mehran" "ove" "oyvind" "rune" "rupinder" "trygve"; do
  put $auth '/user/'$user '{ "userId" : "'$user'", "roles" : [ "skatt.person.rawdata", "tmp.public" ] }' 201
  get $auth '/user/'$user 200
done

## dataset-access
## get access
## should have access
get $auth '/access/arlid?privilege=READ&namespace=/skatt/person&valuation=SENSITIVE&state=RAW' 200
get $auth '/access/trygve?privilege=READ&namespace=/skatt/person&valuation=SENSITIVE&state=INPUT' 200

## should not have access
get $auth '/access/arlid?privilege=READ&namespace=/noaccess&valuation=SENSITIVE&state=RAW' 403

## Copy testdata to datastore folder
target=$(dirname $BASH_SOURCE)/../../data/datastore
rm -rf $target/skatt/person/rawdata-2019/1582719098762
mkdir -p $target/skatt/person/rawdata-2019/1582719098762
cp -r $(dirname $BASH_SOURCE)/../testdata/skatt/person/rawdata-2019/1582719098762 $target/skatt/person/rawdata-2019

## create dataset
post $distributor '/rpc/MetadataDistributorService/dataChanged' '{
  "projectId": "dapla",
  "topicName": "file-events-1",
  "parentUri": "file:///data/datastore",
  "path": "/skatt/person/rawdata-2019",
  "version": 1582719098762,
  "filename": ".dataset-meta.json"
}' 200
