FROM --platform=linux/amd64 maven:3.9.3-eclipse-temurin-17 AS builder
COPY src /home/app/src
COPY pom.xml /home/app
COPY settings.xml /home/app
WORKDIR /home/app
RUN mvn -s settings.xml clean install

FROM --platform=linux/amd64 openjdk:17-alpine
COPY --from=builder /home/app/target/clock.api-*.jar /usr/local/lib/root.jar
EXPOSE 8080
LABEL version=2.0.0
ENTRYPOINT ["java","-Xmx128m","-Xms64m","-XX:+UseSerialGC","-XX:MaxRAM=256m", "-Xss512k","-jar","/usr/local/lib/root.jar"]
# Build command:    docker image build -t clock-api:1.0.0 .
# Run command:      docker container run -d -p 8080:8080 clock-api:1.0.0


