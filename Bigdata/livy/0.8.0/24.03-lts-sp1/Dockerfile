ARG BASE=openeuler/openeuler:24.03-lts-sp1

FROM ${BASE} as builder

ENV LIVY_VERSION=0.8.0 \
    SCALA_VERSION=2.12 \
    SPARK_HOME=/usr/lib/spark \
    SPARK_VERSION=3.4.2 \
    LIVY_HOME=/opt/livy \
    HADOOP_CONF_DIR=/etc/hadoop/conf

RUN dnf install -y wget unzip && \
    dnf clean all

# Download livy
RUN wget https://dlcdn.apache.org/incubator/livy/${LIVY_VERSION}-incubating/apache-livy-${LIVY_VERSION}-incubating_${SCALA_VERSION}-bin.zip \
    && unzip apache-livy-${LIVY_VERSION}-incubating_${SCALA_VERSION}-bin.zip \
    && mv apache-livy-${LIVY_VERSION}-incubating_${SCALA_VERSION}-bin ${LIVY_HOME} \
    && rm -f apache-livy-${LIVY_VERSION}-incubating_${SCALA_VERSION}-bin.zip

# Download Spark (as mentioned in quick start for Spark engine)
RUN wget https://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop3.tgz \
    && tar -xzf spark-${SPARK_VERSION}-bin-hadoop3.tgz \
    && mv spark-${SPARK_VERSION}-bin-hadoop3 ${SPARK_HOME} \
    && rm -f spark-${SPARK_VERSION}-bin-hadoop3.tgz


FROM ${BASE}

ENV LIVY_HOME=/opt/livy \
    SPARK_HOME=/usr/lib/spark \
    HADOOP_CONF_DIR=/etc/hadoop/conf

COPY --from=builder ${LIVY_HOME} ${LIVY_HOME}
COPY --from=builder ${SPARK_HOME} ${SPARK_HOME}

COPY entrypoint.sh /opt/entrypoint.sh
COPY log4j.properties ${LIVY_HOME}/conf/log4j.properties

RUN dnf install -y java-1.8.0-openjdk \
    && chmod +x /opt/entrypoint.sh \
    && dnf clean all \
    && rm -rf /var/cache/dnf

EXPOSE 8080

WORKDIR ${LIVY_HOME}

ENTRYPOINT ["/opt/entrypoint.sh"]
