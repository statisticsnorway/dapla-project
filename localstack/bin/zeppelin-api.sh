#!/usr/bin/env bash

. $DAPLA_PROJECT_HOME/localstack/bin/validate.sh

zeppelin_cookie_file=zeppelin-cookies.txt
zeppelin_host=http://localhost:28010

# $1: zeppelin username
# $2: zeppelin password
function zeppelin_login {
    status=$(curl -X POST -s -c "$zeppelin_cookie_file" -d "userName=$1&password=$2" "$zeppelin_host/api/login" | jq -r '.status')
    if [ "$status" != "OK" ]
    then
        fail ERROR "Zeppelin login failed for user '$1' ($status)." || return 1
    fi
}

function zeppelin_logout {
    rm -f "$zeppelin_cookie_file"
}

function zeppelin_get {
    zeppelin_request 'GET' "$1" || return 1
}

function zeppelin_put {
    zeppelin_request 'PUT' "$1" "$2" || return 1
}

function zeppelin_post {
    zeppelin_request 'POST' "$1" "$2" || return 1
}

# $1: response json from zeppelin api
function response_status {
    local res="$1"
    validate_json "$res"
    # if [ $? -eq 0 $(validate_json ${res}) ]
    if [ $? -eq 0 ]
    then
        local status=$(echo $res | jq -r '.status')
        echo "$status"
    else
        echo "N/A"
    fi
}

# $1: method
# $2: api path, e.g "/api/interpreter"
# $3: body (optional)
function zeppelin_request {
    local api_path=${2#/}
    if [ -z $3 ]
    then
        local curl_command="curl -X $1 -s -b $zeppelin_cookie_file $zeppelin_host/$api_path"
    else
        local curl_command="curl -X $1 -s -b $zeppelin_cookie_file -d '$3' $zeppelin_host/$api_path"
    fi

    local response=$(eval $curl_command)

    if [ -n "$response" ]
    then
        echo "$response"
    fi

    status=$(response_status "${response}")
    if [ "$status" = "OK" ]
    then
        return 0
    else
        fail ERROR "Zeppelin request failed. Curl to reproduce:\n$curl_command"
        return 1
    fi

}