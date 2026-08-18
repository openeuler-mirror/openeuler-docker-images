ARG BASE=openeuler/openeuler:24.03-lts-sp4

FROM ${BASE} as builder

ARG VERSION=5.0.3

ENV HADOOP_VERSION=3.2.4
ENV HIVE_VERSION=3.1.3
ENV ZOOKEEPER_VERSION=3.7.2
ENV SPARK_VERSION=3.3.0
ENV MYSQL_CONNECTOR_VERSION=8.0.28

ENV HADOOP_HOME=/opt/hadoop-${HADOOP_VERSION}
ENV HIVE_HOME=/opt/apache-hive-${HIVE_VERSION}-bin
ENV ZOOKEEPER_HOME=/opt/apache-zookeeper-${ZOOKEEPER_VERSION}-bin
ENV KYLIN_HOME=/home/kylin/apache-kylin-${VERSION}-bin

RUN dnf install -y wget patch && \
    dnf clean all

WORKDIR /opt
RUN wget -T 30 -t 3 -O hadoop.tar.gz https://archive.apache.org/dist/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz && \
    wget -T 30 -t 3 -O hive.tar.gz https://archive.apache.org/dist/hive/hive-${HIVE_VERSION}/apache-hive-${HIVE_VERSION}-bin.tar.gz && \
    wget -T 30 -t 3 -O zookeeper.tar.gz https://archive.apache.org/dist/zookeeper/zookeeper-${ZOOKEEPER_VERSION}/apache-zookeeper-${ZOOKEEPER_VERSION}-bin.tar.gz && \
    wget -T 30 -t 3 -O spark.tgz https://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-without-hadoop.tgz && \
    wget -T 30 -t 3 -O mysql-connector-java.jar https://repo1.maven.org/maven2/mysql/mysql-connector-java/${MYSQL_CONNECTOR_VERSION}/mysql-connector-java-${MYSQL_CONNECTOR_VERSION}.jar && \
    echo "af45cbc9c8786dbe65c41be600f136218d4f3e8e4ec947c64c0bb4f919cedc91cdc5a55026f41b0037470c56ba7f625b29cb4935f7b6d5f0b242146c4e672af9  hadoop.tar.gz" | sha512sum -c - && \
    echo "0c9b6a6359a7341b6029cc9347435ee7b379f93846f779d710b13f795b54bb16  hive.tar.gz" | sha256sum -c - && \
    echo "6afbfc1afc8b9370281bd9862f37dbb1cb95ec54bb2ed4371831aa5c0f08cfee775050bd57ce5fc0836e61af27eed9f0076f54b98997dd0e15159196056e52ea  zookeeper.tar.gz" | sha512sum -c - && \
    echo "ab8ba5cd9effda459878ff08d55f08e5a3f8d9d95b01747ada3d2d5fc46ac82aeb0ee0e878708e0f8bbb88b6dc73464425ff5ba1769322770802e5ef46ff1cac  spark.tgz" | sha512sum -c - && \
    echo "33678b1729d4f832b9e4bcb2d5bbd67940920a7a  mysql-connector-java.jar" | sha1sum -c - && \
    tar -zxf hadoop.tar.gz && \
    tar -zxf hive.tar.gz && \
    tar -zxf zookeeper.tar.gz && \
    tar -zxf spark.tgz && \
    rm -f hadoop.tar.gz hive.tar.gz zookeeper.tar.gz spark.tgz && \
    curl -fSL --connect-timeout 30 --retry 3 -o apache-kylin.tar.gz https://archive.apache.org/dist/kylin/apache-kylin-${VERSION}/apache-kylin-${VERSION}-bin.tar.gz && \
    echo "6a615e83c67a0752b759f14e5472d8e36e093ce78ad995bc6326a9bf3a36e721  apache-kylin.tar.gz" | sha256sum -c - && \
    mkdir -p ${KYLIN_HOME} && \
    tar -zxf apache-kylin.tar.gz -C ${KYLIN_HOME} --strip-components=1 && \
    rm -f apache-kylin.tar.gz

RUN rm -f ${HIVE_HOME}/lib/guava-*.jar && \
    cp ${HADOOP_HOME}/share/hadoop/common/lib/guava-*.jar ${HIVE_HOME}/lib/ && \
    cp /opt/mysql-connector-java.jar ${HIVE_HOME}/lib/ && \
    cp /opt/mysql-connector-java.jar ${KYLIN_HOME}/lib/ext/

COPY scripts/start-historyserver.sh ${HADOOP_HOME}/sbin/
COPY conf/hadoop/ ${HADOOP_HOME}/etc/hadoop/
COPY scripts/start-hivemetastore.sh ${HIVE_HOME}/bin/
COPY scripts/start-hiveserver2.sh ${HIVE_HOME}/bin/
COPY conf/hive/ ${HIVE_HOME}/conf/
COPY conf/zookeeper/ ${ZOOKEEPER_HOME}/conf/
COPY conf/kylin/kylin.properties.override ${KYLIN_HOME}/conf/
COPY scripts/properties.patch scripts/bootstrap.patch ${KYLIN_HOME}/

RUN mkdir -p /data/hadoop /data/zookeeper && \
    chmod 0755 ${HADOOP_HOME}/sbin/start-historyserver.sh && \
    chmod 0755 ${HIVE_HOME}/bin/start-hivemetastore.sh && \
    chmod 0755 ${HIVE_HOME}/bin/start-hiveserver2.sh && \
    mkdir -p ${KYLIN_HOME}/spark && \
    mv /opt/spark-${SPARK_VERSION}-bin-without-hadoop/* ${KYLIN_HOME}/spark/ && \
    cd ${KYLIN_HOME} && \
    patch -p1 < properties.patch && \
    patch -p1 < bootstrap.patch && \
    rm -rf ${KYLIN_HOME}/server/jars/guava-*.jar && \
    wget -T 30 -t 3 -O ${KYLIN_HOME}/server/jars/guava-28.0-jre.jar https://repo1.maven.org/maven2/com/google/guava/guava/28.0-jre/guava-28.0-jre.jar && \
    echo "54fed371b4b8a8cce1e94a9abd9620982d3aa54b  ${KYLIN_HOME}/server/jars/guava-28.0-jre.jar" | sha1sum -c -

FROM ${BASE}

ENV VERSION=5.0.3
ENV HADOOP_VERSION=3.2.4
ENV HIVE_VERSION=3.1.3
ENV ZOOKEEPER_VERSION=3.7.2

ENV JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk
ENV HADOOP_HOME=/opt/hadoop-${HADOOP_VERSION}
ENV HIVE_HOME=/opt/apache-hive-${HIVE_VERSION}-bin
ENV ZOOKEEPER_HOME=/opt/apache-zookeeper-${ZOOKEEPER_VERSION}-bin
ENV KYLIN_HOME=/home/kylin/apache-kylin-${VERSION}-bin
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:${HADOOP_HOME}/bin:${HIVE_HOME}/bin

RUN dnf install -y \
      java-1.8.0-openjdk-devel \
      openssh openssh-clients \
      mariadb-server \
      lsof hostname net-tools openeuler-lsb wget && \
    dnf clean all

COPY conf/ssh/sshd_config /etc/ssh/sshd_config
COPY conf/ssh/ssh_config /etc/ssh/ssh_config
RUN ssh-keygen -A && \
    ssh-keygen -t ed25519 -P '' -f /root/.ssh/id_ed25519 && \
    cat /root/.ssh/id_ed25519.pub > /root/.ssh/authorized_keys && \
    chmod 0400 /root/.ssh/authorized_keys

COPY --from=builder ${HADOOP_HOME} ${HADOOP_HOME}
COPY --from=builder ${HIVE_HOME} ${HIVE_HOME}
COPY --from=builder ${ZOOKEEPER_HOME} ${ZOOKEEPER_HOME}
COPY --from=builder ${KYLIN_HOME} ${KYLIN_HOME}

RUN mkdir -p /data/hadoop /data/zookeeper

COPY scripts/entrypoint.sh /home/kylin/
RUN chmod 0755 /home/kylin/entrypoint.sh

WORKDIR /home/kylin
USER root
CMD ["/bin/bash", "entrypoint.sh"]
