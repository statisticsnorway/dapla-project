#!/usr/bin/env bash

for i in $(find docker/gsim/examples/_main -type f); do
  ENTITY=$(echo "$i" | sed 's:docker/gsim/examples/_main/::' | sed 's:\([^_]*\).*:\1:')
  ID=$(jq -r .id "$i")
  curl -i -X PUT http://localhost:29091/ns/"${ENTITY}"/"${ID}" --data-binary "@$i" &
done

wait
