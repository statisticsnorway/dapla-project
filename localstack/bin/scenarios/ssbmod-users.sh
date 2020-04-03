#!/usr/bin/env bash

post $auth /rpc/RoleService/putRole '{"role":{
  "roleId": "read-all",
  "privileges": [
    "READ"
  ],
  "namespacePrefixes": [
    "/kilde",
    "/produkt"
  ],
  "maxValuation": "SENSITIVE",
  "states": ["RAW", "INPUT", "PROCESSED", "OUTPUT", "PRODUCT", "OTHER"]
}}' 200

post $auth /rpc/RoleService/putRole '{"role":{
  "roleId": "felles",
  "privileges": [
    "CREATE",
    "UPDATE",
    "READ",
    "DELETE"
  ],
  "namespacePrefixes": [
    "/felles/"
  ],
  "maxValuation": "SENSITIVE",
  "states": ["RAW", "INPUT", "PROCESSED", "OUTPUT", "PRODUCT", "OTHER"]
}}' 200

for user in "kim.gaarder" \
            "ove.ranheim" \
            "hadrien.kohl" \
            "trygve.falch" \
            "mehran.raja" \
            "ole.bredesen-vestby" \
            "oyvind.strommen" \
            "arild.takvam-borge" \
            "kenneth.schulstad" \
            "rune.lind" \
            "rannveig.aasen" \
            "magnus.myrdal.jenssen" \
            "marianne.mellem" \
            "bjorn-andre.skaar"
do
  post $auth /rpc/RoleService/putRole '{"role":{
  "roleId": "ssbmod.net.user.'$user'",
  "privileges": [
    "CREATE",
    "UPDATE",
    "READ",
    "DELETE"
  ],
  "namespacePrefixes": [
    "/user/'$user'@ssbmod.net/"
  ],
  "maxValuation": "SENSITIVE",
  "states": ["INPUT", "PROCESSED", "OUTPUT", "PRODUCT", "OTHER"]
}}' 200
  put $auth '/user/'$user'@ssbmod.net' '{
    "userId" : "'$user'@ssbmod.net",
    "roles" : [
          "read-all",
          "ssbmod.net.user.'$user'",
          "felles"
        ]
      }' 201
done
