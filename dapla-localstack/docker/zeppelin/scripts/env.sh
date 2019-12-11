#!/bin/bash

echo "Replacing environment variables"

envsubst \
	' \
	 $YARN_DEFAULT_FS \
	 ' < /core-site-template.xml > /usr/lib/hadoop/etc/hadoop/core-site.xml

envsubst \
	' \
	 $YARN_RESOURCE_MANAGER \
	 $YARN_TIMELINE_SERVICE \
	 ' < /yarn-site-template.xml > /usr/lib/hadoop/etc/hadoop/yarn-site.xml

/zeppelin/bin/zeppelin.sh