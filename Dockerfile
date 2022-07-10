FROM centos:7

RUN yum -y install httpd

COPY target/WebApp.war /var/www/html/

CMD [“/usr/sbin/httpd”, “-D”, “FOREGROUND”]

EXPOSE 80

