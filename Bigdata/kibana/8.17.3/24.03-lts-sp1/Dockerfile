ARG BASE=openeuler/openeuler:24.03-lts-sp1
FROM ${BASE} AS builder

ARG TARGETARCH
ARG BUILDARCH
ARG VERSION=8.17.3
ARG TINI_VERSION=0.19.0

RUN if [ "$TARGETARCH" = "amd64" ]; then \
        BUILDARCH="x86_64"; \
    elif [ "$TARGETARCH" = "arm64" ]; then \
        BUILDARCH="aarch64"; \
    fi; \
    curl --retry 10 -s -L --output /tmp/kibana.tar.gz https://artifacts.elastic.co/downloads/kibana/kibana-${VERSION}-linux-${BUILDARCH}.tar.gz
RUN mkdir /usr/share/kibana

WORKDIR /usr/share/kibana
RUN tar -zxf /tmp/kibana.tar.gz --strip-components=1
RUN chmod -R g=u /usr/share/kibana
RUN curl --retry 10 -S -L -O https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini-${TARGETARCH} ; \
    curl --retry 10 -S -L -O https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini-${TARGETARCH}.sha256sum ; \
    sha256sum -c tini-${TARGETARCH}.sha256sum ; \
    rm tini-${TARGETARCH}.sha256sum ; \
    mv tini-${TARGETARCH} /bin/tini ; \
    chmod 0555 /bin/tini
RUN mkdir -p /usr/share/fonts/local && \
  curl --retry 10 -S -L -o /usr/share/fonts/local/NotoSansCJK-Regular.ttc https://github.com/googlefonts/noto-cjk/raw/NotoSansV2.001/NotoSansCJK-Regular.ttc && \
  echo "5dcd1c336cc9344cb77c03a0cd8982ca8a7dc97d620fd6c9c434e02dcb1ceeb3  /usr/share/fonts/local/NotoSansCJK-Regular.ttc" | sha256sum -c -


FROM ${BASE}
EXPOSE 5601

RUN yum install -y shadow findutils fontconfig liberation-fonts nss ca-certificates

COPY --from=builder --chown=1000:0 /usr/share/kibana /usr/share/kibana
COPY --from=builder --chown=0:0 /bin/tini /bin/tini
COPY --from=builder --chown=0:0 /usr/share/fonts/local/NotoSansCJK-Regular.ttc /usr/share/fonts/local/NotoSansCJK-Regular.ttc
RUN fc-cache -v

WORKDIR /usr/share/kibana
RUN ln -s /usr/share/kibana /opt/kibana

ENV ELASTIC_CONTAINER true
ENV PATH=/usr/share/kibana/bin:$PATH

COPY --chown=1000:0 config/kibana.yml /usr/share/kibana/config/kibana.yml
COPY kibana-docker /usr/local/bin/
RUN chmod g+ws /usr/share/kibana && \
    chmod 0555 /usr/local/bin/kibana-docker
RUN find /usr/share/kibana -gid 0 -and -not -perm /g+w -exec chmod g+w {} \; && \
    find / -xdev -perm -4000 -exec chmod u-s {} + && \
    groupadd -g 1000 kibana && \
    useradd -u 1000 -g 1000 -G 0 -d /usr/share/kibana -M kibana && \
    yum remove -y shadow findutils && yum clean all


ENTRYPOINT ["/bin/tini", "--"]
CMD ["/usr/local/bin/kibana-docker"]
USER 1000