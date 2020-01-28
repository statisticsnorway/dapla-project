#!/usr/bin/env bash

# Sanity check of required localstack environment settings
# This script exits with status code=0 if everything is aye-okay

function validate_env () {
    value=$(eval echo \$$1)
    if [ -z ${value} ]
    then
        die ERROR "Required environment variable \$$1 not set. $2"
    fi
}

function validate_silently () {
    eval $1 > /dev/null
    if [ $? -ne 0 ]; then
        die ERROR $2
    fi
}

function validate () {
    eval $1
    if [ $? -ne 0 ]; then
        die ERROR $2
    fi
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
        echo "$(red 'ERROR: ') $2"
    else
        echo "$1$2"
    fi
    exit 1
}


validate_env DAPLA_PROJECT_HOME "Should be the absolute path to your dapla-project directory"
validate_silently "make --version" "make is not installed"
validate_silently "mvn --version" "mvn is not installed"
validate_silently "jq --version" "jq is not installed"
validate_silently "docker-compose --version" "docker-compose is not installed"
validate_silently "ls $DAPLA_PROJECT_HOME/dapla-spark-plugin/secret/gcs_sa_test.json" "Missing GCS service account file. Expected to find in $DAPLA_PROJECT/dapla-spark-plugin/secret/gcs_sa_test.json"

printf "Localstack seems to be $(green healthy)\n"