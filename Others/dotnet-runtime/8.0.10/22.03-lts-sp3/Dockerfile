ARG BASE=openeuler/openeuler:22.03-lts-sp3
FROM ${BASE}

ARG TARGETARCH
ARG BUILDARCH
ARG VERSION=8.0.10

ENV ASPNETCORE_URLS=http://+:8080 \
    DOTNET_RUNNING_IN_CONTAINER=true \
    DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=true

RUN if [ "$TARGETARCH" = "amd64" ]; then \
      BUILDARCH="x64"; \
    elif [ "$TARGETARCH" = "arm64" ]; then \
      BUILDARCH="arm64"; \
    fi && \
    curl -fSL -o dotnet.tar.gz https://dotnetcli.azureedge.net/dotnet/Runtime/${VERSION}/dotnet-runtime-${VERSION}-linux-${BUILDARCH}.tar.gz && \
    mkdir -p /dotnet && tar -zxvf dotnet.tar.gz -C /dotnet && \
    mv /dotnet /usr/share/dotnet && \
    rm -f dotnet.tar.gz

RUN ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet

ENTRYPOINT [ "dotnet" ]

CMD [ "--info" ]
