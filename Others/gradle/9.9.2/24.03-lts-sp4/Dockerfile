ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE} AS builder
# autopilot: refresh dnf metadata
RUN rm -rf /var/cache/dnf /var/cache/yum \
    && (dnf clean all 2>/dev/null || yum clean all 2>/dev/null || true) \
    && mkdir -p /etc/dnf \
    && (grep -qxF skip_if_unavailable=True /etc/dnf/dnf.conf 2>/dev/null \
        || echo skip_if_unavailable=True >> /etc/dnf/dnf.conf)

ARG VERSION=9.9.2

RUN dnf install -y \
      curl unzip && \
    dnf clean all

RUN curl -fSL --connect-timeout 30 --retry 5 --retry-delay 5 \
      -o /tmp/gradle-${VERSION}-bin.zip \
      https://services.gradle.org/distributions/gradle-${VERSION}-bin.zip && \
    echo "971fcd7150ca4ba04852c0b2ca0d2d0ab9468e14b03473eab19528809914c76b  /tmp/gradle-${VERSION}-bin.zip" | sha256sum -c - && \
    unzip -q /tmp/gradle-${VERSION}-bin.zip -d /opt/gradle && \
    rm -f /tmp/gradle-${VERSION}-bin.zip

FROM ${BASE}
# autopilot: refresh dnf metadata
RUN rm -rf /var/cache/dnf /var/cache/yum \
    && (dnf clean all 2>/dev/null || yum clean all 2>/dev/null || true) \
    && mkdir -p /etc/dnf \
    && (grep -qxF skip_if_unavailable=True /etc/dnf/dnf.conf 2>/dev/null \
        || echo skip_if_unavailable=True >> /etc/dnf/dnf.conf)

ARG VERSION=9.9.2

RUN dnf install -y \
      java-21-openjdk-headless && \
    dnf clean all

COPY --from=builder /opt/gradle/gradle-${VERSION} /opt/gradle

ENV GRADLE_HOME=/opt/gradle
ENV PATH=${GRADLE_HOME}/bin:${PATH}

USER root
WORKDIR /workspace

CMD ["gradle", "--version"]
