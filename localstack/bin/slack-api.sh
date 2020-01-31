#!/usr/bin/env sh

function slack_message() {
    local payload="{\"text\": \"$1\" }"
    curl -X POST -H 'Content-type: application/json' --data "$payload" https://hooks.slack.com/services/${DAPLA_LOCALSTACK_SLACK_API_KEY}
}
