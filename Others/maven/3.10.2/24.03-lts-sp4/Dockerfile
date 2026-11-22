ARG BASE=openeuler/openeuler:24.03-lts-sp4

FROM ${BASE} AS builder
# autopilot: refresh dnf metadata
RUN rm -rf /var/cache/dnf /var/cache/yum \
    && (dnf clean all 2>/dev/null || yum clean all 2>/dev/null || true) \
    && mkdir -p /etc/dnf \
    && (grep -qxF skip_if_unavailable=True /etc/dnf/dnf.conf 2>/dev/null \
        || echo skip_if_unavailable=True >> /etc/dnf/dnf.conf)

ARG TARGETARCH
ARG BUILDARCH

ARG VERSION=3.10.2
ARG BOOTSTRAP_VERSION=3.10.1

RUN yum install -y java-1.8.0-openjdk java-1.8.0-openjdk-devel git wget tar gzip && \
    yum clean all && \
    rm -rf /var/cache/yum

RUN wget -q https://archive.apache.org/dist/maven/maven-3/${BOOTSTRAP_VERSION}/binaries/apache-maven-${BOOTSTRAP_VERSION}-bin.tar.gz -O /tmp/apache-maven-bootstrap.tar.gz && \
    tar -zxf /tmp/apache-maven-bootstrap.tar.gz -C /opt && \
    rm -f /tmp/apache-maven-bootstrap.tar.gz

RUN git clone --depth 1 --branch maven-${VERSION} https://github.com/apache/maven /tmp/maven-src

RUN cd /tmp/maven-src && \
    /opt/apache-maven-${BOOTSTRAP_VERSION}/bin/mvn -B -ntp -DdistributionTargetDir=/opt/apache-maven-${VERSION} -DskipTests -Dmaven.javadoc.skip=true clean package

FROM ${BASE}
# autopilot: refresh dnf metadata
RUN rm -rf /var/cache/dnf /var/cache/yum \
    && (dnf clean all 2>/dev/null || yum clean all 2>/dev/null || true) \
    && mkdir -p /etc/dnf \
    && (grep -qxF skip_if_unavailable=True /etc/dnf/dnf.conf 2>/dev/null \
        || echo skip_if_unavailable=True >> /etc/dnf/dnf.conf)

ARG TARGETARCH
ARG BUILDARCH

ARG VERSION=3.10.2

RUN yum update -y && \
    yum install -y java-1.8.0-openjdk java-1.8.0-openjdk-devel jq wget tar gzip && \
    yum clean all && \
    rm -rf /var/cache/yum

COPY --from=builder /opt/apache-maven-${VERSION} /opt/apache-maven-${VERSION}
RUN ln -s /opt/apache-maven-${VERSION} /opt/maven

ENV MAVEN_HOME=/opt/maven
ENV PATH=${MAVEN_HOME}/bin:${PATH}

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
