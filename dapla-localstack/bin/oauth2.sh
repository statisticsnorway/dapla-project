#!/usr/bin/env bash
#
# Example script to fetch OAuth/OpenID tokens from Keycloak using "client
# credentials" and to use the returned access token to query an API.
#
# Dependencies:
#
#   curl - for web queries
#   jq   - for filtering and formatting JSON output.
#
# Notes:
# 
#   To use "client credentials" you need to enable "service accounts" on the
#   OIDC client in Keycloak.
#
# Todo:
#
#  Add support for using script with grant type "password".


# Show usage
usage () {
    if [ -n "$1" ]
    then
        echo "$1"
    fi

    cat << EOP

$0 -n|--service   <name>              (mandatory)
   -i|--id        <client id>         (mandatory)
   -s|--secret    <client secret>     (mandatory)
   -c|--cluster   <cluster name>      (default staging-bip-app)
   -p|--path      <service URL path>  (default health)
   -v|--verbose                       (default non-verbose)
   -t|--print-token-only
   -h|--help"

Example:

  $0 -n lds -i workbench -s some-secret -p "/ns/Agent?schema" -c staging-bip-app -v
EOP

    exit 0
}


# Domain
domain=ssb.no

# Google Cloud GKE cluster name
cluster=staging-bip-app

# Set to one to output tokens received from Keycloak.
verbose=0

# Service endpoint
path="/health"


# Read commandline arguments
while [ "$1" != "" ]
do
    case $1 in
        -n | --service ) shift
                         service=$1
                         ;;
        -i | --id )      shift
                         client_id=$1
                         ;;
        -s | --secret )  shift
                         client_secret=$1
                         ;;
        -c | --cluster )  shift
                         cluster=$1
                         ;;
        -p | --path )    shift
                         path=$1
                         ;;
        -v | --verbose ) verbose=1
                         ;;
        -t | --token-only ) verbose=2
                         ;;
        -h | --help )    usage
                         exit
                         ;;
        * )              usage
                         exit 1
    esac
    shift
done


# Name of service/api to query.
if [ -z "$service" ]
then
    usage "Missing name of \"service\" to call"
fi

# Public OAuth client ID required for querying keycloak.
if [ -z "$client_id" ]
then
    usage "Missing OIDC \"client id\""
fi

# The OAuth client secret needs to be kept confidential.
if [ -z "$client_secret" ]
then
    usage "Missing OIDC \"client secret\""
fi


# Keycloak instance to fetch tokens from.
keycloak=keycloak.${cluster}.${domain}

# URL to service
url="https://${service}.${cluster}.${domain}"


# Authentication with Keycloak when using "client credentials" require the
# client to send credentials in the Authorization header.
basic_auth=$(echo -n "${client_id}:${client_secret}" | base64)

# Request Tokens
response=$(
  curl -s -k -X POST \
       -H "Content-Type: application/x-www-form-urlencoded" \
       -H "Authorization: Basic ${basic_auth}" \
       -d "grant_type=client_credentials" \
       -d "scope=openid profile email" \
       "https://$keycloak/auth/realms/ssb/protocol/openid-connect/token"
)

# Verbose output display all tokens nicely formatted.
if [ $verbose -eq 0 ]
then
    # Extract and print the access token from the response.
    # This is the token to use when querying the API.
    access_token=$(echo "${response}"  | jq -r .access_token)
    echo "${access_token}"  | cut -d"." -f2
    curl -H "Authorization: Bearer ${access_token}" "${url}${path}"

elif [ $verbose -eq 1 ]
then
    access_token=$(echo "${response}"  | jq -r .access_token)
    id_token=$(echo "${response}"      | jq -r .id_token)
    refresh_token=$(echo "${response}" | jq -r .refresh_token)

    echo "${access_token}"  | cut -d"." -f2 | base64 -d | jq .
    echo "${id_token}"      | cut -d"." -f2 | base64 -d | jq .
    echo "${refresh_token}" | cut -d"." -f2 | base64 -d | jq .

    # Print example URL showing how to use the access token obtained from
    # Keycloak to query an API using curl.
    echo curl -H \"Authorization: Bearer "${access_token}"\" \""${url}${path}"\"
elif [ $verbose -eq 2 ]
then
    access_token=$(echo "${response}"  | jq -r .access_token)
    echo "${access_token}"
fi

exit 0
