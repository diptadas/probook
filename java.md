# JAVA

## Change JAVA version

```
$ export JAVA_HOME=(/usr/libexec/java_home -v 1.8)
```

## Spring Boot Docker

```
FROM maven:3-jdk-8 AS build
WORKDIR /app
COPY . .
RUN mvn clean package

FROM openjdk:8
COPY --from=build /app/target/cms-0.0.1-SNAPSHOT.jar app.jar  
ENTRYPOINT ["java","-jar","app.jar"]
```

## Running JAR from Windows

```
RUN dos2unix ./mvnw
```

##  Build and run in Docker

- Build all the dependencies in preparation to go offline.  This is a separate step so the dependencies will be cached unless the pom.xml file has changed.

```
RUN ./mvnw dependency:go-offline -B
```

- Copy the project source

```
COPY src src
```

- Package the application

```
RUN ./mvnw package -DskipTests
RUN mkdir -p target/dependency && (cd target/dependency; jar -xf ../*.jar)
```

- Stage 2: A minimal Docker image with a command to run the app 

```
$ FROM openjdk:8-jre-alpine
```

- Dependency

```
ARG DEPENDENCY=/app/target/dependency

COPY --from=build ${DEPENDENCY}/BOOT-INF/lib /app/lib
COPY --from=build ${DEPENDENCY}/META-INF /app/META-INF
COPY --from=build ${DEPENDENCY}/BOOT-INF/classes /app

ENTRYPOINT ["java","-cp","app:app/lib/*","edu.baylor.ecs.cms.CmsApplication"]
```
