#!/bin/sh

SERVER="${HY2_SERVER:?HY2_SERVER is required}"
PASSWORD="${HY2_PASSWORD:?HY2_PASSWORD is required}"
SOCKS_PORT="${HY2_SOCKS_PORT:-10808}"
HTTP_PORT="${HY2_HTTP_PORT:-10809}"
SNI="${HY2_SNI:-}"
INSECURE="${HY2_INSECURE:-true}"

cat > /etc/hysteria/config.yaml <<EOF
server: ${SERVER}

auth: ${PASSWORD}

tls:
  sni: ${SNI}
  insecure: ${INSECURE}

socks5:
  listen: 0.0.0.0:${SOCKS_PORT}

http:
  listen: 0.0.0.0:${HTTP_PORT}
EOF

exec /usr/local/bin/hysteria client -c /etc/hysteria/config.yaml
