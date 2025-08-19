ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM ${BASE} AS builder

ARG VERSION=15.2.0

RUN dnf update -y \
    && dnf install -y gcc gcc-c++ make bison flex \
    gmp-devel mpfr-devel libmpc-devel diffutils \
    zlib-devel texinfo isl-devel wget \
    && dnf clean all \
    && rm -rf /var/cache/dnf

WORKDIR /opt

RUN wget https://mirrors.ustc.edu.cn/gnu/gcc/gcc-${VERSION}/gcc-${VERSION}.tar.gz \
    && tar -zxvf gcc-${VERSION}.tar.gz \
    && rm -f gcc-${VERSION}.tar.gz

WORKDIR /opt/gcc-${VERSION}

RUN mkdir -p gcc-deps \
    && cd gcc-deps \
    && wget https://mirrors.ustc.edu.cn/gnu/gmp/gmp-6.2.1.tar.bz2 \
    && wget https://mirrors.ustc.edu.cn/gnu/mpfr/mpfr-4.1.0.tar.bz2 \
    && wget https://mirrors.ustc.edu.cn/gnu/mpc/mpc-1.2.1.tar.gz \
    && wget https://mirrors.ustc.edu.cn/gnu/gettext/gettext-0.22.tar.gz \
    && wget https://libisl.sourceforge.io/isl-0.24.tar.bz2 \
    && ln -s gmp-6.2.1 ../gmp \
    && ln -s mpfr-4.1.0 ../mpfr \
    && ln -s mpc-1.2.1 ../mpc \
    && ln -s isl-0.24 ../isl \
    && ln -s gettext-0.22 ../gettext

RUN dnf install -y diffutils
RUN mkdir -p gcc-build \
    && cd gcc-build \
    && ../configure --prefix=/usr/local/gcc --enable-languages=c,c++ --disable-multilib \
    && make -j$(nproc) \
    && make install

WORKDIR /usr/local/gcc

CMD ["./bin/gcc", "--help"]