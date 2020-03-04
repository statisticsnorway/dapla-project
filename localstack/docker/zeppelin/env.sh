#!/bin/bash

echo "Reset notebook samples"
cp -rf /notebook-samples/* /notebook

echo "Replacing environment variables"
envsubst \
	' \
	 $DAPLA_SPARK_GCS_STORAGE \
	 $DAPLA_SPARK_DATA_ACCESS_URL \
	 $DAPLA_SPARK_METADATA_PUBLISHER_URL \
	 $DAPLA_SPARK_METADATA_PUBLISHER_PROJECT_ID \
	 $DAPLA_SPARK_METADATA_PUBLISHER_TOPIC_NAME \
	 $DAPLA_SPARK_OAUTH_TOKEN_URL \
	 $DAPLA_SPARK_OAUTH_CREDENTIALS_FILE \
	 $DAPLA_SPARK_OAUTH_CLIENT_ID \
	 $DAPLA_SPARK_OAUTH_CLIENT_SECRET \
	 ' < /zeppelin/conf/interpreter-template.json > /zeppelin/conf/interpreter.json

/zeppelin/bin/zeppelin.sh