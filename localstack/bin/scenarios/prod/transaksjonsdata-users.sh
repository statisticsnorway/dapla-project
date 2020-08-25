#!/usr/bin/env bash

# kilde transaksjonsdata
put $auth '/role/kilde.<navn_på_kilde>.transaksjonsdata' '{
  "roleId": "kilde.<navn_på_kilde>.transaksjonsdata",
  "description": "",
  "privileges": {
    "includes": []
  },
  "paths": {
    "includes": ["/kilde/navn_på_kilde/transaksjonsdata/"]
  },
  "maxValuation": "SENSITIVE",
  "states": {
    "excludes": ["RAW"]
  }
}' 201

# transaksjonsdata rådata
put $auth '/role/kilde.<navn_på_kilde>.transaksjonsdata.raadata' '{
  "roleId": "kilde.<navn_på_kilde>.transaksjonsdata.raadata",
  "description": "",
  "privileges": {
    "includes": [ "READ" ]
  },
  "paths": {
    "includes": [
      "/kilde/<navn_på_kilde>/transaksjonsdata/<versjon>/rådata/"
    ]
  },
  "maxValuation": "SENSITIVE",
  "states": {
    "includes": ["RAW"]
  }
}' 201

put $auth '/group/<navn_på_kilde>.transaksjonsdata' '{
  "groupId": "<navn_på_kilde>.transaksjonsdata",
  "description": "",
  "roles": ["kilde.<navn_på_kilde>.transaksjonsdata.raadata", "kilde.<navn_på_kilde>.transaksjonsdata"]
}' 201

for user in "emil.elias.traaholt.vagnes@ssb.no" \
"johannes.hansen@ssb.no" \
"boriska.toth@ssb.no" \
"knut.linnerud@ssb.no" \
"kristin.egge-hoveid@ssb.no" \
"anne.louisa.croos@ssb.no" ; do

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
    "groups": ["felles", "<navn_på_kilde>.transaksjonsdata"]
  }' 201
done
