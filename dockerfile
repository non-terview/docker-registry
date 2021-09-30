FROM adoptopenjdk/openjdk16:x86_64-alpine-jdk-16.0.1_9 as builder
WORKDIR application
ARG JAR_FILE=./onterview-api.jar
COPY ${JAR_FILE} application.jar
RUN java -Djarmode=layertools -jar application.jar extract
RUN ls -lia
FROM adoptopenjdk/openjdk16:x86_64-alpine-jdk-16.0.1_9
WORKDIR application
ENV port 80
ENV spring.profiles.active local
COPY --from=builder application/dependencies/ ./
COPY --from=builder application/spring-boot-loader/ ./
COPY --from=builder application/snapshot-dependencies/ ./
COPY --from=builder application/application/ ./

ENTRYPOINT ["java", "org.springframework.boot.loader.JarLauncher"]
