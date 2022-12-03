FROM openeuler/openeuler:22.09 as basic

RUN dnf install harbor -y

FROM openeuler/openeuler:22.09

COPY entrypoint.sh /usr/bin/entrypoint.sh

COPY --from=basic /usr/bin/harbor-registryctl /usr/bin/harbor-registryctl

VOLUME ["/var/lib/registry"]

ENTRYPOINT ["entrypoint.sh"]
