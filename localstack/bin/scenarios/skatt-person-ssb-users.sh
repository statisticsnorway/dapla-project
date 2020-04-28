#!/usr/bin/env bash

# share
put $auth '/role/felles' '{
  "roleId": "felles",
  "description": "",
  "privileges": {
    "includes": []
  },
  "paths": {
    "includes": ["/felles/"]
  },
  "maxValuation": "INTERNAL",
  "states": {
    "excludes": ["RAW"]
  }
}' 201

# kilde skatteetaten skatt person
put $auth '/role/kilde.ske.skatt.person' '{
  "roleId": "kilde.ske.skatt.person",
  "description": "",
  "privileges": {
    "includes": []
  },
  "paths": {
    "includes": ["/kilde/ske/skatt/person/"]
  },
  "maxValuation": "SENSITIVE",
  "states": {
    "excludes": ["RAW"]
  }
}' 201

# skatt person rådata
put $auth '/role/kilde.ske.skatt.person.raadata' '{
  "roleId": "kilde.ske.skatt.person.raadata",
  "description": "",
  "privileges": {
    "includes": []
  },
  "paths": {
    "includes": ["/kilde/ske/skatt/person/raadata/"]
  },
  "maxValuation": "SENSITIVE",
  "states": {
    "includes": []
  }
}' 201

# produkt skatt person
put $auth '/role/produkt.skatt.person' '{
  "roleId": "produkt.skatt.person",
  "description": "",
  "privileges": {
    "includes": []
  },
  "paths": {
    "includes": ["/produkt/skatt/person/"]
  },
  "maxValuation": "SENSITIVE",
  "states": {
    "excludes": ["RAW"]
  }
}' 201

# /kilde/ske/skatt states: raw
put $auth '/role/raw_skatt_full' '{
  "roleId": "raw_skatt_full",
  "privileges": {
    "includes": []
  },
  "paths": {
    "includes": ["/kilde/ske/skatt/"]
  },
  "maxValuation": "SENSITIVE",
  "states": {
    "includes": ["RAW"]
  }
}' 201

put $auth '/group/skatt.person' '{
  "groupId": "skatt.person",
  "description": "",
  "roles": ["raw_full", "raw_skatt_full", "felles", "kilde.ske.skatt.person", "kilde.ske.skatt.person.raadata", "produkt.skatt.person"]
}' 201

for user in "rune.lind" \
  "aleksander.berge" \
  "ole.vangen" \
  "remy.brathen" \
  "ole.bredesen-vestby" \
  "simen.svenkerud" \
  "ane.seierstad" \
  "rolf.rolfsen" \
  "oda.torgan" \
  "ove.ranheim" \
  "kim.gaarder" \
  "bjorn.skaar" \
  "matz.ivan.faldmo"; do
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
    "groups": ["skatt.person"]
  }' 201
done
