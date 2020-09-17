#!/usr/bin/env bash

mkdir -p $(dirname $BASH_SOURCE)/../neo4jplugins
pushd $(dirname $BASH_SOURCE)/../neo4jplugins
if [ ! -f "apoc-4.1.0.2-all.jar" ]; then
  rm -f apoc-*
  echo "Downloading neo4j apoc plugin...";
  curl -L -O https://github.com/neo4j-contrib/neo4j-apoc-procedures/releases/download/4.1.0.2/apoc-4.1.0.2-all.jar
  echo "Download complete!";
fi
popd
