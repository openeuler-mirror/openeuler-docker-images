ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE}
# autopilot: refresh dnf metadata
RUN rm -rf /var/cache/dnf /var/cache/yum \
    && (dnf clean all 2>/dev/null || yum clean all 2>/dev/null || true) \
    && mkdir -p /etc/dnf \
    && (grep -qxF skip_if_unavailable=True /etc/dnf/dnf.conf 2>/dev/null \
        || echo skip_if_unavailable=True >> /etc/dnf/dnf.conf)
ARG VERSION=20261113
ARG THIRD_PARTY_VERSION=version-14

WORKDIR /opt
RUN yum install -y wget m4 flex clang make gcc g++ cmake openmpi-devel zlib-devel texinfo \
    libXext-devel libGLU-devel libXt-devel libXrender-devel libXinerama-devel \
    libpng-devel libXrandr-devel libXi-devel libXft-devel libjpeg-turbo-devel \
    libXcursor-devel readline-devel ncurses-devel mpfr-devel gmp-devel libmpc*

RUN wget https://github.com/OpenFOAM/OpenFOAM-dev/archive/refs/tags/${VERSION}.tar.gz -O OpenFOAM-dev.tar.gz && \
    wget https://github.com/OpenFOAM/ThirdParty-dev/archive/refs/tags/${THIRD_PARTY_VERSION}.tar.gz -O ThirdParty-dev.tar.gz && \
    tar -xzf OpenFOAM-dev.tar.gz && \
    tar -xzf ThirdParty-dev.tar.gz && \
    rm -rf OpenFOAM-dev.tar.gz ThirdParty-dev.tar.gz && \
    mv OpenFOAM-dev-${VERSION} OpenFOAM-v${VERSION} && \
    mv ThirdParty-dev-${THIRD_PARTY_VERSION} ThirdParty-v${VERSION} && \
    sed -i "s/^export WM_PROJECT_VERSION=dev$/export WM_PROJECT_VERSION=v${VERSION}/" OpenFOAM-v${VERSION}/etc/bashrc && \
    cd OpenFOAM-v${VERSION} && \
    source etc/bashrc && \
    ./Allwmake -j -k -s -q

WORKDIR /opt/OpenFOAM-v${VERSION}
ENV OMPI_ALLOW_RUN_AS_ROOT=1
ENV OMPI_ALLOW_RUN_AS_ROOT_CONFIRM=1

ENTRYPOINT ["/bin/bash", "-c", "source etc/bashrc && exec /bin/bash"]
