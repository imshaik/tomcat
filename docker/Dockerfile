# Set the base image
FROM tomcat:latest

#copy artifact from workspace to container

COPY imran.war /usr/local/tomcat/webapps

#Change the ownership of war file to tomcat

RUN chown -R tomcat:tomcat /usr/local/tomcat/webapps

WORKDIR /usr/local/tomcat/

# Set username
#USER root

#ENTRYPOINT [ "/bin/bash" ]

# Set the default command,giving single ' ...' quotation docker will think its a command
#CMD [ "/root/httpd.sh" ]

#CMD [ "-c", "/usr/sbin/httpd -k start;bash" ]

# Expose default port
EXPOSE 8080

