# syntax=docker/dockerfile:1
# OpenCV built from source on openEuler.
FROM openeuler/openeuler:24.03-lts-sp4
# autopilot: refresh dnf metadata
RUN rm -rf /var/cache/dnf /var/cache/yum \
    && (dnf clean all 2>/dev/null || yum clean all 2>/dev/null || true) \
    && mkdir -p /etc/dnf \
    && (grep -qxF skip_if_unavailable=True /etc/dnf/dnf.conf 2>/dev/null \
        || echo skip_if_unavailable=True >> /etc/dnf/dnf.conf)

# Harden git against the flaky CI network (force HTTP/1.1, large post buffer).
ENV GIT_CONFIG_COUNT=2 \
    GIT_CONFIG_KEY_0=http.version \
    GIT_CONFIG_VALUE_0=HTTP/1.1 \
    GIT_CONFIG_KEY_1=http.postBuffer \
    GIT_CONFIG_VALUE_1=524288000

ARG VERSION=5.1.0

LABEL author="openEuler CloudNative SIG" description="OpenCV built from source on openEuler 24.03-LTS-SP4"

# Build dependencies
RUN dnf install -y git gcc gcc-c++ make cmake pkgconf \
        python3 python3-devel python3-numpy \
        libjpeg-turbo-devel libpng-devel libtiff-devel && \
    dnf clean all

# Clone OpenCV at the release tag
RUN git clone --depth 1 --branch ${VERSION} https://github.com/opencv/opencv.git /tmp/opencv

# Configure and build with Python 3 bindings, install to /usr/local.
RUN cmake -S /tmp/opencv -B /tmp/opencv/build \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_INSTALL_PREFIX=/usr/local \
        -DBUILD_opencv_world=OFF \
        -DBUILD_EXAMPLES=OFF \
        -DBUILD_TESTS=OFF \
        -DBUILD_PERF_TESTS=OFF \
        -DBUILD_LIST=core,imgproc,imgcodecs,videoio,dnn,python3 \
        -DBUILD_opencv_python3=ON \
        -DOPENCV_ENABLE_NONFREE=OFF && \
    cmake --build /tmp/opencv/build --target install --parallel $(nproc) && \
    /usr/local/bin/opencv_version && \
    echo "/usr/local/lib64" > /etc/ld.so.conf.d/opencv.conf && \
    ldconfig && \
    python3 -c "import cv2; print('cv2', cv2.__version__)" && \
    rm -rf /tmp/opencv

CMD ["/bin/bash"]
