# Security Policy

## Reporting Security Issues

If you discover a security vulnerability, please email security@example.com.

## For Local Testing

✅ Self-signed HTTPS is acceptable  
✅ Bind to localhost only  
✅ Use a strong password  
✅ Keep behind firewall  

## For Production Deployment

⚠️ **DO NOT expose port 3001 directly to the internet**

1. Use a reverse proxy (nginx, Caddy) with valid TLS
2. Require authentication
3. Use VPN or SSH tunnel for remote access
4. Keep images updated
5. Monitor access logs
6. Use strong passwords (16+ characters)
7. Set resource limits
8. Regular backups of ./config/

## Disabled by Default (For Security)

- File transfers (use clipboard instead)
- Session sharing
- Binary clipboard
- Audio/microphone
- GamePad support

## Best Practices

### Passwords

```bash
# Generate secure password
WEBTOP_PASSWORD=$(openssl rand -base64 32)
echo $WEBTOP_PASSWORD
```

### Network

```bash
# Only expose locally
WEBTOP_HTTPS_BIND=127.0.0.1

# Use reverse proxy with TLS for remote access
```

### Docker Security

```yaml
# In docker-compose.yml
services:
  desktop:
    cap_drop:
      - ALL
    cap_add:
      - NET_BIND_SERVICE
```

## Keep Updated

```bash
# Check for base image updates
docker pull lscr.io/linuxserver/webtop:ubuntu-xfce

# Rebuild if new version available
docker compose build --no-cache
docker compose up -d
```

## No Telemetry

- No data sent externally
- All communication local
- User data in ./config/ only
- No analytics

---

**Keep your Claude Desktop remote setup secure!**
