ARG BASE=openeuler/openeuler:24.03-lts-sp4

FROM ${BASE} AS builder
ARG VERSION=3.9.10
ARG ERLANG_VERSION=24.3.4.10
ARG ELIXIR_VERSION=1.12.3

ENV LANG=C.UTF-8

RUN dnf install -y \
        git gcc gcc-c++ make cmake \
        openssl-devel ncurses-devel \
        python3-simplejson \
        libxslt xmlto \
        zip unzip rsync \
        xz curl && \
    dnf clean all

RUN ln -s /usr/bin/python3 /usr/bin/python

RUN curl -fSL -o /tmp/otp.tar.gz https://github.com/erlang/otp/releases/download/OTP-${ERLANG_VERSION}/otp_src_${ERLANG_VERSION}.tar.gz && \
    tar -xzf /tmp/otp.tar.gz -C /tmp && \
    cd /tmp/otp_src_${ERLANG_VERSION} && \
    ./configure --prefix=/opt/erlang && \
    make -j$(nproc) && \
    make install && \
    rm -rf /tmp/otp*

ENV PATH=/opt/erlang/bin:$PATH

RUN git clone --depth 1 --branch v${ELIXIR_VERSION} https://github.com/elixir-lang/elixir.git /tmp/elixir && \
    cd /tmp/elixir && \
    make compile && \
    make install PREFIX=/opt/elixir && \
    rm -rf /tmp/elixir

ENV PATH=/opt/elixir/bin:$PATH

RUN git clone --depth 1 --branch v${VERSION} https://github.com/rabbitmq/rabbitmq-server.git /tmp/rabbitmq && \
    cd /tmp/rabbitmq && \
    mix local.hex --force && \
    mix local.rebar --force && \
    make && \
    make package-generic-unix && \
    mkdir -p /tmp/output && \
    tar -xf /tmp/rabbitmq/PACKAGES/rabbitmq-server-generic-unix-*.tar.xz -C /tmp/output --strip-components=1


FROM ${BASE}
ARG VERSION=3.9.10

RUN dnf install -y \
        hostname \
        shadow && \
    dnf clean all && \
    groupadd -r rabbitmq && \
    useradd -r -g rabbitmq -d /var/lib/rabbitmq -s /sbin/nologin rabbitmq

COPY --from=builder /opt/erlang /opt/erlang
ENV PATH=/opt/erlang/bin:$PATH

COPY --from=builder /tmp/output /usr/local/lib/rabbitmq
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
