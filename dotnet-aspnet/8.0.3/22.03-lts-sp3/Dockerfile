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
    curl -fSL --output aspnetcore.tar.gz https://dotnetcli.azureedge.net/dotnet/aspnetcore/Runtime/${VERSION}/aspnetcore-runtime-${VERSION}-linux-${BUILDARCH}.tar.gz && \
    mkdir -p /dotnet && tar -oxzf aspnetcore.tar.gz -C /dotnet ./shared/Microsoft.AspNetCore.App && \
    mv /dotnet /usr/share/dotnet && \
    rm -f aspnetcore.tar.gz
