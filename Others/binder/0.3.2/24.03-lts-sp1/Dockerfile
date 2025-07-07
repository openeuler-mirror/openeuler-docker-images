ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM ${BASE}
ARG VERSION=0.3.2

RUN dnf install -y \
    wget \
    gcc-c++ \
    gnome-common \
    make \
    gtk-doc \
    gtk3-devel \
    patch \
    && dnf clean all \
    && rm -rf /var/cache/dnf/*

WORKDIR /opt

RUN wget https://github.com/kupferlauncher/keybinder/archive/refs/tags/keybinder-3.0-v${VERSION}.tar.gz \
    && tar -zxvf keybinder-3.0-v${VERSION}.tar.gz \
    && rm -f keybinder-3.0-v${VERSION}.tar.gz

WORKDIR /opt/keybinder-keybinder-3.0-v${VERSION}

COPY Fix-gtk-doc-build-failure.patch /opt/keybinder-keybinder-3.0-v${VERSION}/Fix-gtk-doc-build-failure.patch

RUN patch -p1 < /opt/keybinder-keybinder-3.0-v${VERSION}/Fix-gtk-doc-build-failure.patch \
    && ./autogen.sh \
    && ./configure --enable-gtk-doc \
    && make -j$(nproc) \
    && make install

ENV LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH

CMD ["bash"]
