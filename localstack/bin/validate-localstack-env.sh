#!/usr/bin/env bash

# Sanity check of required localstack environment settings
# This script exits with status code=0 if everything is aye-okay
source "$(dirname "$0")/validate.sh"

function validate_localstack_env {
    validate_env DAPLA_PROJECT_HOME "Should be the absolute path to your dapla-project directory" || return 1
    validate_silently "make --version" "make is not installed" || return 1
    validate_silently "mvn --version" "mvn is not installed" || return 1
    validate_silently "jq --version" "jq is not installed" || return 1
    validate_silently "base64 --help" "base64 is not installed" || return 1
    validate_silently "docker-compose --version" "docker-compose is not installed" || return 1
    validate_silently "ls $DAPLA_PROJECT_HOME/dapla-spark-plugin/secret/gcs_sa_test.json" "Missing GCS service account file. Expected to find in $DAPLA_PROJECT/dapla-spark-plugin/secret/gcs_sa_test.json" || return 1

    echo "Localstack environment seems to be $(green healthy)"
}

if [ -z $SKIP_EXEC ]
then
    validate_localstack_env
fi