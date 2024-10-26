ARG BASE=openeuler/openeuler:22.03-lts-sp1

FROM ${BASE}

ARG VERSION=2.17.1

RUN yum install -y python3-pip && yum clean all

RUN pip3 install mlflow==${VERSION} -i https://pypi.tuna.tsinghua.edu.cn/simple && \
    groupadd --gid 10001 mlflow && \
    useradd --uid 10001 --gid mlflow --shell /bin/bash --create-home mlflow && \
    mkdir -p /mlflow && \
    chown mlflow:mlflow /mlflow

USER 10001

ENV MLFLOW_TRACKING_URI=/mlflow

CMD ["mlflow", "server", "--backend-store-uri", "/mlflow", "--default-artifact-root", "/mlflow", "--host", "0.0.0.0"]
