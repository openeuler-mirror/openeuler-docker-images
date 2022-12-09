FROM openeuler/openeuler:22.09 as basic

RUN dnf install harbor -y

FROM openeuler/openeuler:22.09

COPY entrypoint.sh /usr/bin/entrypoint.sh

COPY --from=basic /usr/bin/harbor-chartmuseum /usr/bin/harbor-chartmuseum

VOLUME ["/chart_storage"]

ENTRYPOINT ["entrypoint.sh"]
