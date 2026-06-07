# hysteria2-client

Dockerized Hysteria 2 client proxy, providing HTTP and SOCKS5 proxy ports.

## Quick Start (URI mode)

```bash
docker run -d --name hy2 --restart always \
  -e HY2_URI="hysteria2://password@server:port?sni=example.com&insecure=0&mport=50000-60000#name" \
  -p 10808:10808 \
  -p 10809:10809 \
  ghcr.io/shangui999/hysteria2-client:latest
```

## Environment Variables

### URI mode (recommended)

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `HY2_URI` | Yes | - | Full hysteria2:// URI, supports sni/insecure/mport/pinSHA256 params |
| `HY2_SOCKS_PORT` | No | `10808` | SOCKS5 proxy listen port |
| `HY2_HTTP_PORT` | No | `10809` | HTTP proxy listen port |

### Manual mode (fallback)

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `HY2_SERVER` | Yes | - | Server address (host:port) |
| `HY2_PASSWORD` | Yes | - | Authentication password |
| `HY2_SNI` | No | - | TLS SNI hostname |
| `HY2_INSECURE` | No | `true` | Skip TLS certificate verification |
| `HY2_MPORT` | No | - | Port hopping range (e.g. `50000-60000`) |
| `HY2_SOCKS_PORT` | No | `10808` | SOCKS5 proxy listen port |
| `HY2_HTTP_PORT` | No | `10809` | HTTP proxy listen port |

## Port Mapping

| Port | Protocol | Description |
|------|----------|-------------|
| 10808 | TCP | SOCKS5 proxy |
| 10809 | TCP | HTTP proxy |

## Upgrade Hysteria 2 Version

Edit `HY2_VERSION` in `Dockerfile`, push to main — GitHub Actions will auto-build and push the new image.

## CI/CD

Push to `main` triggers GitHub Actions to build and push the image to `ghcr.io/shangui999/hysteria2-client:latest`.
