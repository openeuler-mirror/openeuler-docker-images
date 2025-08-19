ARG BASE=openeuler/openeuler:24.03-lts-sp2
FROM ${BASE} as builder
ARG VERSION=7.18

RUN yum install -y gcc-c++ wget  && \
    yum clean all

WORKDIR /mongoose

COPY main.c .

RUN wget https://github.com/cesanta/mongoose/archive/refs/tags/7.18.tar.gz \
    && tar -zxvf 7.18.tar.gz -C /mongoose --strip-components=1 \
    && gcc main.c mongoose.c -o server -lpthread

FROM ${BASE}

WORKDIR /mongoose

COPY --from=builder /mongoose/server /mongoose/server

CMD ["./server"]
