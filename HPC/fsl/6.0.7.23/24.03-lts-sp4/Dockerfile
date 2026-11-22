ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE} AS builder

ARG VERSION=6.0.7.23

RUN dnf install -y findutils && \
    dnf clean all && \
    curl -fSL --connect-timeout 30 --retry 3 --retry-delay 5 \
        -o /tmp/fslinstaller.py \
        https://fsl.fmrib.ox.ac.uk/fsldownloads/fslconda/releases/fslinstaller.py && \
    python3 /tmp/fslinstaller.py -d /usr/local/fsl -V ${VERSION} -c none -r -n && \
    rm -f /tmp/fslinstaller.py

FROM ${BASE}

RUN dnf install -y \
      file && \
    dnf clean all

COPY --from=builder /usr/local/fsl /usr/local/fsl

ENV FSLDIR=/usr/local/fsl

USER root

ENTRYPOINT ["/bin/sh", "-c", ". ${FSLDIR}/etc/fslconf/fsl.sh && exec \"$@\"", "--"]
CMD ["/bin/bash"]