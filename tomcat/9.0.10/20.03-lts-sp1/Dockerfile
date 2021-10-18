FROM openeuler/openeuler:20.03-lts-sp1
MAINTAINER gaohechao <suisuisuisuixin@gmail.com>
RUN yum update -y && yum install -y tomcat && yum clean all;
RUN sed -i s/::1/0.0.0.0/g /usr/share/tomcat/conf/server.xml
RUN sed -i '118a\               secretRequired=""' /usr/share/tomcat/conf/server.xml
EXPOSE 8080
CMD [ "/usr/libexec/tomcat/server", "start" ]
