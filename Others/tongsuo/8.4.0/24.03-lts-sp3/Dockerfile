ARG BASE=openeuler/openeuler:24.03-lts-sp3
FROM ${BASE} AS builder

ARG VERSION=8.4.0

RUN dnf install -y gcc gcc-c++ make perl perl-Text-Template wget tar \
    && dnf clean all \
    && rm -rf /var/cache/dnf

RUN wget https://github.com/Tongsuo-Project/Tongsuo/archive/refs/tags/${VERSION}.tar.gz -O Tongsuo-${VERSION}.tar.gz \
    && tar -zxf Tongsuo-${VERSION}.tar.gz \
    && cd Tongsuo-${VERSION} \
    && ./config --prefix=/usr/local/tongsuo \
    && make -j$(nproc) \
    && make install

FROM ${BASE}

COPY --from=builder /usr/local/tongsuo /usr/local/tongsuo

ENV PATH=$PATH:/usr/local/tongsuo/bin
ENV LD_LIBRARY_PATH=/usr/local/tongsuo/lib64:/usr/local/tongsuo/lib
RUN found=""; for d in /usr/local/tongsuo/lib64 /usr/local/tongsuo/lib; do \
      if [ -f "$d/libssl.so.3" ] && [ -f "$d/libcrypto.so.3" ]; then \
        cp -f "$d/libssl.so.3" "$d/libcrypto.so.3" /usr/lib64/; found=1; \
      fi; \
    done; \
    if [ -z "$found" ]; then echo "tongsuo shared libraries not found"; exit 1; fi; \
    ldconfig

CMD ["tongsuo", "help"]
