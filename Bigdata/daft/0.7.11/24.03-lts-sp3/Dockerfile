ARG BASE=openeuler/openeuler:24.03-lts-sp3
FROM ${BASE}

ARG VERSION=0.7.11

RUN yum install -y --nogpgcheck \
        python3 python3-pip && \
    yum clean all && \
    rm -rf /var/cache/yum

RUN pip3 install --no-cache-dir daft==${VERSION}

ENV DAFT_RUNNER=native

CMD ["python3"]
