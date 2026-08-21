ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE}

ARG VERSION=4.3.5_CE_BP3
ARG TARGETARCH

RUN dnf install -y \
      curl wget \
      ncurses-compat-libs \
      libaio \
      numactl-libs \
      hostname && \
    dnf clean all

RUN ARCH=$([ "$TARGETARCH" = "amd64" ] && echo "x86_64" || echo "aarch64") && \
    API_URL="https://api.github.com/repos/oceanbase/oceanbase/releases/tags/v${VERSION}" && \
    CE_RPM=$(curl -sL ${API_URL} | grep -oP '"name":\s*"\K[^"]*oceanbase-ce-[0-9][^"]*\.el8\.'"${ARCH}"'\.rpm' | head -1) && \
    LIBS_RPM=$(curl -sL ${API_URL} | grep -oP '"name":\s*"\K[^"]*oceanbase-ce-libs-[0-9][^"]*\.el8\.'"${ARCH}"'\.rpm' | head -1) && \
    DOWNLOAD_URL="https://github.com/oceanbase/oceanbase/releases/download/v${VERSION}" && \
    curl -fSL -o oceanbase-ce.rpm "${DOWNLOAD_URL}/${CE_RPM}" && \
    curl -fSL -o oceanbase-ce-libs.rpm "${DOWNLOAD_URL}/${LIBS_RPM}"

RUN dnf install -y *.rpm && rm -f *.rpm

EXPOSE 2881 2882

CMD ["/bin/bash", "-c", "bash /home/admin/oceanbase/profile/oceanbase-service.sh start && tail -f /dev/null"]
