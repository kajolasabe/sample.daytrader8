# Package the application as a war file
FROM maven:3.6.3-ibmjava-8-alpine AS builder
LABEL maintainer="IBM Java Engineering at IBM Cloud"
COPY pom.xml ./
COPY resources/data resources/data
COPY src src/
RUN mvn clean package

FROM openliberty/open-liberty:kernel-java11-openj9-ubi

COPY --from=builder --chown=1001:0 src/main/liberty/config/ /config/
COPY --from=builder --chown=1001:0 target/*.war /config/apps/

#Derby
COPY --from=builder --chown=1001:0 target/liberty/wlp/usr/shared/resources/DerbyLibs/derby-10.14.2.0.jar /opt/ol/wlp/usr/shared/resources/DerbyLibs/derby-10.14.2.0.jar
#COPY --from=builder --chown=1001:0 target/liberty/wlp/usr/shared/resources/data /opt/ol/wlp/usr/shared/resources/data

RUN configure.sh
