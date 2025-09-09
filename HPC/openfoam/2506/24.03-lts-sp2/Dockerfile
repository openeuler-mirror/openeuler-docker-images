ARG BASE=openeuler/openeuler:24.03-lts-sp2
FROM ${BASE}
ARG VERSION=2506

WORKDIR /opt
RUN yum install -y wget m4 flex clang make gcc g++ cmake openmpi-devel zlib-devel texinfo \
    libXext-devel libGLU-devel libXt-devel libXrender-devel libXinerama-devel \
    libpng-devel libXrandr-devel libXi-devel libXft-devel libjpeg-turbo-devel \
    libXcursor-devel readline-devel ncurses-devel mpfr-devel gmp-devel libmpc*

RUN wget https://sourceforge.net/projects/openfoam/files/v${VERSION}/ThirdParty-v${VERSION}.tgz && \
    wget https://sourceforge.net/projects/openfoam/files/v${VERSION}/OpenFOAM-v${VERSION}.tgz && \
    tar -xvf ThirdParty-v${VERSION}.tgz && \
    tar -xvf OpenFOAM-v${VERSION}.tgz && \
    cd OpenFOAM-v${VERSION} && \
    source etc/bashrc && \
    ./Allwmake -j -k -s -q && \
    rm -rf ThirdParty-v${VERSION}.tgz && \
    rm -rf OpenFOAM-v${VERSION}.tgz

WORKDIR /opt/OpenFOAM-v${VERSION}
ENV OMPI_ALLOW_RUN_AS_ROOT=1
ENV OMPI_ALLOW_RUN_AS_ROOT_CONFIRM=1

ENTRYPOINT ["/bin/bash", "-c", "source etc/bashrc && exec /bin/bash"]
