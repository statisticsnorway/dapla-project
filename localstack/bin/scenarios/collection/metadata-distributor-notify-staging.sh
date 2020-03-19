#!/usr/bin/env bash

post $distributor '/rpc/MetadataDistributorService/dataChanged' '{
  "projectId": "staging-bip",
  "topicName": "metadata-distributor-dataset-updates",
  "parentUri": '$(jq '.parentUri' tmp/.dataset-meta.json)',
  "path": '$(jq '.id.path' tmp/.dataset-meta.json)',
  "version": '$(jq '.id.version' tmp/.dataset-meta.json)',
  "filename": ".dataset-meta.json.sign"
}' 200
