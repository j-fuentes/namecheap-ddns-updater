ARG ARCH=
FROM ${ARCH}debian:buster-slim

RUN apt-get update \
    && apt-get install -y curl dnsutils ca-certificates \
    && rm -rf /var/lib/apt/lists/*
RUN update-ca-certificates --fresh

ADD update.sh /update.sh

ENTRYPOINT ["/update.sh"]

CMD ""
