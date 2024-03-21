ARG BASE=openeuler/openeuler:22.03-lts-sp3
FROM ${BASE}

ARG TARGETARCH
ARG BUILDARCH
ARG VERSION=8.0.3

RUN if [ "$TARGETARCH" = "amd64" ]; then \
      BUILDARCH="x64"; \
    elif [ "$TARGETARCH" = "arm64" ]; then \
      BUILDARCH="arm64"; \
    fi && \
    yum update -y && yum install -y wget && yum clean all && \
    wget -O dotnet.tar.gz https://dotnetcli.azureedge.net/dotnet/Runtime/${VERSION}/dotnet-runtime-${VERSION}-linux-${BUILDARCH}.tar.gz && \
    mkdir -p /dotnet && tar -zxvf dotnet.tar.gz -C /dotnet && \
    mv /dotnet /usr/share/dotnet && \
    rm -f dotnet.tar.gz

RUN ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet

CMD [ "dotnet", "--info" ]
