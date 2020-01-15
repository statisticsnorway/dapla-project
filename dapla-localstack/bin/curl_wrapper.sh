#!/usr/bin/env bash

if [ -z $TOKEN ]; then
  TOKEN="i_forgot_to_set_token"
fi
if [ -z $CURL_OPTIONS ]; then
  CURL_OPTIONS=""
fi

function get {
  URL="$1""$2"
  http_code=$(curl -s -o /dev/null -w "%{http_code}" $CURL_OPTIONS -H "Authorization: Bearer ${TOKEN}" "$URL")
  if [ "$3" == "$http_code" ]; then
    echo GET "$3" "$URL"
  else
    echo FAILED, actual code was "$http_code" != "$3". GET "$URL"
    return 1
  fi
}

function put {
  URL="$1""$2"
  http_code=$(curl -s -o /dev/null -w "%{http_code}" $CURL_OPTIONS -X PUT -H "Authorization: Bearer ${TOKEN}" -H "Content-Type: application/json" --data-raw "$3" "$URL")
  if [ "$4" == "$http_code" ]; then
    echo PUT "$4" "$URL" "$3"
  else
    echo FAILED, actual code was "$http_code" != "$4". PUT "$URL"
    return 1
  fi
}

function post {
  URL="$1""$2"
  http_code=$(curl -s -o /dev/null -w "%{http_code}" $CURL_OPTIONS -X POST -H "Authorization: Bearer ${TOKEN}" "$URL")
  if [ "$3" == "$http_code" ]; then
    echo POST "$3" "$URL"
  else
    echo FAILED, actual code was "$http_code" != "$3". POST "$URL"
    return 1
  fi
}
