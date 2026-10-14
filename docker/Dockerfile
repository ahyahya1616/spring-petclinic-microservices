# Stage 1: Layer extraction using Spring Boot layertools
FROM eclipse-temurin:21-jdk-jammy AS builder
WORKDIR /application
ARG ARTIFACT_NAME
COPY ${ARTIFACT_NAME}.jar application.jar
RUN java -Djarmode=layertools -jar application.jar extract

# Stage 2: Hardened, minimal JRE runtime
FROM eclipse-temurin:21-jre-jammy AS runtime
WORKDIR /application

# Standardize non-root user
RUN groupadd --system --gid 10001 spring && \
    useradd --system --uid 10001 --gid spring --home-dir /application spring

ARG EXPOSED_PORT=8080
ENV SERVER_PORT=${EXPOSED_PORT}
EXPOSE ${EXPOSED_PORT}

ENV SPRING_PROFILES_ACTIVE=docker

# Production container JVM ergonomics
ENV JAVA_TOOL_OPTIONS="-XX:MaxRAMPercentage=75.0 -XX:InitialRAMPercentage=50.0 -XX:+ExitOnOutOfMemoryError -Djava.security.egd=file:/dev/./urandom -XX:+UseG1GC"

# Copy layers with non-root ownership in order of change frequency
COPY --from=builder --chown=spring:spring /application/dependencies/ ./
COPY --from=builder --chown=spring:spring /application/spring-boot-loader/ ./
COPY --from=builder --chown=spring:spring /application/snapshot-dependencies/ ./
COPY --from=builder --chown=spring:spring /application/application/ ./

USER 10001:10001

ENTRYPOINT ["java", "org.springframework.boot.loader.launch.JarLauncher"]
