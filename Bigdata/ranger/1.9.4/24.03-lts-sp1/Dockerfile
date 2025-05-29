ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM $BASE

ARG VERSION=1.9.4

RUN yum install -y git python3-pip && \
    yum clean all

RUN ln -s /usr/bin/python3 /usr/bin/python && \
    git clone -b v${VERSION} https://github.com/ranger/ranger.git && \
    cd ranger && \
    pip install -r requirements.txt && \
    python setup.py install --optimize=1 --record=install_log.txt && \
    rm -rf /ranger

ENTRYPOINT ["ranger"]