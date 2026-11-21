ARG BASE=openeuler/openeuler:24.03-lts-sp4
FROM ${BASE} as builder
# autopilot: refresh dnf metadata
RUN rm -rf /var/cache/dnf /var/cache/yum \
    && (dnf clean all 2>/dev/null || yum clean all 2>/dev/null || true) \
    && mkdir -p /etc/dnf \
    && (grep -qxF skip_if_unavailable=True /etc/dnf/dnf.conf 2>/dev/null \
        || echo skip_if_unavailable=True >> /etc/dnf/dnf.conf)
ARG VERSION=7.24

RUN yum install -y gcc-c++ wget  && \
    yum clean all

WORKDIR /mongoose

RUN wget https://github.com/cesanta/mongoose/archive/refs/tags/${VERSION}.tar.gz \
    && tar -zxvf ${VERSION}.tar.gz -C /mongoose --strip-components=1

RUN cat > server.c <<'EOF'
#include "mongoose.h"

static void ev_handler(struct mg_connection *c, int ev, void *ev_data) {
  if (ev == MG_EV_HTTP_MSG) {
    struct mg_http_message *hm = (struct mg_http_message *) ev_data;
    if (mg_strcmp(hm->uri, mg_str("/")) == 0) {
      mg_http_reply(c, 200, NULL, "Mongoose v." MG_VERSION "\n");
    } else {
      struct mg_http_serve_opts opts = { .root_dir = "./web_root/" };
      mg_http_serve_dir(c, hm, &opts);
    }
    c->is_draining = 1;
  }
}

int main(void) {
  struct mg_mgr mgr;
  mg_mgr_init(&mgr);
  mg_http_listen(&mgr, "http://0.0.0.0:8000", ev_handler, NULL);
  for (;;) mg_mgr_poll(&mgr, 1000);
  return 0;
}
EOF

RUN gcc server.c mongoose.c -o server -lpthread

FROM ${BASE}
# autopilot: refresh dnf metadata
RUN rm -rf /var/cache/dnf /var/cache/yum \
    && (dnf clean all 2>/dev/null || yum clean all 2>/dev/null || true) \
    && mkdir -p /etc/dnf \
    && (grep -qxF skip_if_unavailable=True /etc/dnf/dnf.conf 2>/dev/null \
        || echo skip_if_unavailable=True >> /etc/dnf/dnf.conf)

WORKDIR /mongoose

COPY --from=builder /mongoose/server /mongoose/server

CMD ["./server"]
