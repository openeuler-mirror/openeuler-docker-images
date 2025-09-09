ARG BASE=openeuler/openeuler:24.03-lts-sp2
FROM ${BASE}
ARG VERSION=12.1.1

RUN dnf update -y \
    && dnf install -y wget git java-17-openjdk shadow-utils \
    && dnf clean all \
    && rm -rf /var/cache/dnf/*

ENV JETTY_HOME /usr/local/jetty
ENV JETTY_BASE /var/lib/jetty
ENV TMPDIR /tmp/jetty
ENV PATH ${JETTY_HOME}/bin:$PATH

RUN mkdir -p "$JETTY_HOME" $TMPDIR; \
	cd $JETTY_HOME ; \
	curl -SL https://repo1.maven.org/maven2/org/eclipse/jetty/jetty-home/$VERSION/jetty-home-$VERSION.tar.gz -o jetty.tar.gz ; \
	tar -xvf jetty.tar.gz --strip-components=1 ; \
	sed -i '/jetty-logging/d' etc/jetty.conf ; \
	mkdir -p "$JETTY_BASE" ; \
	cd $JETTY_BASE ; \
	java -jar "$JETTY_HOME/start.jar" --create-startd --add-to-start="server,http,ext,resources,deployment-scanner,ee8-deploy,ee8-webapp" ; \
	groupadd -r jetty && useradd -r -g jetty jetty ; \
	chown -R jetty:jetty "$JETTY_HOME" "$JETTY_BASE" "$TMPDIR" ; \
	usermod -d $JETTY_BASE jetty ; \
	rm -rf /tmp/hsperfdata_root ; \
	rm -fr $JETTY_HOME/jetty.tar.gz* ; \
	java -jar "$JETTY_HOME/start.jar" --list-config


WORKDIR $JETTY_BASE

COPY docker-entrypoint.sh generate-jetty-start.sh /

RUN chmod +x /docker-entrypoint.sh /generate-jetty-start.sh

USER jetty

EXPOSE 8080

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["java","-jar","/usr/local/jetty/start.jar"]
