ARG BASE=openeuler/openeuler:24.03-lts-sp2
FROM ${BASE}
ARG VERSION=1.6.0
ARG PREFIX_DIR=/opt/guacamole
ARG UID=1000
ARG GID=1000
ARG GUACAMOLE_SERVER_OPTS="\
    --disable-guaclog"
RUN yum install -y git ffmpeg ffmpeg-devel openssl openssl-devel freerdp-plugins java-1.8.0-openjdk \
    libvncserver-devel vim libxkbfile-devel libX11-devel libXrandr-devel libXi-devel libXrender-devel \
	libXext-devel libXinerama-devel libXfixes-devel libXcursor-devel libXv-devel libXdamage-devel \
	libXtst-devel cups-devel cairo-devel pcsc-lite-devel uuid-devel libxml2-devel zlib-devel krb5-devel \
	libtiff-devel libtiff-devel libjpeg-turbo-devel giflib-devel wget cmake libusbx-devel pulseaudio-libs-devel \
	docbook-style-xsl pango-devel libvorbis-devel libwebsockets-devel libssh2-devel libwebp libwebp-devel \
	freerdp freerdp-devel libpng-devel libtool CUnit-devel nc

ENV CFLAGS=-I${PREFIX_DIR}/include
ENV LDFLAGS=-L${PREFIX_DIR}/lib
ENV PKG_CONFIG_PATH=${PREFIX_DIR}/lib/pkgconfig


RUN cd /tmp && curl -fSL -o guacamole-server.tar.gz https://github.com/apache/guacamole-server/archive/refs/tags/${VERSION}.tar.gz && \
	mkdir guacamole-server && tar -zxvf guacamole-server.tar.gz -C  guacamole-server --strip-components=1 && \
	cd guacamole-server && autoreconf -fi && \
	./configure --prefix="$PREFIX_DIR" $GUACAMOLE_SERVER_OPTS && \
	make -j $(nproc) && make check && make install

ENV LC_ALL=C.UTF-8
ENV LD_LIBRARY_PATH=${PREFIX_DIR}/lib
ENV GUACD_LOG_LEVEL=info

HEALTHCHECK --interval=5m --timeout=5s CMD nc -z 127.0.0.1 4822 || exit 1

RUN groupadd --gid $GID guacd
RUN useradd --system --create-home --shell /sbin/nologin --uid $UID --gid $GID guacd

USER guacd
EXPOSE 4822

CMD /opt/guacamole/sbin/guacd -b 0.0.0.0 -L $GUACD_LOG_LEVEL -f