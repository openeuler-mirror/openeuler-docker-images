ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE} as Builder
# autopilot: refresh dnf metadata
RUN rm -rf /var/cache/dnf /var/cache/yum \
    && (dnf clean all 2>/dev/null || yum clean all 2>/dev/null || true) \
    && mkdir -p /etc/dnf \
    && (grep -qxF skip_if_unavailable=True /etc/dnf/dnf.conf 2>/dev/null \
        || echo skip_if_unavailable=True >> /etc/dnf/dnf.conf)
ARG VERSION=4.2.0

RUN dnf update -y  \
    && dnf install -y wget gettext java-17-openjdk java-17-openjdk-devel \
    && dnf clean all \
    && rm -rf /var/run/cache/*

ARG MAVEN_VERSION=3.9.12
RUN wget https://repo.huaweicloud.com/apache/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz \
    && mkdir -p /usr/local/maven \
    && tar -zxvf apache-maven-${MAVEN_VERSION}-bin.tar.gz -C /usr/local/maven --strip-components=1

ENV PATH=/usr/local/maven/bin:$PATH

COPY Application.java /spring-boot/src/main/java/com/spring/boot/Application.java
COPY pom.xml.template /spring-boot/pom.xml.template

ENV SPRING_BOOT_VERSION=${VERSION}

WORKDIR spring-boot

RUN envsubst < pom.xml.template > pom.xml \
    && sed -i "s|<version>3.4.4</version>|<version>${SPRING_BOOT_VERSION}</version>|" pom.xml \
    && mvn clean install -Dmaven.test.skip


FROM ${BASE}
# autopilot: refresh dnf metadata
RUN rm -rf /var/cache/dnf /var/cache/yum \
    && (dnf clean all 2>/dev/null || yum clean all 2>/dev/null || true) \
    && mkdir -p /etc/dnf \
    && (grep -qxF skip_if_unavailable=True /etc/dnf/dnf.conf 2>/dev/null \
        || echo skip_if_unavailable=True >> /etc/dnf/dnf.conf)

RUN yum update -y \
    && yum install -y wget java-17-openjdk

ENV WORKSPACE=/home/spring-boot

WORKDIR ${WORKSPACE}

COPY --from=Builder /spring-boot/target ${WORKSPACE}/target

ENV LANG="C.UTF-8"

EXPOSE 8080

CMD java -jar ${WORKSPACE}/target/demo-1.0.jar
