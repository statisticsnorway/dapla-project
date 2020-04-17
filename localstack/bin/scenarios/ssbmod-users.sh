#!/usr/bin/env bash

put $auth '/role/read-all' '{
  "roleId": "read-all",
  "description": "",
  "privileges": {
    "includes": ["READ"]
  },
  "paths": {
    "includes": ["/kilde", "/produkt"]
  },
  "maxValuation": "SENSITIVE",
  "states": {
    "includes": []
  }
}' 201

put $auth '/role/felles' '{
  "roleId": "felles",
  "description": "",
  "privileges": {
    "includes": []
  },
  "paths": {
    "includes": ["/felles"]
  },
  "maxValuation": "SENSITIVE",
  "states": {
    "includes": []
  }
}' 201

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
  "bjorn-andre.skaar"; do
  put $auth "/role/ssbmod.net.user.$user" '{
    "roleId": "ssbmod.net.user.'$user'",
    "description": "",
    "privileges": {
      "includes": []
    },
    "paths": {
      "includes": ["/user/'$user'@ssbmod.net"]
    },
    "maxValuation": "SENSITIVE",
    "states": {
      "includes": []
    }
  }' 201
  put $auth "/user/$user@ssbmod.net" '{ "userId" : "'$user'@ssbmod.net", "roles" : [ "ssbmod.net.user.'$user'", "felles", "read-all" ] }' 201
done
