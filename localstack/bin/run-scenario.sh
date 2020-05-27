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
  dev)
    auth=http://localhost:10100
    catalog=http://localhost:10110
    distributor=http://localhost:10160
    daccess=http://localhost:10140
    exploration-lds=http://localhost:9091

    TOKEN=
    ;;
  local)

  response=$(
    curl -s -k -X POST 'http://localhost:28081/auth/realms/ssb/protocol/openid-connect/token' \
      --header 'Content-Type: application/x-www-form-urlencoded' \
      --data-urlencode 'grant_type=password' \
      --data-urlencode 'client_id=zeppelin' \
      --data-urlencode 'client_secret=ed48ee94-fe9d-4096-b069-9626a52877f2' \
      --data-urlencode 'username=raw' \
      --data-urlencode 'password=raw'
  )
  LTOKEN=$(jq -r .access_token <<< ${response})

    auth=http://localhost:20100
    catalog=http://localhost:20110
    distributor=http://localhost:20160
    daccess=http://localhost:20140
    exploration_lds=http://localhost:29091
    TOKEN=$LTOKEN
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
    distributor=https://metadata-distributor.staging-bip-app.ssb.no
    daccess=https://data-access.staging-bip-app.ssb.no
    ;;
  prod)
    if [ "a" == "a$TOKEN" ]; then
      echo
      echo Environment variable TOKEN must be set to a valid token.
      echo
      echo Run the following command using your own client-id and secret to obtain a valid token:
      echo
      echo "  $(dirname $BASH_SOURCE)/oauth2.sh -i <client-id> -s <secret> -c prod-bip-app -n dapla-user-access -t"
      echo
      exit 1
    fi
    auth=https://dapla-user-access.prod-bip-app.ssb.no
    catalog=https://dapla-catalog.prod-bip-app.ssb.no
    distributor=https://metadata-distributor.prod-bip-app.ssb.no
    daccess=https://data-access.prod-bip-app.ssb.no
    ;;
  *)
    echo "Not a valid environment: '$2'"
    exit 1
    ;;
esac

if [ "a" != "a$DAPLA_AUTH" ]; then
  auth=$DAPLA_AUTH
fi
if [ "a" != "a$DAPLA_CATALOG" ]; then
  catalog=$DAPLA_CATALOG
fi
if [ "a" != "a$DAPLA_DISTRIBUTOR" ]; then
  distributor=$DAPLA_DISTRIBUTOR
fi
if [ "a" != "a$DAPLA_DACCESS" ]; then
  daccess=$DAPLA_DACCESS
fi

. "$(dirname $BASH_SOURCE)/curl_wrapper.sh"

. "$(dirname $BASH_SOURCE)/scenarios/$3.sh"
