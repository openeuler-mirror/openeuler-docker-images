ARG BASE=openeuler/openeuler:24.03-lts
FROM ${BASE}
ARG VERSION=1.27.2
RUN dnf install -y nginx && dnf clean all
EXPOSE 80
STOPSIGNAL SIGQUIT
CMD ["nginx", "-g", "daemon off;"]
