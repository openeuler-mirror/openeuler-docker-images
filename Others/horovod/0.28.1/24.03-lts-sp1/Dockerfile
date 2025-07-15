ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM ${BASE}
ARG VERSION=0.28.1

RUN dnf update -y \
    && dnf install -y python3-pip \
    && dnf clean all \
    && rm -rf /tmp/* \
    && rm -rf /var/cache/dnf


# Dependencies required for installing horovod
RUN dnf install -y openmpi openmpi-devel gcc gcc-c++ cmake make git && \
    yum clean all && \
    rm -rf /var/cache/yum

RUN python3 -m pip install pip==21.3.1

RUN pip3 install horovod==${VERSION}

CMD ["horovodrun", "-v"]