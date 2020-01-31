#!/usr/bin/env bash

source $DAPLA_PROJECT_HOME/localstack/bin/_zeppelin-api.sh

zeppelin_login admin password1 || exit 1
printf "Restarting Spark interpreter... "
response=$(zeppelin_put "/api/interpreter/setting/restart/spark")

if [ $? -eq 0 ]
then
    echo "$(green OK)"
else
    echo "$response"
fi
zeppelin_logout