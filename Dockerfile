# BUILD
# ========================================

# @see https://hub.docker.com/_/maven
FROM maven:3-jdk-8 AS build

WORKDIR /app

# Hash to check file integrity (optional)
ENV SHA1 376280a8ced007b7ed56eb1e6c38af510654a420

# archive url to download an archive for a repository 
# @see https://developer.github.com/v3/repos/contents/#get-archive-link
ENV URL https://api.github.com/repos/agoncal/agoncal-application-petstore-ee7/tarball

# One Liner to Download the Latest Release from Github Repo
RUN wget -O- $URL/$SHA1 | tar xz --strip-components=1

# Build app war
RUN ["mvn", "package", "-Dmaven.test.skip=true"]

# RUN
# ========================================

# @see https://hub.docker.com/r/jboss/wildfly/
FROM jboss/wildfly:11.0.0.Final
  
MAINTAINER Malick D. "diop-malick@hotmail.fr"

COPY --from=build \
	/app/target/applicationPetstore.war \
	./wildfly/standalone/deployments/ 