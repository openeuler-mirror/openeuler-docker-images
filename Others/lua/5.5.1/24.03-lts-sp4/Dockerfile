ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE} AS builder

ARG VERSION=5.5.1

RUN dnf install -y \
      gcc make \
      && dnf clean all \
      && rm -rf /var/cache/dnf

WORKDIR /usr/src/lua

RUN curl -fSL --connect-timeout 30 --retry 3 \
      -o lua.tar.gz \
      https://github.com/lua/lua/archive/refs/tags/v${VERSION}.tar.gz && \
    tar -zxf lua.tar.gz --strip-components=1 && \
    rm -f lua.tar.gz

RUN make -j$(nproc) && \
    install -d /usr/local/lib /usr/local/include && \
    install -m 0755 lua /usr/local/bin/lua && \
    install -m 0644 liblua.a /usr/local/lib/liblua.a && \
    install -m 0644 lua.h luaconf.h lualib.h lauxlib.h /usr/local/include/

FROM ${BASE}

COPY --from=builder /usr/local/bin/lua /usr/local/bin/lua
COPY --from=builder /usr/local/lib/liblua.a /usr/local/lib/liblua.a
COPY --from=builder /usr/local/include/lua.h /usr/local/include/luaconf.h /usr/local/include/lualib.h /usr/local/include/lauxlib.h /usr/local/include/

USER root

CMD ["lua"]
