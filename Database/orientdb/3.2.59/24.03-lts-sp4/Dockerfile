ARG BASE=openeuler/openeuler:24.03-lts-sp4

FROM ${BASE} AS build
# autopilot: refresh dnf metadata
RUN rm -rf /var/cache/dnf /var/cache/yum \
    && (dnf clean all 2>/dev/null || yum clean all 2>/dev/null || true) \
    && mkdir -p /etc/dnf \
    && (grep -qxF skip_if_unavailable=True /etc/dnf/dnf.conf 2>/dev/null \
        || echo skip_if_unavailable=True >> /etc/dnf/dnf.conf)

ARG VERSION=3.2.59

RUN yum install -y wget unzip java-1.8.0-openjdk-devel

RUN mkdir /build \
    && wget -O /build/orientdb-src.tar.gz https://github.com/orientechnologies/orientdb/archive/refs/tags/${VERSION}.tar.gz \
    && tar -xzf /build/orientdb-src.tar.gz -C /build --strip-components=1 \
    && rm -f /build/orientdb-src.tar.gz

WORKDIR /build

RUN wget -O /build/orientdb-studio.zip https://repo1.maven.org/maven2/com/orientechnologies/orientdb-studio/3.2.58/orientdb-studio-3.2.58.zip \
    && ./mvnw -B install:install-file -Dfile=/build/orientdb-studio.zip -DgroupId=com.orientechnologies -DartifactId=orientdb-studio -Dversion=${VERSION} -Dpackaging=zip

RUN ./mvnw -B clean install -pl distribution -am -DskipTests

FROM ${BASE}
# autopilot: refresh dnf metadata
RUN rm -rf /var/cache/dnf /var/cache/yum \
    && (dnf clean all 2>/dev/null || yum clean all 2>/dev/null || true) \
    && mkdir -p /etc/dnf \
    && (grep -qxF skip_if_unavailable=True /etc/dnf/dnf.conf 2>/dev/null \
        || echo skip_if_unavailable=True >> /etc/dnf/dnf.conf)

ARG VERSION=3.2.59

RUN yum install -y java-1.8.0-openjdk

COPY --from=build /build/distribution/target/orientdb-community-${VERSION}.tar.gz /orientdb-community.tar.gz

RUN mkdir /orientdb \
    && tar -xvzf /orientdb-community.tar.gz -C /orientdb --strip-components=1 \
    && rm -f /orientdb-community.tar.gz

WORKDIR /orientdb

ENV PATH /orientdb/bin:$PATH

VOLUME ["/orientdb/backup", "/orientdb/databases", "/orientdb/config"]

EXPOSE 2480

CMD ["server.sh"]
