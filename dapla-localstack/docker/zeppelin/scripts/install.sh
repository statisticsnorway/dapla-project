#!/bin/sh

spark_version=2.4.4
hadoop_version_major=2.7

hadoop_version=${hadoop_version_major}.7

spark_file=spark-${spark_version}-bin-hadoop${hadoop_version_major}.tgz
spark_dir=spark-${spark_version}-bin-hadoop${hadoop_version_major}
spark_url=https://apache.uib.no/spark/spark-${spark_version}/${spark_file}
spark_install_dir=/usr/lib/spark
spark_sha512sum_file=spark-sha512sum.txt

hadoop_file=hadoop-${hadoop_version}.tar.gz
hadoop_dir=hadoop-${hadoop_version}
hadoop_url=https://apache.uib.no/hadoop/common/hadoop-${hadoop_version}/${hadoop_file}
hadoop_install_dir=/usr/lib/hadoop
hadoop_sha512sum_file=hadoop-sha512sum.txt

if [ ! -d /etc/hadoop ]
then
    mkdir -p /etc/hadoop
fi

cd /usr/lib || exit 1

if [ ! -L "$spark_install_dir" ] && [ ! -d "$spark_install_dir" ]
then
  cat <<EOF > ${spark_sha512sum_file}
2e3a5c853b9f28c7d4525c0adcb0d971b73ad47d5cce138c85335b9f53a6519540d3923cb0b5cee41e386e49ae8a409a51ab7194ba11a254e037a848d0c4a9e5 ${spark_file}
EOF

  wget --spider --tries=3 "${spark_url}" || exit 1

  if [ ! -r "${spark_file}" ]
  then
    retry=0
    until [ $retry -ge 20 ]
    do
      wget "${spark_url}"
      test -r "${spark_file}" && break
      retry=$((retry+1))
      sleep 1
    done
  fi

  if [ ! -r "${spark_file}" ]
  then
      echo "Failed downloading ${spark_url}"
      exit 1
  fi

  sha512sum -c ${spark_sha512sum_file}
  tar zxf ${spark_file}

  if [ ! -L "$spark_install_dir" ] && [ ! -d "$spark_install_dir" ]
  then
     mv ${spark_dir} ${spark_install_dir}
  fi

  rm -f ${spark_sha512sum_file}
  rm -f ${spark_file}
fi

if [ ! -L "$hadoop_install_dir" ] && [ ! -d "$hadoop_install_dir" ]
then
  cat <<EOF > ${hadoop_sha512sum_file}
17c8917211dd4c25f78bf60130a390f9e273b0149737094e45f4ae5c917b1174b97eb90818c5df068e607835120126281bcc07514f38bd7fd3cb8e9d3db1bdde ${hadoop_file}
EOF

  wget --spider --tries=3 "${hadoop_url}" || exit 1

  if [ ! -r "${hadoop_file}" ]
  then
    retry=0
    until [ $retry -ge 20 ]
    do
      wget "${hadoop_url}"
      test -r "${hadoop_file}" && break
      retry=$((retry+1))
      sleep 1
    done
  fi

  if [ ! -r "${hadoop_file}" ]
  then
      echo "Failed downloading ${hadoop_url}"
      exit 1
  fi

  sha512sum -c ${hadoop_sha512sum_file}
  tar zxf ${hadoop_file}

  if [ ! -L "$hadoop_install_dir" ] && [ ! -d "$hadoop_install_dir" ]
  then
     mv ${hadoop_dir} ${hadoop_install_dir}
  fi

  rm -f ${hadoop_sha512sum_file}
  rm -f ${hadoop_file}

  # Link mounted configuration files (kubernetes spesific).
  if [ ! -L /usr/lib/hadoop/etc/hadoop/yarn-site.xml ]
  then
    ln -sf /etc/hadoop/yarn-site.xml /usr/lib/hadoop/etc/hadoop/yarn-site.xml
  fi
  if [ ! -L /usr/lib/hadoop/etc/hadoop/core-site.xml ]
  then
    ln -sf /etc/hadoop/core-site.xml /usr/lib/hadoop/etc/hadoop/core-site.xml
  fi
  if [ ! -L /usr/lib/hadoop/etc/hadoop/hdfs-site.xml ]
  then
    ln -sf /etc/hadoop/hdfs-site.xml /usr/lib/hadoop/etc/hadoop/hdfs-site.xml
  fi
  if [ ! -L /usr/lib/hadoop/etc/hadoop/mapred-site.xml ]
  then
    ln -sf /etc/hadoop/mapred-site.xml /usr/lib/hadoop/etc/hadoop/mapred-site.xml
  fi
fi

exit $?
