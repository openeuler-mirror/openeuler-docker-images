ARG BASE=openeuler/openeuler:24.03-lts-sp3
FROM ${BASE} AS builder

ARG MAVEN_VERSION=3.9.9
ARG VERSION=1.1.1

RUN dnf install -y git java-11-openjdk-devel && \
    dnf clean all

RUN curl -fSL -o apache-maven.tar.gz https://repo.huaweicloud.com/apache/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz && \
    mkdir -p /usr/local/maven && \
    tar -zxf apache-maven.tar.gz -C /usr/local/maven --strip-components=1 && \
    rm -rf apache-maven.tar.gz

ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk
ENV PATH=$PATH:/usr/local/maven/bin

WORKDIR /build
RUN git clone --branch release-${VERSION} --depth 1 https://github.com/apache/hudi.git .

RUN mvn clean package -DskipTests -Dspark3.5 -Dscala-2.12


FROM ${BASE}

ARG VERSION=1.1.1
ARG SPARK_VERSION=3.5.5
ARG HADOOP_VERSION=3

RUN dnf install -y java-11-openjdk-headless procps-ng shadow && \
    dnf clean all

ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk
ENV HUDI_HOME=/opt/hudi
ENV SPARK_HOME=/opt/spark

RUN curl -fSL -o spark.tgz https://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz && \
    mkdir -p ${SPARK_HOME} && \
    tar -zxf spark.tgz -C ${SPARK_HOME} --strip-components=1 && \
    rm -f spark.tgz

WORKDIR ${HUDI_HOME}
COPY --from=builder /build/packaging/hudi-cli-bundle/target/hudi-cli-bundle_2.12-${VERSION}.jar ${HUDI_HOME}/
COPY --from=builder /build/packaging/hudi-spark-bundle/target/hudi-spark3.5-bundle_2.12-${VERSION}.jar ${HUDI_HOME}/
COPY --from=builder /build/packaging/hudi-cli-bundle/hudi-cli-with-bundle.sh ${HUDI_HOME}/
COPY --from=builder /build/packaging/hudi-cli-bundle/conf ${HUDI_HOME}/conf

ENV CLI_BUNDLE_JAR=${HUDI_HOME}/hudi-cli-bundle_2.12-${VERSION}.jar
ENV SPARK_BUNDLE_JAR=${HUDI_HOME}/hudi-spark3.5-bundle_2.12-${VERSION}.jar

RUN useradd -m -s /bin/bash hudi && \
    chown -R hudi:hudi ${HUDI_HOME} ${SPARK_HOME}

USER hudi

ENTRYPOINT ["/opt/hudi/hudi-cli-with-bundle.sh"]
