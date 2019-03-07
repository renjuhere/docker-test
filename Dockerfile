FROM openshift/base-centos7

LABEL Component="httpd parent" \
io.k8s.display-name="httpd parent" \
io.k8s.description="httpd parent description" \
io.openshift.expose-services="80:http" \
io.openshift.tags="httpd"

ENV DOCROOT=/var/www/html \
	LOG_PATH=/var/log/httpd
	LANG=en_US
	
# Install required yum packages
RUN yum -y install epel-release && \
	yum -y update && \
	yum install -y --setopt=tsflags=nodocs --noplugins httpd skopeo && \
	yum clean -y all --noplugins &&
	echo "Hello world from httpd-parent" > ${HOME}/index.html
	
ONBUILD COPY src/ ${DOCROOT}/

RUN sed -i "s/Listen 80/Listen 8080/g" /etc/httpd/conf/httpd.conf

EXPOSE 8080

RUN rm -rf /run/httpd && mkdir /run/httpd

RUN chgrp -R 0 /var/log/httpd /var/run/httpd &&
	chmod -R g=u /var/log/httpd /var/run/httpd

USER 1001

CMD /usr/sbin/apachectl -DFOREGROUND