ARG BASE=openeuler/cann:8.0.RC1-oe2203sp4
FROM ${BASE}

# Arguments
ARG VERSION=2.3.0rc1

# Change the default shell
SHELL [ "/bin/bash", "-c" ]

# Install mindspore
RUN pip install --no-cache-dir \
        mindspore==${VERSION}