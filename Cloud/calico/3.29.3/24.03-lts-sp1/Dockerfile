ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM ${BASE}

ARG TARGETARCH
ARG VERSION=3.29.3

RUN yum install -y gcc gcc-c++ java-1.8.0-openjdk javacc
RUN curl -fSL -o calicoctl https://github.com/projectcalico/calico/releases/download/v${VERSION}/calicoctl-linux-${TARGETARCH} && \
    mv calicoctl /usr/bin/calicoctl && \
    chmod 755 /usr/bin/calicoctl

ENTRYPOINT ["/usr/bin/calicoctl"]