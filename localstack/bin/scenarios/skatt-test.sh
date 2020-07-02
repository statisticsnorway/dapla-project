#!/usr/bin/env bash

# dataset-access

put $auth '/role/felles' '{
  "roleId": "felles",
  "paths": {
    "includes": ["/felles/"]
  },
  "maxValuation": "SENSITIVE"
}' 201

# create role for ske rawdata
put $auth '/role/ske.rawdata' '{
  "roleId": "ske.rawdata",
  "paths": {
    "includes": ["/ske/"]
  },
  "maxValuation": "SENSITIVE",
  "states": {
    "includes": ["RAW"]
  }
}' 201

# create role for skatt person rawdata
put $auth '/role/skatt.person.rawdata' '{
  "roleId": "skatt.person.rawdata",
  "paths": {
    "includes": ["/skatt/person/"]
  },
  "maxValuation": "SENSITIVE",
  "states": {
    "includes": ["RAW"]
  }
}' 201

# create role for skatt person indata
put $auth '/role/skatt.person.inndata' '{
  "roleId": "skatt.person.inndata",
  "paths": {
    "includes": ["/skatt/person/"]
  },
  "maxValuation": "SENSITIVE",
  "states": {
    "excludes": ["RAW"]
  }
}' 201

#create role for raw_ro
put $auth '/role/raw_ro' '{
  "roleId": "raw_ro",
  "privileges": {
    "includes": ["READ"]
  },
  "paths": {
    "includes": ["/raw/"]
  },
  "maxValuation": "SENSITIVE",
  "states": {
    "includes": ["RAW"]
  }
}' 201

## get roles
get $auth '/role/ske.rawdata' 200
get $auth '/role/skatt.person.rawdata' 200
get $auth '/role/skatt.person.inndata' 200
get $auth '/role/raw_ro' 200

## create groups
put $auth '/group/felles' '{
  "groupId": "felles",
  "roles": ["felles"]
}' 201

put $auth '/group/skatt-test' '{
  "groupId": "skatt-test",
  "roles": ["ske.rawdata", "skatt.person.rawdata", "skatt.person.inndata", "raw_ro"]
}' 201

# get groups
get $auth '/group/skatt-test' 200

## create and read users
for user in "fenglin" "olve" "jassin" "arild" "bjornandre" "hadrien" "kenneth" "kim" "mehran" "ove" "oyvind" "rune" "rupinder" "trygve" "rannveig" "marianne" "magnus"; do
  put $auth "/role/user.$user" '{
    "roleId": "user.'$user'",
    "paths": {
      "includes": ["/user/'$user'/"]
    },
    "maxValuation": "SENSITIVE"
  }' 201
  put $auth "/user/$user" '{
    "userId": "'$user'",
    "groups": ["felles", "skatt-test"],
    "roles": ["user.'$user'"]
  }' 201
  get $auth '/user/'$user 200
  get $auth '/access/'$user'?privilege=READ&path=/skatt/person/some-dataset&valuation=SENSITIVE&state=RAW' 200
  get $auth '/access/'$user'?privilege=READ&path=/user/'$user'/any-dataset&valuation=SENSITIVE&state=RAW' 200
done

## a user should not have access to another user's private tmp area
get $auth '/access/arlid?privilege=READ&path=/user/trygve/trygves-private-dataset&valuation=OPEN&state=PROCESSED' 403

## Copy testdata to datastore folder
target=$(dirname $BASH_SOURCE)/../../data/datastore
rm -rf $target/skatt/person/rawdata-2018/1583486170277
mkdir -p $target/skatt/person/rawdata-2018/1583486170277
cp -r $(dirname $BASH_SOURCE)/../testdata/skatt/person/rawdata-2018/1583486170277 $target/skatt/person/rawdata-2018

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
  "uri": "file:///data/datastore/skatt/person/rawdata-2019/1582719098762/.dataset-meta.json.sign"
}' 200

post $distributor '/rpc/MetadataDistributorService/dataChanged' '{
  "projectId": "dapla",
  "topicName": "file-events-1",
  "uri": "file:///data/datastore/ske/sirius-person-utkast/2018v19/1583156472183/.dataset-meta.json.sign"
}' 200
