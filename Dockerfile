FROM alpine:latest

ARG HY2_VERSION=v2.9.2
ARG TARGETARCH=amd64

RUN apk add --no-cache ca-certificates curl && \
    curl -fSL "https://github.com/apernet/hysteria/releases/download/app%2F${HY2_VERSION}/hysteria-linux-${TARGETARCH}" \
      -o /usr/local/bin/hysteria && \
    chmod +x /usr/local/bin/hysteria && \
    mkdir -p /etc/hysteria

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
