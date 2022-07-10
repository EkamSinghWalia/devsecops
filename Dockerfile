FROM tomcat:jre8
COPY target/WebApp.war /usr/local/tomcat/webapps/
RUN rm -rf ROOT && mv WebApp.war ROOT.war
CMD ["catalina.sh", "run"]
EXPOSE 8080
