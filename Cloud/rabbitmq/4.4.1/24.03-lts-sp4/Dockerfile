ARG BASE=openeuler/openeuler:24.03-lts-sp4

FROM ${BASE}
# autopilot: refresh dnf metadata
RUN rm -rf /var/cache/dnf /var/cache/yum \
    && (dnf clean all 2>/dev/null || yum clean all 2>/dev/null || true) \
    && mkdir -p /etc/dnf \
    && (grep -qxF skip_if_unavailable=True /etc/dnf/dnf.conf 2>/dev/null \
        || echo skip_if_unavailable=True >> /etc/dnf/dnf.conf)
ARG VERSION=4.4.1
ARG ERLANG_VERSION=27.3.4.19

RUN dnf install -y \
        xz hostname shadow && \
    dnf clean all

RUN set -eux; \
    ARCH=$(uname -m); \
    case "$ARCH" in \
      x86_64|amd64) RPMARCH=x86_64 ;; \
      aarch64|arm64) RPMARCH=aarch64 ;; \
      *) echo "Unsupported architecture: $ARCH" >&2; exit 1 ;; \
    esac; \
    curl -fSL -o /tmp/erlang.rpm "https://github.com/rabbitmq/erlang-rpm/releases/download/v${ERLANG_VERSION}/erlang-${ERLANG_VERSION}-1.el9.${RPMARCH}.rpm"; \
    dnf install -y /tmp/erlang.rpm; \
    rm -f /tmp/erlang.rpm

RUN mkdir -p /usr/local/lib/rabbitmq && \
    curl -fSL -o /tmp/rabbitmq.tar.xz "https://github.com/rabbitmq/rabbitmq-server/releases/download/v${VERSION}/rabbitmq-server-generic-unix-${VERSION}.tar.xz" && \
    tar -xJf /tmp/rabbitmq.tar.xz -C /usr/local/lib/rabbitmq --strip-components=1 && \
    rm -f /tmp/rabbitmq.tar.xz

RUN groupadd -r rabbitmq && \
    useradd -r -g rabbitmq -d /var/lib/rabbitmq -s /sbin/nologin rabbitmq

ENV RABBITMQ_HOME=/usr/local/lib/rabbitmq
ENV PATH=$RABBITMQ_HOME/sbin:$PATH

ENV RABBITMQ_DATA_DIR=/var/lib/rabbitmq
ENV HOME=$RABBITMQ_DATA_DIR
RUN mkdir -p $RABBITMQ_DATA_DIR && \
    chown rabbitmq:rabbitmq $RABBITMQ_DATA_DIR
VOLUME $RABBITMQ_DATA_DIR

ENV LANG=C.UTF-8 LANGUAGE=C.UTF-8 LC_ALL=C.UTF-8

RUN rabbitmq-plugins enable --offline rabbitmq_prometheus && \
    mkdir -p /etc/rabbitmq/conf.d && \
    echo 'management_agent.disable_metrics_collector = true' > /etc/rabbitmq/conf.d/management_agent.disable_metrics_collector.conf && \
    chown rabbitmq:rabbitmq /etc/rabbitmq -R

EXPOSE 5672 15672
CMD ["rabbitmq-server"]
