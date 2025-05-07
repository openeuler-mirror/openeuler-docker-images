ARG BASE=openeuler/openeuler:24.03-lts-sp1

FROM ${BASE} as builder
ARG TARGETARCH
ARG BUILDARCH

ENV JDK_VERSION=11.0.27_6
ENV KYUUBI_VERSION=1.10.0
ENV KYUUBI_HOME=/opt/kyuubi
ENV SPARK_VERSION=3.4.2
ENV JAVA_HOME=/usr/local/jdk-11.0.27+6

RUN dnf install -y wget procps && \
    dnf clean all

# Download Kyuubi
RUN wget https://downloads.apache.org/kyuubi/kyuubi-${KYUUBI_VERSION}/apache-kyuubi-${KYUUBI_VERSION}-bin.tgz && \
    tar -xzf apache-kyuubi-${KYUUBI_VERSION}-bin.tgz && \
    mv apache-kyuubi-${KYUUBI_VERSION}-bin ${KYUUBI_HOME} && \
    rm -f apache-kyuubi-${KYUUBI_VERSION}-bin.tgz

# Download Spark (as mentioned in quick start for Spark engine)
RUN wget https://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop3.tgz && \
    tar -xzf spark-${SPARK_VERSION}-bin-hadoop3.tgz && \
    mv spark-${SPARK_VERSION}-bin-hadoop3 /opt/spark && \
    rm -f spark-${SPARK_VERSION}-bin-hadoop3.tgz

RUN if [ "$TARGETARCH" = "amd64" ]; then \
      BUILDARCH="x64"; \
    elif [ "$TARGETARCH" = "arm64" ]; then \
      BUILDARCH="aarch64"; \
    fi \
    && mkdir -p /usr/local/jre \
    && wget -O jre.tar.gz https://mirrors.tuna.tsinghua.edu.cn/Adoptium/11/jre/${BUILDARCH}/linux/OpenJDK11U-jre_${BUILDARCH}_linux_hotspot_${JDK_VERSION}.tar.gz \
    && tar -zxvf jre.tar.gz --strip-components=1 -C /usr/local/jre \
    && rm -f jre.tar.gz


FROM ${BASE}

ENV KYUUBI_HOME=/opt/kyuubi
ENV SPARK_HOME=/opt/spark
ENV JAVA_HOME=/usr/local/jre
ENV PATH=${JAVA_HOME}/bin:$PATH

COPY --from=builder ${KYUUBI_HOME} ${KYUUBI_HOME}
COPY --from=builder ${SPARK_HOME} ${SPARK_HOME}
COPY --from=builder ${JAVA_HOME} ${JAVA_HOME}

RUN dnf install -y findutils && \
    dnf clean all

RUN echo "export JAVA_HOME=${JAVA_HOME}" >> ${KYUUBI_HOME}/conf/kyuubi-env.sh && \
    echo "export SPARK_HOME=${SPARK_HOME}" >> ${KYUUBI_HOME}/conf/kyuubi-env.sh

EXPOSE 10009

WORKDIR ${KYUUBI_HOME}

HEALTHCHECK --interval=30s --timeout=5s CMD curl -f http://localhost:10009/ || exit 1

ENTRYPOINT ["bin/kyuubi", "start"]