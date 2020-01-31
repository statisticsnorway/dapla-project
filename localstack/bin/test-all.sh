#!/usr/bin/env sh

# -----------------------------------------------------------------------------
# CONFIG
# -----------------------------------------------------------------------------

# Add scenarios to be skipped here
skipped_scenarios=(pseudo)

# Add notes to be skipped here
skipped_note_samples=("sample-pseudo sample-pseudo-py")


# -----------------------------------------------------------------------------
# FUNCTIONS
# -----------------------------------------------------------------------------

function run_all_scenarios() {
    for file in $DAPLA_PROJECT_HOME/localstack/bin/scenarios/*.sh
    do
        scenario=${file##*/}
        scenario=${scenario%.sh}
        if [[ " ${skipped_scenarios} " =~ " ${scenario} " ]]; then
            echo "Skipping scenario $scenario"
        else
            validate "make run-scenario s=$scenario" "Error running scenario '$scenario'" || return 1
            echo "Scenario '$scenario' - $(green OK)"
        fi
    done
}

function run_all_zeppelin_samples() {
    echo "Running zeppelin sample notes"
    zeppelin_login user1 password2

    for file in $(find $DAPLA_PROJECT_HOME/localstack/docker/zeppelin/notebook-samples -name note.json);
    do
        local note_id=$(jq -r '.id' $file)
        if [[ " ${skipped_note_samples} " =~ " ${note_id} " ]]; then
            echo "Skipping note $note_id"
        else
            zeppelin_run_note_async $note_id || return 1
        fi
    done

    rm -f "$cookie_file"
}

# $1 note_id
function zeppelin_run_note_async {
    local note_id=$1
    printf "Running note '%s'..." $note_id
    local response=$(zeppelin_post "api/notebook/job/$note_id")
    local status=$(echo "$response" | jq -r '.status')

    if [ "$status" = "OK" ]
    then
        printf "$(green OK)\n"
    else
        printf "$(red ERROR)\n"
        echo "$response"
        return 1
    fi
}

function notify_build_ok {
    slack_message "Localstack is OK"
}

function notify_build_error {
    slack_message "Local stack build problems$1"
}

function test_all {
    validate_localstack_env || return 1
    validate "make update-all" "Unable to update all projects" || return 1
    validate "make build-all" "There were build errors" || return 1
    validate "make stop-all" "Unable to stop docker containers" || return 1
    validate "make start-all" "Error starting the localstack environment" || return 1
    sleep 20 # Sleeping for 20 seconds for containers to initialize
    run_all_scenarios || return 1
    run_all_zeppelin_samples || return 1
}

# $1 the log
function sanitize_console_log {
    echo "$1" | sed -E "s/"$'\E'"\[([0-9]{1,3}((;[0-9]{1,3})*)?)?[m|K]//g" | sed "s/\"/'/g"
}


# -----------------------------------------------------------------------------
# MAIN
# -----------------------------------------------------------------------------


if [ -z $DAPLA_PROJECT_HOME ]
then
    echo "\$DAPLA_PROJECT_HOME must be set. Should be the absolute path to your dapla-project directory."
    exit 1
fi

. $DAPLA_PROJECT_HOME/localstack/bin/validate.sh
. $DAPLA_PROJECT_HOME/localstack/bin/slack-api.sh
. $DAPLA_PROJECT_HOME/localstack/bin/_zeppelin-api.sh
SKIP_EXEC=true . $DAPLA_PROJECT_HOME/localstack/bin/_validate-localstack-env.sh

cd $DAPLA_PROJECT_HOME/localstack

console_log=$(test_all)
status=$?
echo "$console_log"

if [ $status -ne 0 ];
then
    sanitized_console_log=$(sanitize_console_log "${console_log}")
    notify_build_error ". Console log:\n\`\`\`$sanitized_console_log\`\`\`"
else
    notify_build_ok
fi


