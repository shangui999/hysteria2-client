# hysteria2-client

Dockerized Hysteria 2 client proxy, providing HTTP and SOCKS5 proxy ports.

## Quick Start

```bash
docker run -d --name hy2 --restart always \
  -e HY2_SERVER=your.server:8443 \
  -e HY2_PASSWORD=yourpassword \
  -p 10808:10808 \
  -p 10809:10809 \
  ghcr.io/shangui999/hysteria2-client:latest
```

## Environment Variables

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `HY2_SERVER` | Yes | - | Hysteria 2 server address (host:port) |
| `HY2_PASSWORD` | Yes | - | Authentication password |
| `HY2_SOCKS_PORT` | No | `10808` | SOCKS5 proxy listen port |
| `HY2_HTTP_PORT` | No | `10809` | HTTP proxy listen port |
| `HY2_SNI` | No | - | TLS SNI hostname |
| `HY2_INSECURE` | No | `true` | Skip TLS certificate verification |

## Port Mapping

| Port | Protocol | Description |
|------|----------|-------------|
| 10808 | TCP | SOCKS5 proxy |
| 10809 | TCP | HTTP proxy |

## Upgrade Hysteria 2 Version

Edit `HY2_VERSION` in `Dockerfile`, push to main — GitHub Actions will auto-build and push the new image.

## CI/CD

Push to `main` triggers GitHub Actions to build and push the image to `ghcr.io/shangui999/hysteria2-client:latest`.
