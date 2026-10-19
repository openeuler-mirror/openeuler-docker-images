ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE}

ARG VERSION=0.5.0

RUN dnf install -y python3-pip ca-certificates git libstdc++ libgcc && \
    dnf clean all

RUN pip install --no-cache-dir openviking==${VERSION}

WORKDIR /root

EXPOSE 1933

CMD ["openviking-server"]
