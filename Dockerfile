FROM debian:buster-slim as base

RUN apt-get update && \
    apt-get install -y \
        curl \
        jq \
        net-tools \
        vim \
    \
    && rm -rf /var/lib/apt/lists/*

COPY ip_forcast.sh /
CMD [ "/bin/bash", "./ip_forcast.sh" ]