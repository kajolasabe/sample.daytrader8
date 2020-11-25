# Package the application as a war file
FROM maven:3.6.3-ibmjava-8-alpine AS builder
LABEL maintainer="IBM Java Engineering at IBM Cloud"
COPY pom.xml ./
COPY src src/
RUN mvn clean package

FROM openliberty/open-liberty:kernel-java11-openj9-ubi

COPY --chown=1001:0 src/main/liberty/config/server.xml /config/server.xml
COPY --chown=1001:0 src/main/liberty/config/server.xml /config/server.env
COPY --chown=1001:0 target/io.openliberty.sample.daytrader8.war /config/apps/

#Derby
COPY --chown=1001:0 target/liberty/wlp/usr/shared/resources/DerbyLibs/derby-10.14.2.0.jar /opt/ol/wlp/usr/shared/resources/DerbyLibs/derby-10.14.2.0.jar
COPY --chown=1001:0 target/liberty/wlp/usr/shared/resources/data /opt/ol/wlp/usr/shared/resources/data

RUN configure.sh
