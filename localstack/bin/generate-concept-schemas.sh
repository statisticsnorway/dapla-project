#!/usr/bin/env bash

echo "Re-generating schema files..."
rm -rf docker/concept/jsonschemas
rm -rf docker/concept/graphqlschemas

docker run -v $(pwd)/docker/concept:/raml-project statisticsnorway/raml-to-jsonschema:latest
docker run -v $(pwd)/docker/concept:/raml-project statisticsnorway/raml-to-graphql-schema:latest
