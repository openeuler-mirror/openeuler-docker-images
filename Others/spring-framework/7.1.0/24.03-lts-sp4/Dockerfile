ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE}
# autopilot: refresh dnf metadata
RUN rm -rf /var/cache/dnf /var/cache/yum \
    && (dnf clean all 2>/dev/null || yum clean all 2>/dev/null || true) \
    && mkdir -p /etc/dnf \
    && (grep -qxF skip_if_unavailable=True /etc/dnf/dnf.conf 2>/dev/null \
        || echo skip_if_unavailable=True >> /etc/dnf/dnf.conf)
ARG VERSION=7.1.0

RUN dnf update -y \
    && dnf install -y java-17-openjdk gettext wget \
    && dnf clean all \
    && rm -rf /var/cache/dnf/*

ARG MAVEN_VERSION=3.9.12
RUN wget https://archive.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz \
    && mkdir -p /usr/local/maven \
    && tar -zxvf apache-maven-${MAVEN_VERSION}-bin.tar.gz -C /usr/local/maven --strip-components=1

ENV PATH=/usr/local/maven/bin:$PATH

WORKDIR /home/spring-framework
COPY example src/main/java/com/example
COPY pom.xml.template pom.xml.template

ENV SPRING_VERSION=${VERSION}

RUN envsubst < pom.xml.template > pom.xml \
    && mvn clean compile dependency:build-classpath -Dmdep.outputFile=target/classpath.txt

CMD CLASS_PATH="target/classes:$(cat target/classpath.txt)" && \
    java -cp "$CLASS_PATH" com.example.MainApp
