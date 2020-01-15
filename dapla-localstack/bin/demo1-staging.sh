#!/usr/bin/env bash

if [ "a""" == "a""$TOKEN" ]; then
  echo Environment variable TOKEN must be set to a valid token.
  exit 1
fi

auth=https://dataset-access.staging-bip-app.ssb.no
catalog=https://dapla-catalog.staging-bip-app.ssb.no
spark=https://dapla-spark.staging-bip-app.ssb.no

. _demo1.sh