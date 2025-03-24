ARG BASE=openeuler/openeuler:22.03-lts-sp1
FROM ${BASE}

ARG TARGETARCH
ARG BUILDARCH
ARG VERSION=9.0.1

ENV ASPNETCORE_URLS=http://+:8080 \
    DOTNET_RUNNING_IN_CONTAINER=true \
    DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=true

RUN if [ "$TARGETARCH" = "amd64" ]; then \
      BUILDARCH="x64"; \
    elif [ "$TARGETARCH" = "arm64" ]; then \
      BUILDARCH="arm64"; \
    fi && \
    yum update -y && yum install -y libicu && yum clean all && \
    curl -fSL -o dotnet.tar.gz https://dotnetcli.azureedge.net/dotnet/Runtime/${VERSION}/dotnet-runtime-${VERSION}-linux-${BUILDARCH}.tar.gz && \
    curl -fSL -o aspnetcore.tar.gz https://dotnetcli.azureedge.net/dotnet/aspnetcore/Runtime/${VERSION}/aspnetcore-runtime-${VERSION}-linux-${BUILDARCH}.tar.gz && \
    mkdir -p /dotnet-runtime && tar -zxvf dotnet.tar.gz -C /dotnet-runtime && \
    mkdir -p /dotnet-aspnet && tar -oxzf aspnetcore.tar.gz -C /dotnet-aspnet ./shared/Microsoft.AspNetCore.App && \
    mv /dotnet-runtime /usr/share/dotnet && \
    cp -rf /dotnet-aspnet/* /usr/share/dotnet/ && \
    rm -f aspnetcore.tar.gz && rm -rf /dotnet-aspnet && \
    rm -f dotnet.tar.gz

RUN ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet

ENTRYPOINT [ "dotnet" ]

CMD [ "--info" ]
