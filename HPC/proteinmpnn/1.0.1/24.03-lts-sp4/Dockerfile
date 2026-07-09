ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE}
ARG VERSION=1.0.1

ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8

RUN dnf update -y \
    && dnf install -y git python3-pip \
    && dnf clean all \
    && rm -rf /var/cache/dnf

RUN pip3 install --no-cache-dir torch numpy

WORKDIR /opt

RUN git clone -b v${VERSION} https://github.com/dauparas/ProteinMPNN.git

WORKDIR /opt/ProteinMPNN

CMD ["python3", "protein_mpnn_run.py", "--help"]