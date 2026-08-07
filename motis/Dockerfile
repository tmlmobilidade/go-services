FROM alpine:3.20

ARG MOTIS_VERSION=v2.10.2
ARG TARGETARCH

RUN apk add --no-cache bzip2 ca-certificates curl && \
    curl -fsSL "https://github.com/motis-project/motis/releases/download/${MOTIS_VERSION}/motis-linux-${TARGETARCH}.tar.bz2" -o /tmp/motis.tar.bz2 && \
    tar -xjf /tmp/motis.tar.bz2 -C / && \
    rm /tmp/motis.tar.bz2 && \
    addgroup -S motis && \
    adduser -S motis -G motis && \
    mkdir /data && \
    chown motis:motis /data

EXPOSE 8080
VOLUME ["/data"]
USER motis

ENTRYPOINT ["/motis"]
CMD ["server"]
