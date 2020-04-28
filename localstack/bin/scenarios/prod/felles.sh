#!/usr/bin/env bash

put $auth '/role/felles' '{
  "roleId": "felles",
  "description": "",
  "privileges": {
    "includes": []
  },
  "paths": {
    "includes": ["/felles/"]
  },
  "maxValuation": "SENSITIVE"
}' 201

put $auth '/group/felles' '{
  "groupId": "felles",
  "description": "",
  "roles": ["felles"]
}' 201
