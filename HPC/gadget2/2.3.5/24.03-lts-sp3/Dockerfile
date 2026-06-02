ARG BASE=openeuler/openeuler:24.03-lts-sp3
FROM ${BASE}

ARG VERSION=2.3.5

RUN dnf install -y \
        gcc gcc-c++ make \
        tar gzip curl && \
    dnf clean all

RUN curl -fSL -o /tmp/gadget2.tar.gz https://github.com/gadget-framework/gadget2/archive/refs/tags/v${VERSION}.tar.gz && \
    tar -xzf /tmp/gadget2.tar.gz -C /tmp && \
    make -C /tmp/gadget2-${VERSION} && \
    install -m 0755 /tmp/gadget2-${VERSION}/gadget /usr/local/bin/gadget && \
    install -d /usr/local/share/man/man1 && \
    install -m 0644 /tmp/gadget2-${VERSION}/gadget.1 /usr/local/share/man/man1/gadget.1 && \
    rm -rf /tmp/gadget2.tar.gz /tmp/gadget2-${VERSION}

ENV GADGET_WORKING_DIR=/workspace \
    GADGET_DATA_DIR=/workspace

WORKDIR /workspace

CMD ["gadget", "-h"]
