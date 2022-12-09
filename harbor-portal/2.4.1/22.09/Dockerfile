FROM openeuler/openeuler:22.09 as basic

RUN dnf install harbor -y

FROM openeuler/openeuler:22.09

RUN dnf install nginx -y

COPY --from=basic /usr/share/harbor/html /usr/share/nginx/html

VOLUME /var/cache/nginx /var/log/nginx /run

STOPSIGNAL SIGQUIT

CMD ["nginx", "-g", "daemon off;"]
