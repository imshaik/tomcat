# Set the base image
FROM tomcat:latest

# Update application repository list
#RUN yum install httpd -y

#copy httpd.sh script from local to container

COPY ../target/imran.war /usr/local/tomcat/webapps/ROOT/WEB-INF

WORKDIR /usr/local/tomcat/

# Set username
#USER root

#ENTRYPOINT [ "/bin/bash" ]

# Set the default command,giving single ' ...' quotation docker will think its a command
#CMD [ "/root/httpd.sh" ]

#CMD [ "-c", "/usr/sbin/httpd -k start;bash" ]

# Expose default port
EXPOSE 8080

