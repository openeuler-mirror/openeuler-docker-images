FROM openeuler/openeuler:22.03-lts
MAINTAINER heguofeng <heguofeng@openeuler.sh>
RUN yum -y update \
    && yum -y install go \
    && yum clean all

ENV GOPATH /go
ENV PATH $GOPATH/bin:$PATH
RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"
WORKDIR $GOPATH
