ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM ${BASE}
ARG VERSION=1.8.0
ARG GNUPLOT_VERSION=5.4.5

ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8

RUN dnf install -y wget make gcc-g++ findutils \
    readline-devel libpng-devel gd-devel \
    cairo-devel pango-devel \
    lua-devel qt5-qtbase-devel \
    && dnf clean all \
    && rm -rf /var/cache/dnf/*

RUN wget https://sourceforge.net/projects/gnuplot/files/gnuplot/${GNUPLOT_VERSION}/gnuplot-${GNUPLOT_VERSION}.tar.gz \
    && tar -xf gnuplot-${GNUPLOT_VERSION}.tar.gz \
    && rm -f gnuplot-${GNUPLOT_VERSION}.tar.gz \
    && cd gnuplot-${GNUPLOT_VERSION} \
    && ./configure --prefix=/usr/local/gnuplot-${GNUPLOT_VERSION} \
            --with-readline=gnu \
            --with-cairo \
            --with-qt \
            --with-gd \
            --enable-largefile \
    && make -j$(nproc) \
    && make install 

ENV PATH=/usr/local/gnuplot-${GNUPLOT_VERSION}/bin:$PATH

RUN wget https://gitlab.com/openlb/release/-/archive/${VERSION}/release-${VERSION}.tar.gz -O /home/olb.tar.gz && \
    tar -xvf /home/olb.tar.gz -C /home && \
    cd  /home/release-${VERSION} && \
    make -j $(nproc) && \
    rm -rf olb*

WORKDIR /home/release-${VERSION}

CMD [ "bash" ]