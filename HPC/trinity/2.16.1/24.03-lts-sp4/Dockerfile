ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE} AS builder

ARG VERSION=2.16.1

RUN dnf install -y \
      gcc gcc-c++ make cmake \
      autoconf automake libtool \
      perl python3 \
      rsync unzip \
      zlib-devel bzip2-devel xz-devel \
      curl && \
    dnf clean all && \
    ln -sf /usr/bin/python3 /usr/bin/python

RUN curl -fSL --connect-timeout 60 --retry 5 --retry-delay 5 \
      -o /tmp/trinity-${VERSION}.FULL.tar.gz \
      https://github.com/trinityrnaseq/trinityrnaseq/releases/download/Trinity-v${VERSION}/trinityrnaseq-v${VERSION}.FULL.tar.gz && \
    echo "5045c3e245b2a73578154737c4d18c7e2919e676746ef00ac16f2d61dfaff3b8  /tmp/trinity-${VERSION}.FULL.tar.gz" | sha256sum -c - && \
    mkdir -p /tmp/trinity-src && \
    tar -zxf /tmp/trinity-${VERSION}.FULL.tar.gz --strip-components=1 -C /tmp/trinity-src && \
    rm -f /tmp/trinity-${VERSION}.FULL.tar.gz

WORKDIR /tmp/trinity-src

RUN make && \
    make plugins && \
    make install

RUN curl -fSL --connect-timeout 60 --retry 5 --retry-delay 5 \
      -o /tmp/jellyfish-2.3.1.tar.gz \
      https://github.com/gmarcais/Jellyfish/releases/download/v2.3.1/jellyfish-2.3.1.tar.gz && \
    mkdir -p /tmp/jellyfish-src && \
    tar -zxf /tmp/jellyfish-2.3.1.tar.gz --strip-components=1 -C /tmp/jellyfish-src && \
    rm -f /tmp/jellyfish-2.3.1.tar.gz && \
    cd /tmp/jellyfish-src && \
    ./configure --prefix=/usr/local && \
    make -j$(nproc) && \
    make install && \
    cd / && \
    rm -rf /tmp/jellyfish-src

RUN ARCH=$(uname -m) && \
    case "${ARCH}" in \
      x86_64) BT2_SUM=38472e806f56ed23d32cbe7a7fe1b7260680f892647aa78c2f6882f8f272a026 ;; \
      aarch64) BT2_SUM=d6fd63a46b92308aca32ddcc562f3e7897303ab48656693972a2543bffa07fcc ;; \
      *) echo "unsupported architecture: ${ARCH}"; exit 1 ;; \
    esac && \
    curl -fSL --connect-timeout 60 --retry 5 --retry-delay 5 \
      -o /tmp/bowtie2.zip \
      https://github.com/BenLangmead/bowtie2/releases/download/v2.5.5/bowtie2-2.5.5-linux-${ARCH}.zip && \
    echo "${BT2_SUM}  /tmp/bowtie2.zip" | sha256sum -c - && \
    mkdir -p /tmp/bowtie2 && \
    unzip -q /tmp/bowtie2.zip -d /tmp/bowtie2 && \
    cp /tmp/bowtie2/bowtie2-2.5.5-linux-${ARCH}/bowtie2* /usr/local/bin/ && \
    rm -rf /tmp/bowtie2 /tmp/bowtie2.zip

RUN ARCH=$(uname -m) && \
    if [ "${ARCH}" = "x86_64" ]; then \
      curl -fSL --connect-timeout 60 --retry 5 --retry-delay 5 \
        -o /tmp/salmon.tar.gz \
        https://github.com/COMBINE-lab/salmon/releases/download/v1.10.0/salmon-1.10.0_linux_x86_64.tar.gz && \
      mkdir -p /usr/local/salmon && \
      tar -zxf /tmp/salmon.tar.gz --strip-components=1 -C /usr/local/salmon && \
      ln -s /usr/local/salmon/bin/salmon /usr/local/bin/salmon && \
      rm -f /tmp/salmon.tar.gz ; \
    else \
      dnf install -y boost-devel tbb-devel libcurl-devel libzstd-devel && \
      dnf clean all && \
      curl -fSL --connect-timeout 60 --retry 5 --retry-delay 5 \
        -o /tmp/salmon-src.tar.gz \
        https://github.com/COMBINE-lab/salmon/archive/refs/tags/v1.10.0.tar.gz && \
      mkdir -p /tmp/salmon-src && \
      tar -zxf /tmp/salmon-src.tar.gz --strip-components=1 -C /tmp/salmon-src && \
      rm -f /tmp/salmon-src.tar.gz && \
      cd /tmp/salmon-src && \
      mkdir -p build && cd build && \
      cmake -DCMAKE_INSTALL_PREFIX=/usr/local .. && \
      make -j$(nproc) && \
      make install && \
      cd / && \
      rm -rf /tmp/salmon-src ; \
    fi

FROM ${BASE}

RUN dnf install -y \
      samtools \
      java-1.8.0-openjdk \
      perl \
      python3 python3-numpy \
      tbb && \
    dnf clean all && \
    ln -sf /usr/bin/python3 /usr/bin/python

COPY --from=builder /usr/local /usr/local

ENV PATH=/usr/local/bin:$PATH \
    TRINITY_HOME=/usr/local/bin \
    LD_LIBRARY_PATH=/usr/local/lib

WORKDIR /data

USER root

CMD ["/bin/bash"]
