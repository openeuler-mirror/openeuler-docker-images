ARG BASE=openeuler/openeuler:22.03-lts-sp3
FROM ${BASE}

ARG VERSION=2.11.1
RUN yum install -y python3-pip && yum clean all
RUN pip3 install mlflow==${VERSION} -i https://pypi.tuna.tsinghua.edu.cn/simple && \
    groupadd --gid 10001 mlflow && \
    useradd --uid 10001 --gid mlflow --shell /bin/bash --create-home mlflow

USER 10001
CMD ["bash"]
