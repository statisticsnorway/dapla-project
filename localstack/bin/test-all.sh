#!/usr/bin/env sh

# -----------------------------------------------------------------------------
# CONFIG
# -----------------------------------------------------------------------------

# Add scenarios to be skipped here
skipped_scenarios=(pseudo)

# Add notes to be skipped here
skipped_note_samples=()


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
            validate "make run-scenario s=$scenario" "Error running scenario $scenario"
            echo "Scenario $scenario - $(green OK)" 
        fi
    done
}

function run_all_samples() {
    zeppelin_login user1 password2

    for file in $(find $DAPLA_PROJECT_HOME/localstack/docker/zeppelin/notebook-samples -name note.json);
    do
        local note_id=$(jq -r '.id' $file)
        if [[ " ${skipped_note_samples} " =~ " ${note_id} " ]]; then
            echo "Skipping note $note_id" 
        else
            run_note_async $note_id
        fi
    done

    rm -f "$cookie_file"
}

# Assumes a valid zeppelin cookie is present
# $1 note_id
function run_note() {
    printf "Running note '%s'...\n" $note_id
    local paragraph_no=1
    for paragraph_id in $(zeppelin_get "api/notebook/$note_id" | jq -r '.body.paragraphs[].id'):
    do
        printf "* Paragraph #$paragraph_no ($paragraph_id)"
        zeppelin_post "api/notebook/run/$note_id/$paragraph_id"
        printf "$(green OK)\n"
        ((paragraph_no++))
    done
}

# Assumes a valid zeppelin cookie is present
# $1 note_id
function run_note_async() {
    printf "Running note '%s'..." $note_id
    zeppelin_post "api/notebook/job/$note_id" > /dev/null
    printf "$(green OK)\n"
}


# -----------------------------------------------------------------------------
# MAIN
# -----------------------------------------------------------------------------

source $DAPLA_PROJECT_HOME/localstack/bin/validate-localstack-env.sh
source $DAPLA_PROJECT_HOME/localstack/bin/zeppelin-api.sh
cd $DAPLA_PROJECT_HOME/localstack

make stop-all
validate "make update-all" "Unable to update all projects"
validate "make build-all" "There were build errors"
validate "make start-all" "Error starting the localstack environment"
docker-compose ps
echo "Sleeping for 20 seconds for containers to initialize"
sleep 20
run_all_scenarios
run_all_samples
