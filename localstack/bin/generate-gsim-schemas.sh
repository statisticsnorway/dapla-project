#!/usr/bin/env bash

echo "Re-generating GSIM schema files..."
#rm -rf docker/gsim/jsonschemas
rm -rf docker/gsim/graphqlschemas

#docker run -v $(pwd)/docker/gsim:/raml-project statisticsnorway/raml-to-jsonschema:latest
docker run -v $(pwd)/docker/gsim:/raml-project statisticsnorway/raml-to-graphql-schema:latest
