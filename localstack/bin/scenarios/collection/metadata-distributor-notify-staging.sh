#!/usr/bin/env bash

post $distributor '/rpc/MetadataDistributorService/dataChanged' '{
  "projectId": "staging-bip",
  "topicName": "metadata-distributor-dataset-updates",
  "uri": "'$(jq '.parentUri' tmp/write-location.json)'/'$(jq '.id.path' tmp/.dataset-meta.json)'/'$(jq '.id.version' tmp/.dataset-meta.json)'/.dataset-meta.json.sign"
}' 200
