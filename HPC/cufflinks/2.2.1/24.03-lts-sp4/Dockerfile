ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE}

ARG VERSION=2.2.1

RUN dnf install -y \
      gcc gcc-c++ make automake autoconf libtool \
      boost-devel eigen3-devel zlib-devel \
      samtools-devel ncurses-devel \
      curl && \
    dnf clean all

RUN mkdir -p /tmp/samtools-build && \
    curl -fSL https://github.com/samtools/samtools/archive/0.1.19.tar.gz | tar xz --strip-components=1 -C /tmp/samtools-build && \
    cd /tmp/samtools-build && \
    make -j$(nproc) libbam.a && \
    mkdir -p /usr/local/include/bam && \
    cp *.h /usr/local/include/bam/ && \
    cp libbam.a /usr/local/lib64/ && \
    cd / && rm -rf /tmp/samtools-build

RUN mkdir -p /tmp/cufflinks-build && \
    curl -fSL https://github.com/cole-trapnell-lab/cufflinks/archive/refs/tags/v${VERSION}.tar.gz | tar xz --strip-components=1 -C /tmp/cufflinks-build

WORKDIR /tmp/cufflinks-build

RUN mkdir -p /usr/include/boost/tr1 && \
    for h in unordered_map unordered_set array tuple memory functional random regex; do \
        if [ -f /usr/include/boost/$h.hpp ]; then \
            echo "#include <boost/$h.hpp>" > /usr/include/boost/tr1/$h.hpp; \
        fi; \
    done && \
    sed -i 's/\bhash\b/hash_val/g' src/GHash.hh && \
    sed -i '16s/.*//' configure.ac && \
    autoreconf -fiv && \
    ./configure --prefix=/usr/local \
        CPPFLAGS="-I/usr/local/include -I/usr/include/eigen3" \
        LDFLAGS="-L/usr/local/lib64 -lboost_serialization -lboost_thread -lboost_system" \
        CC="gcc -fcommon" \
        CXX="g++ -std=gnu++14 -fcommon -fpermissive -Wno-maybe-uninitialized -Wno-class-memaccess" && \
    make -j$(nproc) && \
    make install && \
    cd / && rm -rf /tmp/cufflinks-build

WORKDIR /data

CMD ["cufflinks", "--help"]
