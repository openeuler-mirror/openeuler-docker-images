FROM openeuler/openeuler:22.09 as basic

RUN dnf install harbor -y

FROM openeuler/openeuler:22.09

COPY entrypoint.sh /usr/bin/entrypoint.sh

COPY --from=basic /usr/bin/harbor-notary-signer /usr/bin/harbor-notary-signer

ENTRYPOINT ["entrypoint.sh"]
