FROM tomcat:jre8
ENVTERM=xterm
COPY target/WebApp.war /usr/local/tomcat/webapps/
CMD["catalina.sh", "run"]
EXPOSE 8080
