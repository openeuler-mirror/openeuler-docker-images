ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE} AS build
# autopilot: refresh dnf metadata
RUN rm -rf /var/cache/dnf /var/cache/yum \
    && (dnf clean all 2>/dev/null || yum clean all 2>/dev/null || true) \
    && mkdir -p /etc/dnf \
    && (grep -qxF skip_if_unavailable=True /etc/dnf/dnf.conf 2>/dev/null \
        || echo skip_if_unavailable=True >> /etc/dnf/dnf.conf)

ARG TARGETARCH
ARG BUILDARCH
ARG VERSION=28.26

RUN dnf install -y --setopt=install_weak_deps=False \
        gcc gcc-c++ make autoconf diffutils m4 patch cpio \
        freetype-devel fontconfig-devel alsa-lib-devel cups-devel libffi-devel \
        curl tar git zip unzip which file \
    && dnf clean all

RUN if [ "$TARGETARCH" = "amd64" ]; then \
      BUILDARCH="x64"; \
    elif [ "$TARGETARCH" = "arm64" ]; then \
      BUILDARCH="aarch64"; \
    fi && \
    mkdir -p /opt/bootjdk && \
    curl -fSL --output /tmp/bootjdk.tar.gz https://download.java.net/java/GA/jdk27.0.1.1/c3a705caf5044be8aa0b09e62be69b20/4/GPL/openjdk-27.0.1.1_linux-${BUILDARCH}_bin.tar.gz && \
    tar -xzf /tmp/bootjdk.tar.gz -C /opt/bootjdk --strip-components=1 && \
    rm -f /tmp/bootjdk.tar.gz

RUN mkdir -p /build/src && \
    curl -fSL --output /tmp/jdk-src.tar.gz https://github.com/openjdk/jdk/archive/refs/tags/jdk-${VERSION%%.*}%2B${VERSION#*.}.tar.gz && \
    tar -xzf /tmp/jdk-src.tar.gz -C /build/src --strip-components=1 && \
    rm -f /tmp/jdk-src.tar.gz

RUN cd /build/src && \
    bash configure \
        --with-boot-jdk=/opt/bootjdk \
        --with-version-build=${VERSION#*.} \
        --with-version-pre=ea \
        --without-version-opt \
        --enable-headless-only \
        --with-jvm-variants=server \
    && make images \
    && mkdir -p /opt/java \
    && cp -r /build/src/build/*/images/jdk/. /opt/java/

FROM ${BASE}

COPY --from=build /opt/java/ /usr/local/java/

ENV JAVA_HOME=/usr/local/java/
ENV PATH=$JAVA_HOME/bin:$PATH
ENV CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar

CMD ["bash"]
