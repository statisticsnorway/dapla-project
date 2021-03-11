#!/usr/bin/env bash

for i in $(find docker/exploration/examples/_main -type f); do
  ENTITY=$(echo "$i" | sed 's:docker/exploration/examples/_main/::' | sed 's:\([^_]*\).*:\1:')
  ID=$(jq -r .id "$i")
  curl -X PUT http://localhost:29091/ns/"${ENTITY}"/"${ID}" -d "@$i" -H "Content-Type: application/json"
done

wait
