ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE} AS builder

ARG VERSION=9.1

RUN dnf install -y \
      gcc make diffutils \
      pkgconf \
      && if [ "$(uname -m)" = "x86_64" ]; then dnf install -y nasm; fi && \
    dnf clean all

WORKDIR /opt

RUN curl -fSL --connect-timeout 30 --max-time 600 --retry 3 --retry-delay 5 \
      -o ffmpeg.tar.gz \
      https://github.com/FFmpeg/FFmpeg/archive/refs/tags/n${VERSION}.tar.gz \
    && echo "0ac7c9b9806b58eda00a528dcba316a2f33d291d949438900efa811d04b051bd  ffmpeg.tar.gz" | sha256sum -c - \
    && tar -zxf ffmpeg.tar.gz --strip-components=1 \
    && rm -f ffmpeg.tar.gz

RUN ./configure --prefix=/usr/local --disable-debug --disable-doc \
      --enable-shared --disable-static \
    && make -j$(nproc) \
    && make install DESTDIR=/opt/ffmpeg-root

FROM ${BASE}

COPY --from=builder /opt/ffmpeg-root/usr/local/ /usr/local/

RUN printf '/usr/local/lib\n' > /etc/ld.so.conf.d/ffmpeg.conf \
    && ldconfig

WORKDIR /workspace

USER root

CMD ["ffmpeg", "-version"]
