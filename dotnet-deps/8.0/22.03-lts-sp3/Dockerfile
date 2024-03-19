ARG BASE=openeuler/openeuler:22.03-lts-sp3
FROM ${BASE}

ENV APP_UID=1654 \
    ASPNETCORE_HTTP_PORTS=8080 \
    DOTNET_RUNNING_IN_CONTAINER=true

RUN yum update -y && \
    yum install -y \
        ca-certificates \
        glibc \
        libgcc \
        libicu \
        openssl-libs \
        libstdc++ \
        tzdata \
        zlib && \
    rm -rf /var/lib/apt/lists/* && \
    yum clean all

RUN groupadd --gid=$APP_UID app && \
    useradd -l --uid=$APP_UID --gid=$APP_UID --create-home app
