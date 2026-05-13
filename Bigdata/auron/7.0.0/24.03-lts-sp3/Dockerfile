FROM openeuler/openeuler:24.03-lts-sp3 AS builder

ARG MAVEN_VERSION=3.9.12
ARG AURON_VERSION=7.0.0

RUN dnf install -y java-17-openjdk-devel git curl gcc-c++ make && \
    dnf clean all

ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain stable
ENV PATH="/root/.cargo/bin:${PATH}"

RUN curl -fSL -o apache-maven.tar.gz https://repo.huaweicloud.com/apache/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz && \
    mkdir -p /usr/local/maven && \
    tar -zxf apache-maven.tar.gz -C /usr/local/maven --strip-components=1 && \
    rm -rf apache-maven.tar.gz
ENV PATH="/usr/local/maven/bin:${PATH}"

WORKDIR /build
RUN git clone --depth 1 --branch v${AURON_VERSION} https://github.com/apache/auron.git .

RUN ./auron-build.sh --release --sparkver 3.5 --scalaver 2.12

FROM openeuler/openeuler:24.03-lts-sp3

RUN dnf install -y java-17-openjdk-devel && \
    dnf clean all

ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk

COPY --from=builder /build/target/auron-spark_2.12-release-*.jar /opt/auron/

WORKDIR /opt/auron
