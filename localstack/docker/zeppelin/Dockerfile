FROM apache/zeppelin:0.8.2

# Add standalone spark
# Using same version as dataproc
# Spark 2.4.3 (git revision f60fb14) built for Hadoop 2.9.2
# (Build flags: -B -e -Dhadoop.version=2.9.2 -Dyarn.version=2.9.2 -Dzookeeper.version=3.4.13
#   -Dprotobuf.version=2.5.0 -Dscala.version=2.11.12 -Dscala.binary.version=2.11 -Pscala-2.11 -Pflume -Phive -Phive-thriftserver -Pkubernetes)
#RUN wget http://archive.apache.org/dist/spark/spark-2.4.3/spark-2.4.3-bin-hadoop2.7.tgz \
RUN wget https://downloads.apache.org/spark/spark-2.4.5/spark-2.4.5-bin-hadoop2.7.tgz \
&&  tar -xzf spark-2.4.5-bin-hadoop2.7.tgz \
&&  mv spark-2.4.5-bin-hadoop2.7 /opt/spark

# Add the GCS connector.
# https://github.com/GoogleCloudPlatform/bigdata-interop/blob/master/gcs/INSTALL.md#configure-spark
# https://github.com/GoogleCloudPlatform/bigdata-interop/issues/188
# https://github.com/GoogleCloudPlatform/bigdata-interop/pull/180/files
RUN wget https://storage.googleapis.com/hadoop-lib/gcs/gcs-connector-hadoop2-latest.jar
RUN mv gcs-connector-hadoop2-latest.jar lib/gcs-connector-hadoop.jar

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

WORKDIR /zeppelin
CMD ["/env.sh"]
