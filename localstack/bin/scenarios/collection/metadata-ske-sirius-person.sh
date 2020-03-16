#!/usr/bin/env bash

UNSIGNED_JSON=$(jq '@json' <<< '{
  "id": {
    "path": "/raw/ske/sirius/person/2018",
    "version": "1584361016731"
  },
  "type": "UNBOUNDED",
  "valuation": "SENSITIVE",
  "state": "RAW",
  "pseudoConfig": {}
}')

mkdir -p tmp
post $daccess '/rpc/DataAccessService/writeLocation' '{"metadataJson":'$UNSIGNED_JSON'}' > tmp/write-location.json
jq -r '.validMetadataJson' tmp/write-location.json | base64 -d > tmp/dataset-meta.json
jq -r '.metadataSignature' tmp/write-location.json | base64 -d > tmp/dataset-meta.json.sign

echo SIGNED META-DATA
jq . tmp/dataset-meta.json

DATASET_FOLDER="$(dirname $BASH_SOURCE)/../../../data/datastore$(jq -r '.id.path' tmp/dataset-meta.json)/$(jq -r '.id.version' tmp/dataset-meta.json)"

echo Copying metadata to folder: $DATASET_FOLDER

rm -f $DATASET_FOLDER/.dataset-meta.json
rm -f $DATASET_FOLDER/.dataset-meta.json.sign
mkdir -p $DATASET_FOLDER
cp tmp/dataset-meta.json $DATASET_FOLDER/.dataset-meta.json
cp tmp/dataset-meta.json.sign $DATASET_FOLDER/.dataset-meta.json.sign
#rm tmp/dataset-meta.json tmp/dataset-meta.json.sign tmp/write-location.json

## Copy parquet files
cp -r $(dirname $BASH_SOURCE)/../../testdata/skatt/person/rawdata-2018/1583486170277/*.parquet $DATASET_FOLDER

post $distributor '/rpc/MetadataDistributorService/dataChanged' '{
  "projectId": "dapla",
  "topicName": "file-events-1",
  "parentUri": '$(jq '.parentUri' tmp/dataset-meta.json)',
  "path": '$(jq '.id.path' tmp/dataset-meta.json)',
  "version": '$(jq '.id.version' tmp/dataset-meta.json)',
  "filename": ".dataset-meta.json.sign"
}' 200
