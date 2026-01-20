# Changelog

All notable changes to this add-on will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0] - 2026-01-18

### Added
- Initial release of zrok Share Add-on
- Public HTTPS share via zrok zero-trust networking
- Basic Authentication support (username/password)
- Auto-restart functionality for crash recovery
- Multi-architecture support (amd64, aarch64, armv7)
- External configuration storage to prevent lock-out scenarios
- Comprehensive logging with configurable log levels
- Automatic zrok environment setup and management
- Configuration validation and user-friendly error messages
- Complete documentation (README, DOCS, inline help)

### Features
- Zero-trust security via OpenZiti
- Automatic SSL certificates
- No port forwarding required
- No VPN configuration needed
- Works behind NAT and firewalls
- Persistent storage for zrok identity
- Support for Home Assistant OS, Supervised, and Container installations

### Configuration Options
- `zrok_token` - zrok invitation token (required)
- `backend_url` - Internal Home Assistant URL
- `basic_auth_username` - Optional Basic Auth username
- `basic_auth_password` - Optional Basic Auth password
- `share_mode` - Share type (public/private/reserved)
- `auto_restart` - Auto-restart on failure
- `log_level` - Logging verbosity (debug/info/warn/error)

### Documentation
- Quick start guide (README.md)
- Detailed documentation (DOCS.md)
- Configuration examples
- Troubleshooting guide
- Security best practices
- FAQ section

### Known Limitations
- Free tier: 10 GB/month transfer limit
- Dynamic URLs (custom domains require zrok Pro)
- Additional latency (~50-100ms) due to tunneling
- Not recommended for real-time video streaming

### Security
- End-to-end encryption via OpenZiti
- Support for HTTP Basic Authentication
- Secure token storage by Home Assistant
- No sensitive data in logs (passwords masked)
- Defense-in-depth architecture (3 security layers)

### Compatibility
- Home Assistant OS 2023.x and later
- Home Assistant Supervised 2023.x and later
- Home Assistant Container 2023.x and later
- zrok platform (latest)

---

## Future Releases

### Planned for [0.2.0]
- Status sensor for Home Assistant
- GitHub Actions CI/CD pipeline
- Automated multi-arch builds
- Community repository submission
- Add-on icon and branding
- Enhanced error recovery

### Planned for [0.3.0]
- Custom domain support (zrok Pro integration)
- Private share mode
- Advanced metrics and monitoring
- Integration with Home Assistant notifications
- Webhook support for share URL changes

### Under Consideration
- Multiple simultaneous shares
- Load balancing support
- Bandwidth usage statistics
- Share URL history
- Email notifications for URL changes
- Home Assistant entity for share URL
- OAuth integration

---

## Migration Guide

### From Manual zrok Installation

If you previously ran zrok manually:

1. Stop your manual zrok process
2. Install this add-on
3. Configure with your existing zrok token
4. The add-on will create a new zrok environment in `/data/.zrok`
5. Your old zrok environment can be safely deleted

Note: You'll get a new public URL when using the add-on.

---

## Support

For bugs, feature requests, or questions:
- GitHub Issues: https://github.com/ralf-dev16/hass-zrok/issues
- GitHub Discussions: https://github.com/ralf-dev16/hass-zrok/discussions

---

**Legend:**
- `Added` - New features
- `Changed` - Changes to existing functionality
- `Deprecated` - Soon-to-be removed features
- `Removed` - Removed features
- `Fixed` - Bug fixes
- `Security` - Security improvements
