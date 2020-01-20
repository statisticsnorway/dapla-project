#!/bin/bash

echo "Replacing environment variables"
envsubst \
	' \
	 $LDS_GSIM_SPARK_LOCATION \
	 $LDS_GSIM_SPARK_LDS_URL \
	 $LDS_GSIM_SPARK_OAUTH_TOKEN_URL \
	 $LDS_GSIM_SPARK_OAUTH_CLIENT_ID \
	 $LDS_GSIM_SPARK_OAUTH_USERNAME \
	 $LDS_GSIM_SPARK_OAUTH_PASSWORD \
	 $LDS_GSIM_SPARK_OAUTH_CLIENT_SECRET \
	 $LDS_GSIM_SPARK_OAUTH_GRANT_TYPE \
	 ' < /zeppelin/conf/interpreter-template.json > /zeppelin/conf/interpreter.json

/zeppelin/bin/zeppelin.sh