ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE} as BUILDER
# autopilot: refresh dnf metadata
RUN rm -rf /var/cache/dnf /var/cache/yum \
    && (dnf clean all 2>/dev/null || yum clean all 2>/dev/null || true) \
    && mkdir -p /etc/dnf \
    && (grep -qxF skip_if_unavailable=True /etc/dnf/dnf.conf 2>/dev/null \
        || echo skip_if_unavailable=True >> /etc/dnf/dnf.conf)

ARG VERSION=1.85.1
ARG WORK_HOME=/home/grpc-java

RUN dnf install -y git java-1.8.0-openjdk java-1.8.0-openjdk-devel \
    && dnf clean all \
    && rm -rf /var/cache/dnf/*

RUN git clone -b v${VERSION} --depth 1 https://github.com/grpc/grpc-java ${WORK_HOME}

WORKDIR ${WORK_HOME}/examples

RUN ./gradlew installDist

EXPOSE 50051

CMD ["./build/install/examples/bin/hello-world-server"]
