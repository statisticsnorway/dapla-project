#!/usr/bin/env sh

zeppelin_host=http://localhost:28010
cookie_file=zeppelin-cookies.txt

printf "Zeppelin login... "
status=$(curl -X POST -s -c "$cookie_file" -d 'userName=admin&password=password1' "$zeppelin_host/api/login" | jq -r '.status')

if [ "${status}" = "OK" ]
then
    printf "${status}\nRestart Zeppelin Spark interpreter... "
    status=$(curl -X PUT -s -b "$cookie_file" "$zeppelin_host/api/interpreter/setting/restart/spark" | jq -r '.status')
fi
printf "${status:-ERROR}\n"

rm -f "$cookie_file"
