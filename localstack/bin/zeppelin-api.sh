#!/usr/bin/env sh

zeppelin_cookie_file=zeppelin-cookies.txt
zeppelin_host=http://localhost:28010

# $1 zeppelin username
# $2 zeppelin password
function zeppelin_login {
    status=$(curl -X POST -s -c "$zeppelin_cookie_file" -d "userName=$1&password=$2" "$zeppelin_host/api/login" | jq -r '.status')
    if [ "$status" != "OK" ]
    then
        die ERROR "Zeppelin login failed for user '$1' ($status)."
    fi
}

function zeppelin_logout {
    rm -f "$zeppelin_cookie_file"
}

function zeppelin_get {
    zeppelin_request 'GET' $1
}

function zeppelin_put {
    zeppelin_request 'PUT' $1 $2
}

function zeppelin_post {
    zeppelin_request 'POST' $1 $2
}

function green {
    printf '\e[32m%s\e[0m' $1
}

function red {
    printf '\e[31m%s\e[0m' $1
}

function die() {
    if [ "$1" = "ERROR" ]
    then
        echo "$(red 'ERROR: ') $2" 1>&2 
    else
        echo "$1$2" 1>&2 
    fi
    exit 1
}

# $1 method
# $2 api path, e.g "/api/interpreter"
# $3 body (optional)
function zeppelin_request {
    local api_path=${2#/}
    if [ -z $3 ]
    then
        local curl_command="curl -X $1 -s -b $zeppelin_cookie_file $zeppelin_host/$api_path"
    else
        local curl_command="curl -X $1 -s -b $zeppelin_cookie_file -d '$3' $zeppelin_host/$api_path"
    fi
    local response=$(eval $curl_command)
    local status=$(jq -r '.status' <<< $response)
    if [ "$status" != "OK" ]
    then
        die ERROR "Zeppelin request failed. Curl to reproduce:\n$curl_command"
    fi

    printf "%s" $response
}