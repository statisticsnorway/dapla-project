#!/usr/bin/env bash

function print_usage {
  echo "Usage:"
  echo "  run-scenario.sh <environment> <scenario>"
  echo
  echo "Examples:"
  echo "  ./run-scenario.sh local demo1"
  echo "  ./run-scenario.sh staging demo1"
  echo
}

if [ "$1" == "local" ]; then
  auth=http://localhost:18080
  catalog=http://localhost:18070
  spark=http://localhost:18060
elif [ "$1" == "staging" ]; then
  if [ "a""" == "a""$TOKEN" ]; then
    echo Environment variable TOKEN must be set to a valid token.
    exit 1
  fi
  auth=https://dataset-access.staging-bip-app.ssb.no
  catalog=https://dapla-catalog.staging-bip-app.ssb.no
  spark=https://dapla-spark.staging-bip-app.ssb.no
elif [ "$1" == "-h" ]; then
  print_usage
  exit 1
elif [ "$1" == "--help" ]; then
  print_usage
  exit 1
else
  print_usage
  exit 1
fi

. scenarios/demo1.sh
