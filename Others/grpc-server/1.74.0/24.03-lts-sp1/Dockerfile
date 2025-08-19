ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM ${BASE} as BUILDER

ARG VERSION=1.74.0
ARG WORK_HOME=/home/grpc-java

RUN dnf install -y git wget java-1.8.0-openjdk java-1.8.0-openjdk-devel \
    && dnf clean all \
    && rm -rf /var/cache/dnf/*

RUN git clone -b v${VERSION} --depth 1 https://github.com/grpc/grpc-java ${WORK_HOME}

WORKDIR ${WORK_HOME}/examples

RUN ./gradlew installDist

EXPOSE 50051

CMD ["./build/install/examples/bin/hello-world-server"]
