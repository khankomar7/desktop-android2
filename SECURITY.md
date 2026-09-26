# Security Policy

## Reporting Security Issues

If you discover a security vulnerability, please email security@example.com instead of using the issue tracker.

## Security Recommendations

### For Local Testing

1. Self-signed HTTPS certificate is acceptable
2. Bind to localhost only
3. Use a strong password for WEBTOP_PASSWORD
4. Keep the container behind a firewall

### For Production Deployment

1. **Use a reverse proxy** with valid TLS certificate (nginx, Caddy, HAProxy)
2. **Enable authentication** before allowing access
3. **Use a VPN or SSH tunnel** for remote access
4. **Set resource limits** in docker-compose.yml
5. **Keep images updated** for security patches
6. **Monitor logs** for suspicious activity
7. **Use strong passwords** (minimum 16 characters)
8. **Restrict network access** with firewall rules
9. **Consider rate limiting** for login attempts
10. **Regular backups** of user data in ./config/

## What's Disabled for Security

These features are disabled by default to reduce attack surface:

- File transfers (use clipboard instead)
- Session sharing
- Binary clipboard
- Audio/microphone access
- GamePad support

## Best Practices

### Network

```bash
# Do NOT expose 3001 directly:
# docker compose up  # Wrong!

# Use reverse proxy instead:
WEBTOP_HTTPS_BIND=127.0.0.1  # Only localhost
```

### Passwords

```bash
# Use a long, random password
WEBTOP_PASSWORD=$(openssl rand -base64 32)
echo "WEBTOP_PASSWORD=$WEBTOP_PASSWORD" >> .env
```

### Container Security

```yaml
# docker-compose.yml example
services:
  desktop:
    # ... existing config ...
    cap_drop:
      - ALL
    cap_add:
      - NET_BIND_SERVICE
    read_only: false  # Needs write access for config
```

## Compliance

- No data is sent to external services by default
- All communication is local to the container
- User data stored in ./config/ directory only
- No telemetry or analytics

## Supported Versions

Security updates are provided for:

- Latest major version
- Previous major version

## Dependency Security

Base image: `lscr.io/linuxserver/webtop:ubuntu-xfce`

Check for updates:
```bash
docker pull lscr.io/linuxserver/webtop:ubuntu-xfce
```

Rebuild if updates available:
```bash
docker compose build --no-cache
docker compose up -d
```
