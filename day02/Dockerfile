FROM eclipse-temurin:21

WORKDIR /kotlin
RUN apt-get update && apt-get install unzip
RUN mkdir /kotlin/compiler && \
    wget https://github.com/JetBrains/kotlin/releases/download/v1.9.21/kotlin-compiler-1.9.21.zip && \
    unzip kotlin-compiler-1.9.21.zip -d /kotlin && \
    rm kotlin-compiler-1.9.21.zip

ENV PATH /kotlin/kotlinc/bin:$PATH
