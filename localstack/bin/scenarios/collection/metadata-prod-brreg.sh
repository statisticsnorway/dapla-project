#!/usr/bin/env bash

# !!! This script is customized (and will only work) for STAGING !!!

# 1) Generate and sign dataset metadata
# 2) Upload dataset metadata to gcs
#
# Modify the DATASET_META_JSON definition in this script before running.
#
# Params:
#   DS_VERSION -> explicit dataset version string (defaults to current timestamp)
#   TOKEN -> API-user token used to access the dapla services
#
# Prerequisites:
#   - Your API user needs to have access to the path specified in DATASET_META_JSON in order
#     for the metadata signing to work.
#   - Make sure your gcloud account is being configured to your personal user in order for
#     gsutil to execute successfully.
#     e.g. cloud config set account mikke.mus@ssbmod.net
#
# Examples:
#
# DS_VERSION=1585232796000 TOKEN=$(ssb-auth.sh) ./bin/run-scenario.sh exec staging collection/metadata-staging-nodata
#
# (Assumes `ssb-auth.sh` is a script that will return a JWT token)

. $DAPLA_PROJECT_HOME/localstack/bin/validate.sh

ds_parent_uri="gs://ssb-data-prod-kilde-brreg/kilde/brreg/enhetsreg/"
ds_version=${DS_VERSION:-$(date +%s000)}

DATASET_META_JSON=$(jq '@json' <<< '{
  "id": {
    "path": "/kilde/brreg/enhetsreg/1598553650001",
    "version": "'${ds_version}'"
  },
  "type": "UNBOUNDED",
  "valuation": "INTERNAL",
  "state": "SENSITIVE",
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

ds_path=$(jq -r '.id.path' tmp/.dataset-meta.json)
ds_version=$(jq -r '.id.version' tmp/.dataset-meta.json)
storage_path="$ds_parent_uri$ds_path/$ds_version"
echo $(bold "Copy dataset metadata files to $storage_path")
gsutil cp tmp/.dataset-meta.json* $storage_path

echo $(bold "Notify metadata distributor")
post $distributor '/rpc/MetadataDistributorService/dataChanged' '{
  "projectId": "prod-bip",
  "topicName": "metadata-distributor-dataset-updates",
  "uri": "'${ds_parent_uri}'/'${ds_path}'/'${ds_version}'"
}' 200
