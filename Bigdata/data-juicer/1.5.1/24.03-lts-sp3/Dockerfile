ARG BASE=openeuler/openeuler:24.03-lts-sp3
FROM ${BASE}

ARG TARGETARCH
ARG DATA_JUICER_VERSION=1.5.1

RUN dnf install -y python3-pip gcc-c++ make \
    && dnf clean all

RUN pip3 install --no-cache-dir -i https://pypi.tuna.tsinghua.edu.cn/simple py-data-juicer==${DATA_JUICER_VERSION}

CMD ["/bin/bash"]
