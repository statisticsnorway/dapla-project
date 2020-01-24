#!/usr/bin/env bash

# Sanity check of required localstack environment settings
# This script exits with status code=0 if everything is aye-okay

function validate_env () {
    value=$(eval echo \$$1)
    if [ -z ${value} ]
    then
        die "ERROR: Required environment variable \$$1 not set. $2"
    fi
}

function validate () {
    eval $1 > /dev/null
    if [ $? -ne 0 ]; then
        die "ERROR: $2"
    fi
}

function die() {
    echo $1
    exit 1
}

validate_env DAPLA_PROJECT_HOME "Should be the absolute path to your dapla-project directory"
validate "make --version" "make is not installed"
validate "mvn --version" "mvn is not installed"
validate "ls $DAPLA_PROJECT_HOME/dapla-spark-plugin/secret/gcs_sa_test.json" "Missing GCS service account file. Expected to find in $DAPLA_PROJECT/dapla-spark-plugin/secret/gcs_sa_test.json"

echo "Localstack environment settings seems to be healthy ✅"