ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM $BASE
# autopilot: refresh dnf metadata
RUN rm -rf /var/cache/dnf /var/cache/yum \
    && (dnf clean all 2>/dev/null || yum clean all 2>/dev/null || true) \
    && mkdir -p /etc/dnf \
    && (grep -qxF skip_if_unavailable=True /etc/dnf/dnf.conf 2>/dev/null \
        || echo skip_if_unavailable=True >> /etc/dnf/dnf.conf)

ARG VERSION=2610.0
ARG TARGETARCH
ARG BUILD_JOBS=8

RUN yum install -y git cmake gcc g++ autoconf automake ninja-build clang clang-tools-extra lld \
    xcb-util-keysyms-devel xcb-util-image-devel xcb-util-renderutil-devel \
    xcb-util-wm-devel xcb-util-devel xcb-util-cursor-devel xcb-util-xrm-devel \
    libunwind-devel zstd-devel mesa-libGL-devel fontconfig-devel harfbuzz \
    libxkbcommon-devel libX11-devel libxkbcommon-x11-devel wayland-devel \
    xorg-x11-server-devel libatomic && \
    yum clean all

RUN git clone -b ${VERSION} https://github.com/o3de/o3de.git

WORKDIR /o3de
RUN export CC=clang CXX=clang++ && \
    sed -i 's|^\(.*7e94c425039cde14257288fd61dcfb01963e658efbc0ff54f5306b06054700f8\)$|\1 \\\n    --hash=sha256:38a9ef736c01fccdd6600705b09dc574584b89bea478200c5fbf112a6b0d5579|' python/requirements.txt && \
    sed -i '/a2c405445c79c3f5a124573a051062300936b0281fee57637e706453e452746c/a\    --hash=sha256:78618cdbccaa74d3f88d0ad6cb8ac3007f1a6fa5c6f19af64b55ca170bfa1edf \\' python/requirements.txt && \
    grep -q '38a9ef736c01fccdd6600705b09dc574584b89bea478200c5fbf112a6b0d5579' python/requirements.txt && \
    grep -q '78618cdbccaa74d3f88d0ad6cb8ac3007f1a6fa5c6f19af64b55ca170bfa1edf' python/requirements.txt && \
    python/get_python.sh && \
    mkdir -p /opt/o3de-packages && \
    if [ "$TARGETARCH" = "arm64" ]; then \
        PKGFILE=cmake/3rdParty/Platform/Linux/BuiltInPackages_linux_aarch64.cmake && \
        if grep -q 'PACKAGE_NAME qt-5' "$PKGFILE"; then \
            sed -i -E 's|ly_associate_package\(PACKAGE_NAME qt-[^[:space:]]+[[:space:]]+TARGETS Qt[[:space:]]+PACKAGE_HASH [0-9a-f]+\)|ly_associate_package(PACKAGE_NAME qt-6.12.0-rev4-linux-aarch64 TARGETS Qt PACKAGE_HASH 33944912d6ee7602c139bedf7c536663a4dc730e93fdfcadaba1918464cae1af)|' "$PKGFILE" && \
            grep -q 'PACKAGE_NAME qt-6.12.0-rev4-linux-aarch64 TARGETS Qt PACKAGE_HASH 33944912d6ee7602c139bedf7c536663a4dc730e93fdfcadaba1918464cae1af' "$PKGFILE" && \
            ! grep -q 'PACKAGE_NAME qt-5' "$PKGFILE"; \
        fi && \
        if ! grep -q 'TARGETS pyside6' "$PKGFILE"; then \
            PALFILE=Gems/QtForPython/Code/Source/Platform/Linux/PAL_linux.cmake && \
            sed -i 's/^set(PAL_TRAIT_BUILD_QTFORPYTHON_SUPPORTED TRUE)$/set(PAL_TRAIT_BUILD_QTFORPYTHON_SUPPORTED FALSE)/' "$PALFILE" && \
            grep -q '^set(PAL_TRAIT_BUILD_QTFORPYTHON_SUPPORTED FALSE)$' "$PALFILE" && \
            DCCPAL=Gems/AtomLyIntegration/TechnicalArt/DccScriptingInterface/Code/Platform/Linux/PAL_linux.cmake && \
            sed -i 's/^set(PAL_TRAIT_HAS_QTFORPYTHON TRUE)$/set(PAL_TRAIT_HAS_QTFORPYTHON FALSE)/' "$DCCPAL" && \
            grep -q '^set(PAL_TRAIT_HAS_QTFORPYTHON FALSE)$' "$DCCPAL"; \
        fi && \
        MOCPAL=Gems/Atom/RPI/Code/Source/Platform/Linux/PAL_linux.cmake && \
        sed -i 's/^set (PAL_TRAIT_BUILD_ATOM_RPI_MASKED_OCCLUSION_CULLING_SUPPORTED TRUE)$/set (PAL_TRAIT_BUILD_ATOM_RPI_MASKED_OCCLUSION_CULLING_SUPPORTED FALSE)/' "$MOCPAL" && \
        grep -q '^set (PAL_TRAIT_BUILD_ATOM_RPI_MASKED_OCCLUSION_CULLING_SUPPORTED FALSE)$' "$MOCPAL" && \
        MOCTRAIT=Gems/Atom/RPI/Code/Source/Platform/Linux/Atom_RPI_Traits_Linux.h && \
        sed -i 's/^#define AZ_TRAIT_MASKED_OCCLUSION_CULLING_SUPPORTED 1$/#define AZ_TRAIT_MASKED_OCCLUSION_CULLING_SUPPORTED 0/' "$MOCTRAIT" && \
        grep -q '^#define AZ_TRAIT_MASKED_OCCLUSION_CULLING_SUPPORTED 0$' "$MOCTRAIT" && \
        find . -name '*.ui' -exec sed -i -E 's|<set>Qt::[A-Za-z_]+\(([^)]*)\)</set>|<set>\1</set>|g' {} + && \
        ! grep -rqE '<set>Qt::[A-Za-z_]+\(' --include='*.ui' . && \
        find . -type f \( -name '*.h' -o -name '*.cpp' -o -name '*.hpp' \) \
            -exec sed -i -E 's/\bQ_ENUMS\(/Q_ENUM(/g; s/\bQ_FLAGS\(/Q_FLAG(/g' {} + && \
        ! grep -rqE '\bQ_(ENUMS|FLAGS)\(' . --include='*.h' --include='*.cpp' --include='*.hpp' && \
        FCM=Code/Editor/Util/FileChangeMonitor.cpp && \
        sed -i 's/std::move(dir\.entryInfoList(QDir::Files|QDir::Dirs|QDir::NoDotAndDotDot))/dir.entryInfoList(QDir::Files|QDir::Dirs|QDir::NoDotAndDotDot)/' "$FCM" && \
        grep -q 'm_entries.insert(sItem, dir.entryInfoList(' "$FCM" && \
        ! grep -q 'std::move(dir.entryInfoList(' "$FCM"; \
    fi && \
    cmake -B build/linux -S . -G "Ninja Multi-Config" \
        -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ \
        -DLY_3RDPARTY_PATH=/opt/o3de-packages && \
    cmake --build build/linux --target Editor --config release -j${BUILD_JOBS} && \
    test -x build/linux/bin/release/Editor && \
    ! ldd build/linux/bin/release/Editor | grep -q 'not found' && \
    ldd build/linux/bin/release/Editor | grep -q 'libQt6Core' && \
    printf 'o3de-image-probe\n' > /tmp/o3de-probe.txt && \
    test "$(scripts/o3de.sh sha256 --file-path /tmp/o3de-probe.txt 2>/dev/null | grep -Eo '[0-9a-f]{64}' | tail -n1)" = "$(sha256sum /tmp/o3de-probe.txt | cut -d' ' -f1)" && \
    rm -f /tmp/o3de-probe.txt