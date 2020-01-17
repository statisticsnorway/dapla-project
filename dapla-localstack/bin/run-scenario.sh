#!/usr/bin/env bash

function print_usage {
  echo "Usage:"
  echo "  run-scenario.sh <cmd> <environment> <scenario>"
  echo
  echo "Examples:"
  echo "  ./run-scenario.sh exec local demo1"
  echo "  ./run-scenario.sh print staging demo1"
  echo
}

case $1 in
  print)
    WRAPPER_CMD=print
    ;;
  exec)
    WRAPPER_CMD=exec
    ;;
  "-h"|"--help"|*)
    print_usage
    exit 1
    ;;
esac

case $2 in
  local)
    auth=http://localhost:18080
    catalog=http://localhost:18070
    spark=http://localhost:18060
    TOKEN=
    ;;
  staing)
    if [ "a""" == "a""$TOKEN" ]; then
      echo Environment variable TOKEN must be set to a valid token.
      exit 1
    fi
    auth=https://dataset-access.staging-bip-app.ssb.no
    catalog=https://dapla-catalog.staging-bip-app.ssb.no
    spark=https://dapla-spark.staging-bip-app.ssb.no
    ;;
esac

. curl_wrapper.sh

. scenarios/"$3".sh
