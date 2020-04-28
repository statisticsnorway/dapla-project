#!/usr/bin/env bash

put $auth '/group/datastammen' '{
  "groupId": "datastammen",
  "description": "",
  "roles": [""]
}' 201

for user in "trygve.falch" \
  "kim.gaarder" \
  "magnus.jenssen" \
  "hadrien.kohl" \
  "rune.lind" \
  "marianne.mellem" \
  "mehran.raja" \
  "ove.ranheim" \
  "kenneth.schulstad" \
  "bjorn.skaar" \
  "oyvind.strommen" \
  "arild.takvam-borge" \
  "rannveig.aasen"; do

  put $auth "/role/user.$user" '{
    "roleId": "user.'$user'",
    "description": "",
    "privileges": {
      "includes": []
    },
    "paths": {
      "includes": ["/user/'$user'/"]
    },
    "maxValuation": "SENSITIVE",
    "states": {
      "excludes": ["RAW"]
    }
  }' 201

  put $auth "/user/$user@ssb.no" '{
    "userId": "'$user'@ssb.no",
    "roles": ["user.'$user'"],
    "groups": ["felles", "datastammen"]
  }' 201
done
