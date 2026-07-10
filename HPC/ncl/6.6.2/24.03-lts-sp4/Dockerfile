ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE}

ARG TARGETARCH
ARG VERSION=6.6.2

RUN dnf install -y \
      gcc gcc-c++ gcc-gfortran make \
      tcsh \
      curl \
      libX11-devel libXext-devel libXrender-devel \
      fontconfig-devel freetype-devel \
      cairo-devel expat-devel \
      libpng-devel libjpeg-turbo-devel && \
    dnf clean all

RUN dnf install -y util-linux

RUN mkdir -p /tmp/ncl-build && \
    curl -fSL https://github.com/NCAR/ncl/archive/${VERSION}.tar.gz | tar xz --strip-components=1 -C /tmp/ncl-build

WORKDIR /tmp/ncl-build

RUN cp config/LINUX.64.GNU config/LINUX && \
    sed -i 's|-L/usr/X11R6/lib64|-L/usr/lib64|g' config/LINUX && \
    sed -i 's|-I/usr/X11R6/include|-I/usr/include|g' config/LINUX && \
    awk '/case    ppc:/{print "        case    aarch64:"; print "            set model   = $mach"; print "            set arch    = $mach"; print "            set sysincs = LINUX"; print "            set vendor  = IBM"; print "            breaksw"; print ""}1' config/ymake > config/ymake.new && \
    mv config/ymake.new config/ymake && \
    chmod +x config/ymake && \
    printf '#define BuildNCL\n#define EmptySite\n' > config/Site.local && \
    script -q -c "echo n | tcsh Configure" /dev/null && \
    make Everything -j$(nproc) && \
    make install && \
    cd / && rm -rf /tmp/ncl-build

ENV NCARG_ROOT=/usr/local/ncarg
ENV PATH=/usr/local/ncarg/bin:$PATH

WORKDIR /data

