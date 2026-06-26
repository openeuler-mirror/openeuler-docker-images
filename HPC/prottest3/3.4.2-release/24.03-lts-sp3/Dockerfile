ARG BASE=openeuler/openeuler:24.03-lts-sp3
FROM ${BASE}

ARG VERSION=3.4.2-release

RUN dnf install -y \
      java-11-openjdk-devel \
      ant \
      gcc gcc-c++ make automake autoconf \
      curl && \
    dnf clean all

RUN mkdir -p /tmp/phyml-build && \
    curl -fSL https://github.com/stephaneguindon/phyml/archive/refs/heads/master.tar.gz | tar xz --strip-components=1 -C /tmp/phyml-build && \
    cd /tmp/phyml-build && \
    sh ./autogen.sh && \
    ./configure --enable-phyml && \
    make -j$(nproc) && \
    mkdir -p /opt/phyml && \
    cp src/phyml /opt/phyml/ && \
    cd / && rm -rf /tmp/phyml-build

RUN mkdir -p /tmp/prottest3-build && \
    curl -fSL https://github.com/ddarriba/prottest3/archive/refs/tags/${VERSION}.tar.gz | tar xz --strip-components=1 -C /tmp/prottest3-build

WORKDIR /tmp/prottest3-build

RUN sed -i 's/<javac /<javac encoding="UTF-8" /' build.xml && \
    ant jar && \
    cp /opt/phyml/phyml dist/bin/PhyML_3.0_linux32 && \
    mkdir -p /opt/prottest3 && \
    mv dist /opt/prottest3/ && \
    cd / && rm -rf /tmp/prottest3-build

RUN echo '#!/bin/bash' > /usr/local/bin/prottest3 && \
    echo "java -jar /opt/prottest3/dist/prottest-3.4.2.jar \"\$@\"" >> /usr/local/bin/prottest3 && \
    chmod +x /usr/local/bin/prottest3

WORKDIR /data

CMD ["prottest3", "-h"]
