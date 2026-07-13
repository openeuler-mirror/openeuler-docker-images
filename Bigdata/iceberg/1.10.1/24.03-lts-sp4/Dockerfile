ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE} AS builder

ARG VERSION=1.10.1

ARG ICEBERG_URL=https://archive.apache.org/dist/iceberg/apache-iceberg-${VERSION}/apache-iceberg-${VERSION}.tar.gz

RUN yum install -y wget java-17-openjdk java-17-openjdk-devel && \
    wget -O /tmp/iceberg.tar.gz "${ICEBERG_URL}" && \
    mkdir -p /opt/iceberg-src && \
    tar xfz /tmp/iceberg.tar.gz -C /opt/iceberg-src --strip-components 1 && \
    rm /tmp/iceberg.tar.gz

WORKDIR /opt/iceberg-src
RUN ./gradlew build -x test -x integrationTest

FROM ${BASE}

RUN yum install -y java-17-openjdk java-17-openjdk-devel && \
    yum clean all

COPY --from=builder /opt/iceberg-src /opt/iceberg

ENV ICEBERG_HOME=/opt/iceberg
WORKDIR /opt/iceberg

CMD ["/bin/bash"]
