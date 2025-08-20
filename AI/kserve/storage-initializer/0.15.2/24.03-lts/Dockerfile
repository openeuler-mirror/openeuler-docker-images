# SPDX-License-Identifier: Apache-2.0

ARG PYTHON_VERSION=3.11.13
ARG BASE_IMAGE=openeuler/python:${PYTHON_VERSION}-oe2403lts
ARG VENV_PATH=/prod_venv
ARG VERSION=v0.15.2

FROM ${BASE_IMAGE} AS builder

ARG VERSION

# Install Poetry
ARG POETRY_HOME=/opt/poetry
ARG POETRY_VERSION=1.8.3

# Required for building packages for arm64 arch
RUN yum update -y && \
    yum install -y \
        python3-devel \
        gcc g++ make cmake \
        git \
        shadow && \
    yum clean all && \
    rm -rf /var/cache/yum

RUN python3 -m venv ${POETRY_HOME} && ${POETRY_HOME}/bin/pip install poetry==${POETRY_VERSION}
ENV PATH="$PATH:${POETRY_HOME}/bin"

# Activate virtual env
ARG VENV_PATH
ENV VIRTUAL_ENV=${VENV_PATH}
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

ARG KSERVE_REPO=https://github.com/kserve/kserve.git
RUN git clone -b $VERSION $KSERVE_REPO kserve_repo && \
    cp -r kserve_repo/python/kserve kserve && \
    cp -r kserve_repo/python/pyproject.toml pyproject.toml && \
    cp -r kserve_repo/python/third_party/pip-licenses.py pip-licenses.py && \
    cp -r kserve_repo/python/storage-initializer storage-initializer && \
    rm -fr kserve_repo

RUN cd kserve && poetry install --no-root --no-interaction --no-cache --extras "storage"
RUN cd kserve && poetry install --no-interaction --no-cache --extras "storage"

ARG DEBIAN_FRONTEND=noninteractive

RUN yum update -y && \
    yum install -y \
        gcc \
        krb5-devel && \
    yum clean all && \
    rm -rf /var/cache/yum

RUN pip install --no-cache-dir krbcontext==0.10 hdfs~=2.6.0 requests-kerberos==0.14.0


# TODO: Remove this when upgrading to python 3.11+
RUN pip install --no-cache-dir tomli
RUN mkdir -p third_party/library && python3 pip-licenses.py

FROM ${BASE_IMAGE} AS prod

# Activate virtual env
ARG VENV_PATH
ENV VIRTUAL_ENV=${VENV_PATH}
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

RUN yum update -y && \
    yum install -y \
        shadow && \
    yum clean all && \
    rm -rf /var/cache/yum

RUN useradd kserve -m -u 1000 -d /home/kserve

COPY --from=builder --chown=kserve:kserve third_party third_party
COPY --from=builder --chown=kserve:kserve $VIRTUAL_ENV $VIRTUAL_ENV
COPY --from=builder kserve kserve
COPY --from=builder storage-initializer /storage-initializer

RUN chmod +x /storage-initializer/scripts/initializer-entrypoint
RUN mkdir /work
WORKDIR /work

# Set a writable /mnt folder to avoid permission issue on Huggingface download. See https://huggingface.co/docs/hub/spaces-sdks-docker#permissions
RUN chown -R kserve:kserve /mnt
USER 1000
ENTRYPOINT ["/storage-initializer/scripts/initializer-entrypoint"]