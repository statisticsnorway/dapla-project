#!/usr/bin/env bash

echo "Re-generating exploration schema files..."
#rm -rf docker/exploration/jsonschemas
rm -rf docker/exploration/graphqlschemas

#docker run -v $(pwd)/docker/exploration:/raml-project statisticsnorway/raml-to-jsonschema:latest
docker run -v $(pwd)/docker/exploration:/raml-project statisticsnorway/raml-to-graphql-schema:latest
