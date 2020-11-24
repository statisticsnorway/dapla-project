#!/usr/bin/env bash

put $auth '/group/vof' '{
  "groupId": "vof",
  "description": "Brukere som skal teste PST sin veileder. JIRA: SKATT-216",
  "roles": ["felles"]
}' 201

for user in "fenglin.han" \
  "sjur.sagen" \
  "simen.sommer" \
  "mehran.raja" \
  "audun.rusti" \
  "anne.harbosen" \
  "bjorn.skaar"; do

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
    "groups": ["vof"]
  }' 201
done
