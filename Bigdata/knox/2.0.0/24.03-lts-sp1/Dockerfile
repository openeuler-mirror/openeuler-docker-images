ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM ${BASE}

ARG VERSION=2.0.0
ARG SECRET=MASTER-SECRET-2.0.0

RUN dnf update -y && \
    dnf install -y git maven wget unzip shadow-utils && \
    dnf clean all && rm -rf /var/cache/dnf

ARG HADOOP_VERSION=3.4.1
RUN curl -fSL -o hadoop.tar.gz https://dlcdn.apache.org/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz; \
    mkdir -p /usr/local/hadoop && \
    tar -zxf hadoop.tar.gz -C /usr/local/hadoop --strip-components=1 && \
    rm -rf hadoop.tar.gz

ENV PATH=$PATH:/usr/local/hadoop/bin
ENV HADOOP_HOME=/usr/local/hadoop/

WORKDIR /opt
RUN wget https://downloads.apache.org/knox/${VERSION}/knox-${VERSION}.zip && \
    unzip knox-${VERSION}.zip && \
    rm -f knox-${VERSION}.zip

WORKDIR /opt/knox-${VERSION}

RUN ./bin/ldap.sh start && \
    ./bin/knoxcli.sh create-master --force --master "${SECRET}" && \
    ./bin/knoxcli.sh create-cert --hostname localhost

RUN useradd -m -s /bin/bash knoxuser && \
    chown -R knoxuser:knoxuser /opt/knox-${VERSION}

USER knoxuser
WORKDIR /opt/knox-${VERSION}

CMD ["./bin/gateway.sh", "start"]
