ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM ${BASE}

ARG VERSION=5.0.2

RUN yum update -y && \
    yum install -y \
        java-1.8.0-openjdk-devel lsof hostname openeuler-lsb \
        openssh openssh-clients mariadb-server wget patch net-tools && \
    yum clean all

ENV JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk

COPY conf/ssh/sshd_config /etc/ssh/sshd_config
COPY conf/ssh/ssh_config /etc/ssh/ssh_config
RUN ssh-keygen -A && ssh-keygen -t ed25519 -P '' -f /root/.ssh/id_ed25519 && \
    cat /root/.ssh/id_ed25519.pub > /root/.ssh/authorized_keys && \
    chmod 0400 /root/.ssh/authorized_keys

# install hadoop
ENV HADOOP_VERSION=3.2.4
ENV HIVE_VERSION=3.1.3
ENV ZOOKEEPER_VERSION=3.7.2
ENV SPARK_VERSION=3.3.0

ENV HADOOP_HOME=/opt/hadoop-$HADOOP_VERSION
ENV HIVE_HOME=/opt/apache-hive-$HIVE_VERSION-bin
ENV ZOOKEEPER_HOME=/opt/apache-zookeeper-$ZOOKEEPER_VERSION-bin

WORKDIR /opt
RUN wget https://archive.apache.org/dist/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz && \
    wget https://archive.apache.org/dist/hive/hive-$HIVE_VERSION/apache-hive-$HIVE_VERSION-bin.tar.gz && \
    wget https://archive.apache.org/dist/zookeeper/zookeeper-$ZOOKEEPER_VERSION/apache-zookeeper-$ZOOKEEPER_VERSION-bin.tar.gz && \
    wget https://archive.apache.org/dist/spark/spark-$SPARK_VERSION/spark-$SPARK_VERSION-bin-without-hadoop.tgz && \
    wget https://repo1.maven.org/maven2/mysql/mysql-connector-java/8.0.28/mysql-connector-java-8.0.28.jar && \
    tar -zxf /opt/hadoop-$HADOOP_VERSION.tar.gz && rm -f /opt/hadoop-$HADOOP_VERSION.tar.gz && \
    tar -zxf /opt/apache-hive-$HIVE_VERSION-bin.tar.gz && rm -f /opt/apache-hive-$HIVE_VERSION-bin.tar.gz && \
    tar -zxf /opt/apache-zookeeper-$ZOOKEEPER_VERSION-bin.tar.gz && rm -f /opt/apache-zookeeper-$ZOOKEEPER_VERSION-bin.tar.gz && \
    tar -zxf /opt/spark-$SPARK_VERSION-bin-without-hadoop.tgz && rm -f /opt/spark-$SPARK_VERSION-bin-without-hadoop.tgz

COPY scripts/start-historyserver.sh $HADOOP_HOME/sbin/
COPY conf/hadoop/* $HADOOP_HOME/etc/hadoop/
COPY scripts/start-hivemetastore.sh $HIVE_HOME/bin/
COPY scripts/start-hiveserver2.sh $HIVE_HOME/bin/
COPY conf/hive/* $HIVE_HOME/conf/
COPY conf/zookeeper/* $ZOOKEEPER_HOME/conf/
RUN mkdir -p /data/hadoop && \
    mkdir -p /data/zookeeper && \
    chmod 0755 $HADOOP_HOME/sbin/start-historyserver.sh && \
    chmod 0755 $HIVE_HOME/bin/start-hivemetastore.sh && \
    chmod 0755 $HIVE_HOME/bin/start-hiveserver2.sh
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:$HADOOP_HOME/bin:$HIVE_HOME/bin

# hive lib extra
RUN rm -f $HIVE_HOME/lib/guava-*.jar
RUN cp $HADOOP_HOME/share/hadoop/common/lib/guava-*.jar $HIVE_HOME/lib/
RUN cp /opt/mysql-connector-java-8.0.28.jar $HIVE_HOME/lib/

# install apache kylin
RUN mkdir -p /home/kylin/apache-kylin-${VERSION}-bin && \
    curl -fSL -o apache-kylin.tar.gz https://github.com/apache/kylin/releases/download/kylin-${VERSION}/apache-kylin-${VERSION}-bin.tar.gz && \
    tar -zxf apache-kylin.tar.gz -C /home/kylin/apache-kylin-${VERSION}-bin --strip-components=1 && \
    rm -rf apache-kylin.tar.gz
ENV KYLIN_HOME=/home/kylin/apache-kylin-${VERSION}-bin
RUN cp /opt/mysql-connector-java-8.0.28.jar $KYLIN_HOME/lib/ext/
COPY conf/kylin/kylin.properties.override $KYLIN_HOME/conf/
COPY scripts/properties.patch scripts/bootstrap.patch /$KYLIN_HOME/

RUN mkdir -p $KYLIN_HOME/spark && \
    mv /opt/spark-$SPARK_VERSION-bin-without-hadoop/* $KYLIN_HOME/spark/ && \
    cd  $KYLIN_HOME && \
    patch -p1 < properties.patch && \
    patch -p1 < bootstrap.patch && \
    rm -rf $KYLIN_HOME/server/jars/guava-*.jar && \
    cd $KYLIN_HOME/server/jars/ && \
    wget https://repo1.maven.org/maven2/com/google/guava/guava/28.0-jre/guava-28.0-jre.jar

# startup script
COPY scripts/entrypoint.sh /home/kylin/
RUN chmod 0755 /home/kylin/entrypoint.sh

WORKDIR /home/kylin
CMD ["/bin/bash", "entrypoint.sh"]