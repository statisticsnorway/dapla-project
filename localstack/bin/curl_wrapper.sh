#!/usr/bin/env bash

function get {
  curl_invoke $WRAPPER_CMD GET "$3" "$1" "$2"
}

function put {
  curl_invoke $WRAPPER_CMD PUT "$4" "$1" "$2" "$3"
}

function post {
  curl_invoke $WRAPPER_CMD POST "$4" "$1" "$2" "$3"
}

function delete {
  curl_invoke $WRAPPER_CMD DELETE "$3" "$1" "$2"
}

function curl_invoke {
  local CURL_CMD="$1"
  if [ "a"$TOKEN != "a" ]; then
    local CURL_AUTH="-H 'Authorization: Bearer $TOKEN'"
  fi
  if [ "$2" != "GET" ]; then
    local CURL_METHOD="-X $2"
  fi
  local CURL_EXPECTED_HTTP_CODE="$3"
  local CURL_URL="$4$5"
  if [ "a"$TOKEN != "a" ]; then
    if [ "a""$6" != "a" ]; then
      REPRODUCE="curl -H 'Authorization: Bearer $TOKEN' -s $CURL_OPTIONS $CURL_METHOD -H 'Content-Type: application/json' --data-raw '$6' \"$CURL_URL\""
    else
      REPRODUCE="curl -H 'Authorization: Bearer $TOKEN' -s $CURL_OPTIONS $CURL_METHOD \"$CURL_URL\""
    fi
  else
    if [ "a""$6" != "a" ]; then
      REPRODUCE="curl -s $CURL_OPTIONS $CURL_METHOD -H 'Content-Type: application/json' --data-raw '$6' \"$CURL_URL\""
    else
      REPRODUCE="curl -s $CURL_OPTIONS $CURL_METHOD \"$CURL_URL\""
    fi
  fi
  case $CURL_CMD in
    print)
      echo "$REPRODUCE"
      ;;
    exec)
      echo $2 $CURL_EXPECTED_HTTP_CODE $CURL_URL "'$6'"
      if [ "a""$CURL_EXPECTED_HTTP_CODE" != "a" ]; then
        local CURL_OUTPUT="-o /dev/null -w %{http_code}"
        if [ "a"$TOKEN != "a" ]; then
          if [ "a""$6" != "a" ]; then
            local output=$(curl -H "Authorization: Bearer $TOKEN" -s $CURL_OUTPUT $CURL_OPTIONS $CURL_METHOD -H "Content-Type: application/json" --data-raw "$6" $CURL_URL)
          else
            local output=$(curl -H "Authorization: Bearer $TOKEN" -s $CURL_OUTPUT $CURL_OPTIONS $CURL_METHOD $CURL_URL)
          fi
        else
          if [ "a""$6" != "a" ]; then
            local output=$(curl -s $CURL_OUTPUT $CURL_OPTIONS $CURL_METHOD -H "Content-Type: application/json" --data-raw "$6" $CURL_URL)
          else
            local output=$(curl -s $CURL_OUTPUT $CURL_OPTIONS $CURL_METHOD $CURL_URL)
          fi
        fi
        if [ "a"$CURL_EXPECTED_HTTP_CODE == "a""$output" ]; then
          return 0
        else
          echo "FAILED, actual code was $output != $CURL_EXPECTED_HTTP_CODE. PUT $URL"
          echo "Run the following command to reproduce:"
          echo "$REPRODUCE"
          exit 1
        fi
      else
        if [ "a"$TOKEN != "a" ]; then
          if [ "a""$6" != "a" ]; then
            curl -H "Authorization: Bearer $TOKEN" -s $CURL_OUTPUT $CURL_OPTIONS $CURL_METHOD -H "Content-Type: application/json" --data-raw "$6" $CURL_URL
          else
            curl -H "Authorization: Bearer $TOKEN" -s $CURL_OUTPUT $CURL_OPTIONS $CURL_METHOD $CURL_URL
          fi
        else
          if [ "a""$6" != "a" ]; then
            curl -s $CURL_OUTPUT $CURL_OPTIONS $CURL_METHOD -H "Content-Type: application/json" --data-raw "$6" $CURL_URL
          else
            curl -s $CURL_OUTPUT $CURL_OPTIONS $CURL_METHOD $CURL_URL
          fi
        fi
      fi
      ;;
  esac
}