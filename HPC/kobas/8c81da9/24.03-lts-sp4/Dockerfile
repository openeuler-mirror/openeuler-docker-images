ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE}

# KOBAS has no release tags on GitHub, so the build is pinned to a fixed
# commit and the commit is used as the version of this image.
ARG VERSION=8c81da9

RUN dnf install -y git python3 python3-pip && \
    dnf clean all && rm -rf /var/cache/dnf

WORKDIR /opt
RUN git clone https://github.com/xmao/kobas && \
    cd kobas && \
    git checkout ${VERSION} && \
    rm -rf .git && \
    python3 -m pip install --no-cache-dir .

RUN kobas --help && \
    kobas annotate -h && \
    kobas pathfind -h && \
    kobas init -h

WORKDIR /workspace
CMD ["/bin/bash"]
