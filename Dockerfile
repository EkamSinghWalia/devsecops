FROM tomcat:jre8
COPY target/WebApp.war /usr/local/tomcat/webapps/
CMD ["catalina.sh", "run"]
EXPOSE 5000
