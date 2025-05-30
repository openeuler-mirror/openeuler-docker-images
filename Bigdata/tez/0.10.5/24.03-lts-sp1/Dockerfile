ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM ${BASE}
ARG VERSION=0.10.5

RUN dnf update -y \
    && dnf install -y maven wget \
    && dnf clean all  \
    && rm -rf /var/cache/dnf

WORKDIR /opt

RUN wget https://github.com/apache/tez/archive/refs/tags/rel/release-${VERSION}.tar.gz \
    && tar -zxvf release-${VERSION}.tar.gz \
    && rm -rf release-${VERSION}.tar.gz

WORKDIR /opt/tez-rel-release-${VERSION}

RUN mvn clean install -DskipTests -pl '!tez-ui'

CMD ["bash"]
