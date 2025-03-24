ARG KUBE_BINARY

ARG KUBE_GIT_MAJOR=1

ARG KUBE_GIT_MINOR=20

ARG KUBE_GIT_VERSION=1.20.2

FROM hub.oepkgs.net/openeuler/openeuler:21.09 AS build

ARG KUBE_BINARY

ARG KUBE_GIT_MAJOR

ARG KUBE_GIT_MINOR

ARG KUBE_GIT_VERSION

RUN /usr/bin/yum install golang-1.15.7-2.oe1 rsync make --disablerepo EPOL -y

WORKDIR /root/go/src/k8s.io

RUN /usr/bin/git clone -b openEuler-21.09 --depth=1 https://gitee.com/src-openeuler/kubernetes.git

WORKDIR /root/go/src/k8s.io/kubernetes

RUN /usr/bin/tar -xzf v${KUBE_GIT_VERSION}.tar.gz

WORKDIR /root/go/src/k8s.io/kubernetes/kubernetes-${KUBE_GIT_VERSION}

RUN /usr/bin/make generated_files

WORKDIR /root/go/src/k8s.io/kubernetes/kubernetes-${KUBE_GIT_VERSION}/cmd/${KUBE_BINARY}

RUN /usr/bin/go build -x -ldflags='-X k8s.io/component-base/version.gitVersion='v${KUBE_GIT_VERSION}'-openEuler -X k8s.io/client-go/pkg/version.gitVersion='v${KUBE_GIT_VERSION}'-openEuler -X k8s.io/component-base/version.gitMajor='${KUBE_GIT_MAJOR}' -X k8s.io/client-go/pkg/version.gitMajor='${KUBE_GIT_MAJOR}' -X k8s.io/component-base/version.gitMinor='${KUBE_GIT_MINOR}' -X k8s.io/client-go/pkg/version.gitMinor='${KUBE_GIT_MINOR}''

FROM hub.oepkgs.net/openeuler/openeuler:21.09

LABEL org.opencontainers.image.authors="liuming <abuxliu@gmail.com>"

ARG KUBE_BINARY

ARG KUBE_GIT_VERSION

COPY --from=build /root/go/src/k8s.io/kubernetes/kubernetes-${KUBE_GIT_VERSION}/cmd/${KUBE_BINARY}/${KUBE_BINARY} /usr/local/bin/${KUBE_BINARY}

RUN /usr/bin/rm -r /etc/ssl/certs && \
    /usr/bin/yum install iptables --disablerepo EPOL -y
