#!/usr/bin/env bash

put $auth '/group/pst-veileder-test' '{
  "groupId": "pst-veileder-test",
  "description": "Brukere som skal teste PST sin veileder. JIRA: SKATT-216",
  "roles": ["felles"]
}' 201

for user in "Christine.Rokkan" \
  "Anders.Whist" \
  "Inge.Aukrust" \
  "Christian.Brovold" \
  "Arve.Hetland" \
  "erik.h.nymoen" \
  "Elisabeth.Omholt"; do

  put $auth "/role/user.$user" '{
    "roleId": "user.'$user'",
    "description": "Personlig rolle for '$user'",
    "paths": {
      "includes": ["/user/'$user'/"]
    },
    "maxValuation": "SENSITIVE"
  }' 201

  put $auth "/user/$user@ssb.no" '{
    "userId": "'$user'@ssb.no",
    "roles": ["user.'$user'"],
    "groups": ["pst-veileder-test"]
  }' 201
done
