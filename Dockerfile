FROM httpd:2.4 
WORKDIR /var/www/html/
COPY target/WebApp.war .
RUN rm -rf ROOT && mv WebApp.war ROOT.war
EXPOSE 80
CMD ["/etc/init.d/apache2" ,"start", "-D",  "FOREGROUND"]
