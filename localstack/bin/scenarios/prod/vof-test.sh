#!/usr/bin/env bash

put $auth '/group/felles' '{
  "groupId": "felles",
  "description": "Brukere som skal teste enhetsregisteret data fra brreg.no",
  "roles": ["felles"]
}' 201

for user in "fenglin" \
  "sjur" \
  "simen" \
  "mehran" \
  "audun" \
  "anne" \
  "bjorn"; do

  put $auth "/role/user.$user" '{
    "roleId": "user.'$user'",
    "description": "Personlig rolle for '$user'",
    "paths": {
      "includes": ["/user/'$user'/","/kilde/brreg/enhetsreg/"]
    },
    "maxValuation": "SENSITIVE"
  }' 201

  put $auth "/user/$user@ssb.no" '{
    "userId": "'$user'@ssb.no",
    "roles": ["user.'$user'"],
    "groups": ["felles"]
  }' 201
done
