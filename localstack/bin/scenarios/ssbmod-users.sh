#!/usr/bin/env bash

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

for user in "kim.gaarder@ssbmod.net" \
            "ove.ranheim@ssbmod.net" \
            "hadrien.kohl@ssbmod.net" \
            "trygve.falch@ssbmod.net" \
            "mehran.raja@ssbmod.net" \
            "ole.bredesen-vestby@ssbmod.net" \
            "oyvind.strommen@ssbmod.net" \
            "arild.takvam-borge@ssbmod.net" \
            "kenneth.schulstad@ssbmod.net" \
            "rune.lind@ssbmod.net" \
            "rannveig.aasen@ssbmod.net" \
            "magnus.myrdal.jenssen@ssbmod.net" \
            "marianne.mellem@ssbmod.net" \
            "bjorn-andre.skaar@ssbmod.net"
do
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
  put $auth '/user/'$user '{ "userId" : "'$user'", "roles" : [ "tmp.'$user'", "tmp.public" ] }' 201
done
