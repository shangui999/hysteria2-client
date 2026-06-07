#!/bin/sh

urldecode() {
  printf '%b' "$(echo "$1" | sed 's/+/ /g; s/%\([0-9A-Fa-f][0-9A-Fa-f]\)/\\x\1/g')"
}

get_param() {
  echo "$1" | tr '&' '\n' | grep "^$2=" | head -1 | cut -d= -f2-
}

SOCKS_PORT="${HY2_SOCKS_PORT:-10808}"
HTTP_PORT="${HY2_HTTP_PORT:-10809}"

if [ -n "$HY2_URI" ]; then
  URI="$HY2_URI"
  # strip scheme
  URI="${URI#hysteria2://}"
  URI="${URI#hy2://}"
  # strip fragment
  URI="${URI%%#*}"
  # split userinfo@hostport?query
  USERINFO="${URI%%@*}"
  REST="${URI#*@}"
  HOSTPORT="${REST%%\?*}"
  QUERY=""
  case "$REST" in *\?*) QUERY="${REST#*\?}" ;; esac

  PASSWORD="$(urldecode "$USERINFO")"
  SERVER="$HOSTPORT"
  SNI="$(get_param "$QUERY" sni)"
  INSECURE="$(get_param "$QUERY" insecure)"
  MPORT="$(get_param "$QUERY" mport)"
  PIN_SHA256="$(get_param "$QUERY" pinSHA256)"
  # normalize insecure: URI uses 0/1, hy2 config uses true/false
  case "$INSECURE" in
    0|false) INSECURE="false" ;;
    *) INSECURE="true" ;;
  esac
else
  SERVER="${HY2_SERVER:?HY2_SERVER or HY2_URI is required}"
  PASSWORD="${HY2_PASSWORD:?HY2_PASSWORD is required}"
  SNI="${HY2_SNI:-}"
  INSECURE="${HY2_INSECURE:-true}"
  MPORT="${HY2_MPORT:-}"
  PIN_SHA256=""
fi

# build config
cat > /etc/hysteria/config.yaml <<EOF
server: ${SERVER}

auth: ${PASSWORD}

tls:
  sni: ${SNI}
  insecure: ${INSECURE}
EOF

if [ -n "$PIN_SHA256" ]; then
  cat >> /etc/hysteria/config.yaml <<EOF
  pinSHA256: ${PIN_SHA256}
EOF
fi

if [ -n "$MPORT" ]; then
  cat >> /etc/hysteria/config.yaml <<EOF

transport:
  udp:
    hopPorts: ${MPORT}
    hopInterval: 30s
EOF
fi

cat >> /etc/hysteria/config.yaml <<EOF

socks5:
  listen: 0.0.0.0:${SOCKS_PORT}

http:
  listen: 0.0.0.0:${HTTP_PORT}
EOF

echo "--- Generated config ---"
cat /etc/hysteria/config.yaml
echo "------------------------"

exec /usr/local/bin/hysteria client -c /etc/hysteria/config.yaml
