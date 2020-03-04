#!/usr/bin/env bash

# dataset-access
# create role for rawdata
post $auth /rpc/RoleService/putRole '{"role":{
  "roleId": "ske.rawdata",
  "privileges": [
    "CREATE",
    "UPDATE",
    "READ",
    "DELETE"
  ],
  "namespacePrefixes": [
    "/ske/"
  ],
  "maxValuation": "SENSITIVE",
  "states": ["RAW"]
}}' 200

post $auth /rpc/RoleService/putRole '{"role":{
  "roleId": "skatt.person.rawdata",
  "privileges": [
    "CREATE",
    "UPDATE",
    "READ",
    "DELETE"
  ],
  "namespacePrefixes": [
    "/skatt/person/"
  ],
  "maxValuation": "SENSITIVE",
  "states": ["RAW"]
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
    "/skatt/person/"
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
for user in "arild" "bjornandre" "hadrien" "kenneth" "kim" "mehran" "ove" "oyvind" "rune" "rupinder" "trygve" "rannveig" "marianne" "magnus"; do
  post $auth /rpc/RoleService/putRole '{"role":{
  "roleId": "tmp.'$user'",
  "privileges": [
    "CREATE",
    "UPDATE",
    "READ",
    "DELETE"
  ],
  "namespacePrefixes": [
    "/tmp/'$user'/"
  ],
  "maxValuation": "SENSITIVE",
  "states": ["RAW", "INPUT", "PROCESSED", "OUTPUT", "PRODUCT", "OTHER"]
}}' 200
  put $auth '/user/'$user '{ "userId" : "'$user'", "roles" : [ "tmp.'$user'", "tmp.public", "ske.rawdata", "skatt.person.rawdata", "skatt.person.inndata" ] }' 201
  get $auth '/user/'$user 200
  get $auth '/access/'$user'?privilege=READ&namespace=/skatt/person/some-dataset&valuation=SENSITIVE&state=RAW' 200
  get $auth '/access/'$user'?privilege=READ&namespace=/tmp/public/any-dataset&valuation=SENSITIVE&state=RAW' 200
done

## a user should not have access to another user's private tmp area
get $auth '/access/arlid?privilege=READ&namespace=/tmp/trygve/trygves-private-dataset&valuation=OPEN&state=PROCESSED' 403

## Copy testdata to datastore folder
target=$(dirname $BASH_SOURCE)/../../data/datastore
rm -rf $target/skatt/person/rawdata-2019/1582719098762
mkdir -p $target/skatt/person/rawdata-2019/1582719098762
cp -r $(dirname $BASH_SOURCE)/../testdata/skatt/person/rawdata-2019/1582719098762 $target/skatt/person/rawdata-2019

rm -rf $target/ske/sirius-person-utkast/2018v19/1583156472183
mkdir -p $target/ske/sirius-person-utkast/2018v19/1583156472183
cp -r $(dirname $BASH_SOURCE)/../testdata/ske/sirius-person-utkast/2018v19/1583156472183 $target/ske/sirius-person-utkast/2018v19

## create dataset
post $distributor '/rpc/MetadataDistributorService/dataChanged' '{
  "projectId": "dapla",
  "topicName": "file-events-1",
  "parentUri": "file:///data/datastore",
  "path": "/skatt/person/rawdata-2019",
  "version": 1582719098762,
  "filename": ".dataset-meta.json"
}' 200

post $distributor '/rpc/MetadataDistributorService/dataChanged' '{
  "projectId": "dapla",
  "topicName": "file-events-1",
  "parentUri": "file:///data/datastore",
  "path": "/ske/sirius-person-utkast/2018v19",
  "version": 1583156472183,
  "filename": ".dataset-meta.json"
}' 200
