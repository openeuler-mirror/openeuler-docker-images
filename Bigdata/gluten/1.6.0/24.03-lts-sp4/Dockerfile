ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE} AS base

ARG VERSION=1.6.0
ARG GLU_REPO="https://github.com/apache/gluten.git"

ENV LANG=C.UTF-8 \
	GLU_HOME=/opt/gluten \
	PATH=/opt/gluten/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

RUN dnf -y update && \
	dnf -y install --nodocs --setopt=install_weak_deps=False \
		git wget curl tar gzip bzip2 xz make cmake gcc gcc-c++ which \
		python3 python3-pip unzip unzip java-17-openjdk-devel maven && \
	dnf clean all && rm -rf /var/cache/dnf

WORKDIR /opt

RUN git clone --depth 1 --branch v${VERSION} ${GLU_REPO} ${GLU_HOME}

WORKDIR ${GLU_HOME}

RUN if [ -x ./build/mvn ]; then \
		./build/mvn -DskipTests -T1C package; \
	else \
		mvn -DskipTests -T1C package; \
	fi

RUN mkdir -p /opt/gluten/dist/jars /opt/gluten/dist/lib && \
    find . -type f -name "*.jar" -exec cp -u {} /opt/gluten/dist/jars/ \; || true && \
    find . -type f \( -name "*.so" -o -name "*.a" -o -name "*.dll" \) -exec cp -u {} /opt/gluten/dist/lib/ \; || true

FROM ${BASE} AS runtime
ARG VERSION=1.6.0

ENV GLU_HOME=/opt/gluten \
	PATH=/opt/gluten/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

RUN dnf -y install --nodocs --setopt=install_weak_deps=False \
		java-17-openjdk-headless && dnf clean all && rm -rf /var/cache/dnf

COPY --from=base /opt/gluten ${GLU_HOME}

WORKDIR ${GLU_HOME}

LABEL org.opencontainers.image.title="gluten" \
	org.opencontainers.image.version="${VERSION}"

