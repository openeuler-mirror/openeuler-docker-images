ARG BASE=openeuler/openeuler:24.03-lts
FROM ${BASE}
ARG TARGETARCH
ARG VERSION=2.47.0
RUN dnf install -y git && dnf clean all
EXPOSE 80
STOPSIGNAL SIGQUIT
CMD ["tail", "-f", "/dev/null"]
