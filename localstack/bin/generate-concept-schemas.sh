#!/usr/bin/env bash

echo "Re-generating schema files..."
cd docker/concept || exit
rm -rf jsonschemas
rm -rf graphqlschemas

docker run -v $(pwd)/docker/concept:/raml-project statisticsnorway/raml-to-jsonschema:latest
docker run -v $(pwd)/docker/concept:/raml-project statisticsnorway/raml-to-graphql-schema:latest
