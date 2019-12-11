FROM apache/zeppelin:0.8.2

WORKDIR /zeppelin
ADD docker/zeppelin/scripts/create-python-env.bash /root/create-python-env.bash
RUN /root/create-python-env.bash

ADD docker/zeppelin/scripts/install.sh /root/install.sh
RUN /root/install.sh

ADD docker/zeppelin/conf/interpreter.json /zeppelin/conf/interpreter.json
ADD docker/zeppelin/conf/zeppelin-site.xml /zeppelin/conf/zeppelin-site.xml
ADD docker/zeppelin/conf/shiro.ini /zeppelin/conf/shiro.ini

RUN wget https://storage.googleapis.com/hadoop-lib/gcs/gcs-connector-hadoop2-latest.jar
RUN mv gcs-connector-hadoop2-latest.jar lib/gcs-connector-hadoop.jar

COPY docker/zeppelin/conf/core-site-template.xml /core-site-template.xml
COPY docker/zeppelin/conf/yarn-site-template.xml /yarn-site-template.xml
COPY docker/zeppelin/scripts/env.sh /env.sh

ENV HADOOP_CONF_DIR /usr/lib/hadoop/etc/hadoop
ENV SPARK_HOME=/usr/lib/spark

WORKDIR /zeppelin
CMD ["/env.sh"]
