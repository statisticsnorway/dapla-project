#!/usr/bin/env bash

container_id=$(docker ps | grep dapla-jupyterlab:dev | awk '{ print $1 }')
echo "found jupyterlab container: $container_id"
echo "copy ../dapla-gcp-jupyter/jupyter/custom_spark/sparkextension.py to $container_id:/opt/conda/lib/python3.7/site-packages/custom_spark"
docker cp ../dapla-gcp-jupyter/jupyter/custom_spark/sparkextension.py $container_id:/opt/conda/lib/python3.7/site-packages/custom_spark
echo "restart kernel in jupyter to use copied file"
