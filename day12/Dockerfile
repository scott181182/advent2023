FROM ubuntu:22.04

WORKDIR /processing

# Install Processing
RUN apt update && apt install -y wget && \
    wget -q https://github.com/processing/processing4/releases/download/processing-1293-4.3/processing-4.3-linux-x64.tgz && \
    tar -xzf processing-4.3-linux-x64.tgz

# Enable Virtual Display
RUN apt install -y xvfb libxrender1 libxtst6 libxi6
COPY ./entrypoint.sh /processing/
ENV DISPLAY=":1"

ENTRYPOINT [ "/processing/entrypoint.sh" ]
