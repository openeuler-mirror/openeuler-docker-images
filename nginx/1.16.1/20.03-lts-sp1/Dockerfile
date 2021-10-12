FROM openeuler/openeuler:20.03-lts-sp1
MAINTAINER gaohechao <suisuisuisuixin@gmail.com>
RUN dnf -y update \
    && dnf -y install nginx \
    && dnf clean all
ENTRYPOINT ["nginx", "-g", "daemon off;"]
