FROM alpine AS build-env

ENV Z_VERSION="0.8.2"
ENV Z_HOME="/zeppelin"

RUN wget -O zeppelin-bin-netinst.tgz https://archive.apache.org/dist/zeppelin/zeppelin-${Z_VERSION}/zeppelin-${Z_VERSION}-bin-netinst.tgz && \
    tar -zxvf zeppelin-bin-netinst.tgz && \
    rm -rf zeppelin-bin-netinst.tgz && \
    mv /zeppelin-${Z_VERSION}-bin-netinst ${Z_HOME}/

FROM openjdk:8-alpine

# Copy zeppelin
COPY --from=build-env /zeppelin /zeppelin

# Required by the interpreter and launch script.
RUN apk --no-cache add bash

ENV BUILD_DEPS="gettext"  \
    RUNTIME_DEPS="libintl"

RUN set -x && \
    apk add --update $RUNTIME_DEPS && \
    apk add --virtual build_deps $BUILD_DEPS &&  \
    cp /usr/bin/envsubst /usr/local/bin/envsubst && \
    apk del build_deps

RUN mkdir /zeppelin/logs/ \
          /zeppelin/run

# Install hadoop
ENV HADOOP_HOME="/opt/hadoop"
RUN wget https://archive.apache.org/dist/hadoop/common/hadoop-2.7.7/hadoop-2.7.7.tar.gz && \
    tar -zxpf hadoop-2.7.7.tar.gz -C /tmp && \
    mv /tmp/hadoop-2.7.7 ${HADOOP_HOME} && \
    rm -rf hadoop-2.7.7.tar.gz
ENV HADOOP_CONF_DIR="${HADOOP_HOME}/etc/hadoop"

# Intall spark.
ENV SPARK_HOME "/usr/lib/spark"
RUN wget http://archive.apache.org/dist/spark/spark-2.4.4/spark-2.4.4-bin-without-hadoop-scala-2.12.tgz && \
    tar -zxpf spark-2.4.4-bin-without-hadoop-scala-2.12.tgz -C /tmp && \
    mv /tmp/spark-2.4.4-bin-without-hadoop-scala-2.12 ${SPARK_HOME} && \
    rm -rf spark-2.4.4-bin-without-hadoop-scala-2.12.tgz

# Output log to console
COPY localstack/docker/zeppelin/log4j.properties /zeppelin/conf/log4j.properties

# Copy ssb dependencies
COPY dapla-noterepo/zeppelin/target/dapla-notes-zeppelin-*-shaded.jar /zeppelin/lib
COPY dapla-noterepo/oidc/target/dapla-notes-oidc-*-shaded.jar /zeppelin/lib
COPY dapla-noterepo/oidc/spark-interpreter-0.8.2.jar /zeppelin/interpreter/spark/spark-interpreter-0.8.2.jar

# Required so that we persist the note permissions as well
# TODO: Find a better solution, changing the path/volume/config could break this
RUN ln -sf /zeppelin/notebook/notebook-authorization.json \
           /zeppelin/conf/notebook-authorization.json

# Add the GCS connector.
# https://github.com/GoogleCloudPlatform/bigdata-interop/blob/master/gcs/INSTALL.md#configure-spark
# https://github.com/GoogleCloudPlatform/bigdata-interop/issues/188
# https://github.com/GoogleCloudPlatform/bigdata-interop/pull/180/files
RUN wget -O /zeppelin/lib/gcs-connector-hadoop.jar https://storage.googleapis.com/hadoop-lib/gcs/gcs-connector-hadoop2-latest.jar

# Copy zeppelin settings. This includes the library.
# docker exec ID-OF-CONTAINER cat /zeppelin/conf/interpreter.json > interpreter.json
COPY localstack/docker/zeppelin/interpreter-template.json /zeppelin/conf/interpreter-template.json
COPY localstack/docker/zeppelin/zeppelin-site.xml /zeppelin/conf/zeppelin-site.xml
COPY localstack/docker/zeppelin/env.sh /env.sh
COPY localstack/docker/zeppelin/shiro.ini /zeppelin/conf/shiro.ini
COPY localstack/docker/zeppelin/notebook-samples/ /notebook-samples/

COPY dapla-spark-plugin/secret/gcs_sa_test.json /secret/gcs_sa_test.json

# Copy the latest dapla specific jars
COPY dapla-dlp-pseudo-func/target/dapla-dlp-pseudo-func-*-shaded.jar /zeppelin/lib/dapla-dlp-pseudo-func.jar
COPY dapla-spark-plugin/target/dapla-spark-plugin-*-shaded.jar /zeppelin/lib/dapla-spark-plugin.jar

RUN chown -R 2100:2100 /zeppelin
USER 2100:2100

WORKDIR /zeppelin

CMD ["/env.sh"]


