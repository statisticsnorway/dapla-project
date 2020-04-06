#!/usr/bin/env bash

# share
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
  "maxValuation": "INTERNAL",
  "states": ["INPUT", "PROCESSED", "OUTPUT", "PRODUCT", "OTHER"]
}}' 200

# kilde skatteetaten skatt person
post $auth /rpc/RoleService/putRole '{"role":{
  "roleId": "kilde.ske.skatt.person",
  "privileges": [
    "CREATE",
    "UPDATE",
    "READ",
    "DELETE"
  ],
  "namespacePrefixes": [
    "/kilde/ske/skatt/person"
  ],
  "maxValuation": "SENSITIVE",
  "states": ["INPUT", "PROCESSED", "OUTPUT", "PRODUCT", "OTHER"]
}}' 200

# skatt person rådata
post $auth /rpc/RoleService/putRole '{"role":{
  "roleId": "kilde.ske.skatt.person.rådata",
  "privileges": [
    "CREATE",
    "UPDATE",
    "READ",
    "DELETE"
  ],
  "namespacePrefixes": [
    "/kilde/ske/skatt/person/rådata"
  ],
  "maxValuation": "SENSITIVE",
  "states": ["RAW", "INPUT", "PROCESSED", "OUTPUT", "PRODUCT", "OTHER"]
}}' 200

# produkt skatt person
post $auth /rpc/RoleService/putRole '{"role":{
  "roleId": "produkt.skatt.person",
  "privileges": [
    "CREATE",
    "UPDATE",
    "READ",
    "DELETE"
  ],
  "namespacePrefixes": [
    "/produkt/skatt/person"
  ],
  "maxValuation": "SENSITIVE",
  "states": ["INPUT", "PROCESSED", "OUTPUT", "PRODUCT", "OTHER"]
}}' 200

# /kilde/ske/skatt states: raw
post $auth /rpc/RoleService/putRole '{"role":{
  "roleId": "raw_skatt_full",
  "privileges": [
    "CREATE",
    "UPDATE",
    "READ",
    "DELETE"
  ],
  "namespacePrefixes": [
    "/kilde/ske/skatt"
  ],
  "maxValuation": "SENSITIVE",
  "states": ["RAW"]
}}' 200

for user in "rune.lind" \
            "aleksander.berg" \
            "ole.vangen" \
            "remy.brathen" \
            "ole.bredesen-vestby" \
            "simen.svenkerud" \
            "ane.seierstad" \
            "rolf.rolfsen" \
            "oda.torgan" \
            "ove.ranheim" \
            "kim.gaarder" \
            "bjorn-andre.skaar" \
            "matz.ivan.faldmo"
do
  post $auth /rpc/RoleService/putRole '{"role":{
  "roleId": "user.'$user'",
  "privileges": [
    "CREATE",
    "UPDATE",
    "READ",
    "DELETE"
  ],
  "namespacePrefixes": [
    "/user/'$user'/"
  ],
  "maxValuation": "SENSITIVE",
  "states": ["INPUT", "PROCESSED", "OUTPUT", "PRODUCT", "OTHER"]
}}' 200
  put $auth '/user/'$user@ssb.no '{ "userId" : "'$user@ssb.no'",
    "roles" : [
          "raw_full",
          "user.'$user'",
          "felles",
          "kilde.ske.skatt.person",
          "kilde.ske.skatt.person.rådata",
          "produkt.skatt.person",
          "raw_skatt_full"
        ]
      }' 201
done
