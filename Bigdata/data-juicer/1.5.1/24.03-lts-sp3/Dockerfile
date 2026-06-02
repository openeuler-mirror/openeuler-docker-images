ARG BASE=openeuler/openeuler:24.03-lts-sp3
FROM ${BASE}

ARG VERSION=1.5.1

RUN dnf install -y python3-pip python3-devel gcc-c++ make \
    && dnf clean all

RUN pip3 install --no-cache-dir -i https://pypi.tuna.tsinghua.edu.cn/simple py-data-juicer==${VERSION}

CMD ["/bin/bash"]
