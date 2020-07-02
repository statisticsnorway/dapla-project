#!/usr/bin/env bash

container_id=$(docker ps | grep dapla-jupyterlab:dev | awk '{ print $1 }')
echo "found jupyterlab container: $container_id"
echo "cp ../dapla-spark-plugin/target/dapla-spark-plugin-*-SNAPSHOT-shaded.jar  $container_id:/jupyter/lib/dapla-spark-plugin.jar"
docker cp ../dapla-spark-plugin/target/dapla-spark-plugin-*-SNAPSHOT-shaded.jar $container_id:/jupyter/lib/dapla-spark-plugin.jar
echo "restart kernel in jupyter to use copied file"
