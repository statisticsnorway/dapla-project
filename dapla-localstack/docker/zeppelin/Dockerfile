FROM apache/zeppelin:0.8.1

# Copy the latest dapla specific jars
COPY dapla-spark-plugin/target/dapla-spark-plugin-*-shaded.jar /zeppelin/lib/dapla-spark-plugin.jar
COPY dapla-dlp-pseudo-func/target/dapla-dlp-pseudo-func-*-shaded.jar /zeppelin/lib/dapla-dlp-pseudo-func.jar

# Copy zeppelin settings. This includes the library.
# docker exec ID-OF-CONTAINER cat /zeppelin/conf/interpreter.json > interpreter.json
COPY dapla-localstack/docker/zeppelin/interpreter-template.json /zeppelin/conf/interpreter-template.json
COPY dapla-localstack/docker/zeppelin/zeppelin-site.xml /zeppelin/conf/zeppelin-site.xml
COPY dapla-localstack/docker/zeppelin/env.sh /env.sh
COPY dapla-spark-plugin/secret/gcs_sa_test.json /secret/gcs_sa_test.json

# Add the GCS connector.
# https://github.com/GoogleCloudPlatform/bigdata-interop/blob/master/gcs/INSTALL.md#configure-spark
# https://github.com/GoogleCloudPlatform/bigdata-interop/issues/188
# https://github.com/GoogleCloudPlatform/bigdata-interop/pull/180/files
RUN wget https://storage.googleapis.com/hadoop-lib/gcs/gcs-connector-hadoop2-latest.jar
RUN mv gcs-connector-hadoop2-latest.jar lib/gcs-connector-hadoop.jar

VOLUME ["/gcloud/key.json"]

# Add some examples:
# val test = spark.read.parquet("gs://ssb-data-a/data/b9c10b86-5867-4270-b56e-ee7439fe381e")
# test.show()
#
# val test = spark.read.format("no.ssb.gsim.spark")
#     .load("lds+gsim://b9c10b86-5867-4270-b56e-ee7439fe381e")
# test.show()

WORKDIR /dapla-localstack/docker/zeppelin
CMD ["/env.sh"]
