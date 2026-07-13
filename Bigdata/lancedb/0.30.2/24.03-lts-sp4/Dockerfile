ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE}

ARG VERSION=0.30.2

RUN yum install -y python3 python3-pip && \
    yum clean all

RUN pip3 install --no-cache-dir -i https://pypi.tuna.tsinghua.edu.cn/simple lancedb==${VERSION}
    
WORKDIR /workspace

CMD ["python3"]

