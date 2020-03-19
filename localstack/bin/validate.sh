#!/usr/bin/env bash

function validate_env {
    value=$(eval echo \$$1)
    if [ -z ${value} ]
    then
        fail ERROR "Required environment variable \$$1 not set. $2"
    fi
}

function validate_silently {
    eval $1 > /dev/null
    if [ $? -ne 0 ]; then
        fail ERROR "$2"
    fi
}

function validate {
    echo "$1"
    eval $1
    if [ $? -ne 0 ]; then
        fail ERROR "$2"
        return 1
    fi
}

function validate_json {
    echo "$1" | jq -r empty >/dev/null
    case $? in
        0) return 0 ;;
        *) return 1 ;;
    esac
}

function green {
    printf '\e[32m%s\e[0m' "$1"
}

function red {
    printf '\e[31m%s\e[0m' "$1"
}

function bold {
    printf '\e[1m%s\e[0m' "$1"
}

function underline {
    printf '\e[4m%s\e[0m' "$1"
}

function print_exit_message {
    case $1 in
      ERROR)
        echo "$(red 'ERROR:') $2"
        ;;
      OK|SUCCESS)
        echo "$(red 'SUCCESS:') $2"
        ;;
      *)
        echo "$1$2"
        ;;
    esac
}

function fail {
    print_exit_message "$1" "$2"
    return 1
}

