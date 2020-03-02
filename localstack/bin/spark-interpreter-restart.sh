#!/usr/bin/env bash

source $DAPLA_PROJECT_HOME/localstack/bin/zeppelin-api.sh

zeppelin_login admin admin || exit 1
printf "Restarting Spark interpreter... "
response=$(zeppelin_put "/api/interpreter/setting/restart/spark")

if [ $? -eq 0 ]
then
    echo "$(green OK)"
else
    echo "$response"
fi
zeppelin_logout