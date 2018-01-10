FROM openjdk:8-jdk-slim
ADD *.jar app.jar
RUN touch /app.jar

# install unzip
RUN apt-get install unzip
RUN apt-get update && apt-get install -y curl

# download JCE
RUN cd /tmp/ && \
    curl -LO "http://download.oracle.com/otn-pub/java/jce/8/jce_policy-8.zip" -H 'Cookie: oraclelicense=accept-securebackup-cookie' && \
    unzip jce_policy-8.zip && \
    rm jce_policy-8.zip && \
    yes |cp -v /tmp/UnlimitedJCEPolicyJDK8/*.jar $JAVA_HOME/jre/lib/security

RUN apt-get clean all

ADD create_jks.sh create_jks.sh
RUN chmod 777 create_jks.sh

ARG alias
ARG keystorename
ARG storepass
ARG validity

RUN ./create_jks.sh \
    --alias $alias --keystorename $keystorename \
    --storepass $storepass --validity $validity

RUN jar uf app.jar $keystorename.jks

EXPOSE 8888
ENTRYPOINT ["java","-Djava.security.egd=file:/dev/./urandom","-jar","/app.jar"]