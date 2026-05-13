ARG BASE=openeuler/openeuler:24.03-lts-sp3
FROM ${BASE}

ARG TARGETARCH
ARG RAY_VERSION=2.55.1

RUN dnf install -y python3-pip shadow && \
    dnf clean all

RUN  pip install --no-cache-dir -i https://pypi.tuna.tsinghua.edu.cn/simple ray[default]==${RAY_VERSION}
    
RUN groupadd -r ray && useradd -r -m -g ray ray

USER ray
WORKDIR /home/ray

EXPOSE 8265 6379 10001 8000

ENTRYPOINT ["ray"]
CMD ["start", "--head", "--dashboard-host", "0.0.0.0"]
