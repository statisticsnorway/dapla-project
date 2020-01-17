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
  staging)
    if [ "a" == "a$TOKEN" ]; then
      echo
      echo Environment variable TOKEN must be set to a valid token.
      echo
      echo Run the following command using your own client-id and secret to obtain a valid token:
      echo
      echo "  $(dirname $BASH_SOURCE)/oauth2.sh -i <client-id> -s <secret> -c staging-bip-app -n dataset-access -t"
      echo
      exit 1
    fi
    auth=https://dataset-access.staging-bip-app.ssb.no
    catalog=https://dapla-catalog.staging-bip-app.ssb.no
    spark=https://dapla-spark.staging-bip-app.ssb.no
    ;;
  *)
    echo "Not a valid environment: '$2'"
    exit 1
    ;;
esac

. "$(dirname $BASH_SOURCE)/curl_wrapper.sh"

. "$(dirname $BASH_SOURCE)/scenarios/$3.sh"
