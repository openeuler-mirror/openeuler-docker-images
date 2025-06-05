ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM $BASE

ARG VERSION=2.6.0-latest

RUN yum install -y make gcc gcc-c++ patch git java-1.8.0-openjdk-devel java-11-openjdk-devel wget unzip \
    libcurl-devel libnl3-devel python3-devel libunwind-devel \
    zlib-devel openssl-devel uuid-devel libuuid-devel python3-wheel && \
    yum clean all
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk

WORKDIR /opt
COPY grpc.patch /
COPY client.patch /
COPY unix.patch /
RUN wget https://github.com/bazelbuild/bazel/releases/download/0.17.2/bazel-0.17.2-dist.zip && \
    unzip bazel-0.17.2-dist.zip -d bazel-0.17.2 && \
    cd /opt/bazel-0.17.2 && \
    mv /grpc.patch /client.patch /unix.patch ./ && \
    patch -p1 < grpc.patch && \
    patch -p1 < client.patch && \
    patch -p1 < unix.patch && \
    ln -s /usr/bin/python3 /usr/bin/python && \
    ./compile.sh && \
    ln -s /opt/bazel-0.17.2/output/bazel /usr/local/bin/bazel

RUN git clone https://github.com/albertito/libfiu.git && \
    cd libfiu && \
    git checkout -b libfiu-1.00 1.00 && \
    make -j$nproc && make install

RUN git clone -b arm64 https://github.com/opencurve/curve.git && \
    cd curve/ && \
    git checkout 1a6ad49ba7d11b5b9dcb5c6beb537ca4b9e5044b && \
    git format-patch -p -o .. -1 b71f94469597492b4fcef590cb11e729a003ebb9 && \
    git apply --include=thirdparties/brpc/* --whitespace=fix -p1 ../0001-fix-build-add-a-patch-to-support-build-on-GCC-11.patch

COPY WORKSPACE.patch /
RUN cd /opt/curve && \
    mv /WORKSPACE.patch ./ && \
    git apply WORKSPACE.patch

RUN cd /opt/curve && \
    bash mk-tar.sh