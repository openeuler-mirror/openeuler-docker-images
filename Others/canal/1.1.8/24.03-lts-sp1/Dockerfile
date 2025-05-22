ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM ${BASE}
ARG VERSION=canal-1.1.8

RUN dnf update -y \
    && dnf install -y git maven \
    && dnf clean all \
    && rm -rf /var/cache/dnf

RUN git clone -b ${VERSION} --depth 1 https://github.com/alibaba/canal.git \
    && cd canal \
    && mvn clean install -DskipTests=true

CMD ["bash"]