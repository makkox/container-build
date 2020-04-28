FROM centos:7

MAINTAINER Red hat

LABEL Component="httpd" \
      Name="do288/httpd" \
      Version="1.0" \
      Release="1"
LABEL io.k8s.description="A basic apache http server image with ONBUILD instructions" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="apache,httpd" 


ENV DOCROOT=/var/www/html \
    LANG=en_US \
    LOG_PATH=/var/log/httpd 

RUN yum install -y --setopt=tsflags=nodocs --noplugins httpd && \
    yum -y clean all --noplugins && \
    echo "Hello from the httpd-parent container!" > ${HOME}/index.html

ONBUILD COPY src/ ${DOCROOT}/

EXPOSE 8080

RUN sed -i "s/Listen 80/Listen 8080/g" /etc/httpd/conf/httpd.conf && \
    chgrp -R 0 /var/log/httpd /var/run/httpd && \
    chmod -R g=u /var/log/httpd /var/run/httpd

USER 1001

CMD /usr/sbin/apachectl -DFOREGROUND
