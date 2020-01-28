#!/usr/bin/env sh

source $DAPLA_PROJECT_HOME/localstack/bin/zeppelin-api.sh
zeppelin_login admin password1
printf "Restarting Spark interpreter... "
zeppelin_put "/api/interpreter/setting/restart/spark" > /dev/null
printf "$(green OK)\n"
zeppelin_logout