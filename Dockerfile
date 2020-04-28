FROM centos:7



MAINTAINER Red hat

LABEL Component="httpd" \
      Name="do288/httpd" \
      Version="1.0" \
      Release="1"
LABEL io.k8s.description="A basic apache http server image with ONBUILD instructions" \
      io.openshift.expose-services="80:http" \
      io.openshift.tags="apache,httpd" 


ENV DOCROOT=/var/www/html \
    LANG=en_US \
    LOG_PATH=/var/log/httpd 

RUN yum install -y --setopt=tsflags=nodocs --noplugins httpd && \
    yum -y clean all --noplugins && \
    echo "Hello from the httpd-parent container!" > ${HOME}/index.html

ONBUILD COPY src/ ${DOCROOT}/

EXPOSE 80

RUN rm -rf /run/httpd && mkdir /run/httpd

USER root

CMD /usr/sbin/apachectl -DFOREGROUND
