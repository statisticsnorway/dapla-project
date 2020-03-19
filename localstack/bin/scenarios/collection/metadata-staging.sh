#!/usr/bin/env bash

# !!! This script is customized (and will only work) for STAGING !!!

# 1) Generate and sign dataset metadata
# 2) Upload dataset metadata to gcs
# 3) Upload parquet files to gcs
#
# Modify the DATASET_META_JSON definition in this script before running.
#
# Params:
#   PARQUET_FILES -> a local path to parquet files (defaults to current directory)
#   DS_VERSION -> explicit dataset version string (defaults to current timestamp)
#   TOKEN -> API-user token used to access the dapla services
#
# Prerequisites:
#   Your API user needs to have access to the path specified in DATASET_META_JSON in order
#   for the metadata signing to work.
#
# Examples:
#
# PARQUET_FILES=/path/to/some/files TOKEN=$(ssb-auth.sh) ./bin/run-scenario.sh exec staging collection/metadata-staging
#
# (Assumes `ssb-auth.sh` is a script that will return a JWT token)

. $DAPLA_PROJECT_HOME/localstack/bin/validate.sh

parquet_files_path=${PARQUET_FILES:-$(pwd)}
validate_silently "ls $parquet_files_path/*.parquet" "No parquet files specified. Expected to find .parquet files in $parquet_files_path" || return 1

ds_version=${DS_VERSION:-$(date +%s000)}

DATASET_META_JSON=$(jq '@json' <<< '{
  "id": {
    "path": "/raw/ske/skatt/sirius-person-utkast/2018tmp",
    "version": "'${ds_version}'"
  },
  "type": "UNBOUNDED",
  "valuation": "SENSITIVE",
  "state": "RAW",
  "pseudoConfig": {}
}')

rm -rf tmp
mkdir -p tmp
post $daccess '/rpc/DataAccessService/writeLocation' '{"metadataJson":'$DATASET_META_JSON'}' > tmp/write-location.json
jq -r '.validMetadataJson' tmp/write-location.json | base64 -D > tmp/.dataset-meta.json
jq -r '.metadataSignature' tmp/write-location.json | base64 -D > tmp/.dataset-meta.json.sign
rm tmp/write-location.json

echo "$(underline .dataset-meta.json)"
cat tmp/.dataset-meta.json
echo

ds_parent_uri=$(jq -r '.parentUri' tmp/.dataset-meta.json)
ds_path=$(jq -r '.id.path' tmp/.dataset-meta.json)
ds_version=$(jq -r '.id.version' tmp/.dataset-meta.json)
storage_path="$ds_parent_uri$ds_path/$ds_version"

echo $(bold "Copy dataset metadata files to $storage_path")
gsutil cp tmp/.dataset-meta.json* $storage_path

echo $(bold "Copy parquet files to $storage_path")
gsutil cp -r $parquet_files_path/*.parquet $storage_path

echo $(bold "Notify metadata distributor")
post $distributor '/rpc/MetadataDistributorService/dataChanged' '{
  "projectId": "staging-bip",
  "topicName": "metadata-distributor-dataset-updates",
  "parentUri": "'${ds_parent_uri}'",
  "path": "'${ds_path}'",
  "version": "'${ds_version}'",
  "filename": ".dataset-meta.json.sign"
}' 200
