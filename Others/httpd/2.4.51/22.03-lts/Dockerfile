FROM openeuler/openeuler:22.03-lts
WORKDIR /etc/httpd
RUN yum -y update \
    && yum -y install httpd \
    && yum clean all \
    && httpd -v

STOPSIGNAL SIGWINCH
COPY httpd-foreground /usr/local/bin
EXPOSE 80
CMD ["httpd-foreground"]
