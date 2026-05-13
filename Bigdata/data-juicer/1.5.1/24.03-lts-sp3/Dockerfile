ARG BASE=openeuler/openeuler:24.03-lts-sp3
FROM ${BASE}

ARG TARGETARCH
ARG DATA_JUICER_VERSION=1.5.1

RUN dnf install -y python3-pip python3-devel gcc gcc-c++ make \
    && dnf clean all \

RUN pip3 install --no-cache-dir  py-data-juicer==${DATA_JUICER_VERSION}[all]

CMD ["/bin/bash"]
