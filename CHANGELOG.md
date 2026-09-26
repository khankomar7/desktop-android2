# Changelog

All notable changes to this project will be documented in this file.

## [1.0.0] - 2026-09-26

### Added

- Initial production-ready release
- Android-first performance profile
- Claude Desktop and Claude Code preinstalled
- Low-latency desktop streaming (40-60ms)
- Touch-optimized UI for mobile
- Mobile-friendly sidebar (minimal UI)
- Performance tuning script for XFCE
- Docker Compose configuration
- Multiple performance presets (balanced, ultra-fast, quality)
- Comprehensive README with troubleshooting
- Security recommendations
- Health checks and resource limits

### Performance Optimizations

- Disabled XFCE compositing (saves ~30% CPU)
- Disabled window animations
- Removed shadows and visual effects
- Solid background instead of wallpaper
- Optimized H.264 encoding (CRF 30)
- 24 fps streaming (vs 30 fps default)
- 1280x720 resolution (vs 1920x1080 default)
- CSS-based scaling (browser-side)
- Browser-side cursor rendering
- Paint-over-quality rendering

### Configuration

- 3 performance presets included
- Easy environment variable customization
- Docker resource limits configurable
- Persistent user data storage
- HTTPS support with self-signed certs

## Future Roadmap

- [ ] Nginx reverse proxy configuration for production
- [ ] Automatic HTTPS with Let's Encrypt
- [ ] Multi-user support
- [ ] Session persistence
- [ ] Network bandwidth monitoring
- [ ] Mobile app wrapper
- [ ] Custom branding support
