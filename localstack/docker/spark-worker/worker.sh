#!/bin/bash

. "/spark/sbin/spark-config.sh"

. "/spark/bin/load-spark-env.sh"

mkdir -p $SPARK_WORKER_LOG

export SPARK_HOME=/spark

ln -sf /dev/stdout $SPARK_WORKER_LOG/spark-worker.out

echo "Starting spark worker"


/spark/sbin/../bin/spark-class org.apache.spark.deploy.worker.Worker \
    --webui-port $SPARK_WORKER_WEBUI_PORT $SPARK_MASTER >> $SPARK_WORKER_LOG/spark-worker.out &

echo "Starting spark shuffle service"

/spark/sbin/../bin/spark-class org.apache.spark.deploy.ExternalShuffleService 1 \
    >> $SPARK_WORKER_LOG/spark-worker.out &


wait