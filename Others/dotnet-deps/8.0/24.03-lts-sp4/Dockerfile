ARG BASE=openeuler/openeuler:24.03-lts-sp4
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
        shadow \
        tzdata \
        zlib && \
    yum clean all

RUN groupadd --gid=$APP_UID app && \
    useradd -l --uid=$APP_UID --gid=$APP_UID --create-home app
