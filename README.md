# zrok Home Assistant Add-ons Repository

[![License](https://img.shields.io/badge/license-Apache%202.0-blue.svg)](LICENSE)
[![Home Assistant](https://img.shields.io/badge/Home%20Assistant-Add--on-blue.svg)](https://www.home-assistant.io/)

Home Assistant add-ons for [zrok](https://zrok.io) zero-trust networking integration.

## About

This repository contains Home Assistant add-ons that enable secure remote access to your Home Assistant instance using zrok's zero-trust networking platform, powered by OpenZiti.

## Available Add-ons

### zrok Share

Secure remote access to Home Assistant via zrok without port forwarding or VPN configuration.

**Features:**
- 🔒 Zero-trust security (OpenZiti)
- 🌍 Public HTTPS URL with automatic SSL
- 🔐 Optional password protection
- 🔄 Auto-restart and crash recovery
- 🏗️ Multi-architecture support (amd64, ARM64, ARMv7)
- 🆓 Free tier available

[📖 Full Documentation](zrok-share/README.md)

## Installation

### Add Repository to Home Assistant

1. Navigate to **Settings** → **Add-ons** → **Add-on Store**
2. Click **︙** (three dots) in top right corner
3. Select **Repositories**
4. Add this URL: `https://github.com/ralf-dev16/hass-zrok`
5. Click **Add** → **Close**

### Install an Add-on

1. Refresh the Add-on Store
2. Find the add-on in the list (e.g., "zrok Share")
3. Click on it
4. Click **Install**
5. Configure and start!

## Quick Start (zrok Share)

1. **Get a zrok token:**
   - Visit [zrok.io](https://zrok.io) and sign up
   - Check your email for the invitation token

2. **Configure the add-on:**
   - Open add-on configuration
   - Paste your zrok token
   - (Optional) Set username and password for Basic Auth
   - Save configuration

3. **Start the add-on:**
   - Click **Start**
   - Check the logs for your public HTTPS URL
   - Access your Home Assistant from anywhere!

## Documentation

- [zrok Share Add-on README](zrok-share/README.md) - Quick start guide
- [zrok Share Add-on DOCS](zrok-share/DOCS.md) - Detailed documentation
- [CHANGELOG](zrok-share/CHANGELOG.md) - Version history

## Support

- **Issues:** [GitHub Issues](https://github.com/ralf-dev16/hass-zrok/issues)
- **Discussions:** [GitHub Discussions](https://github.com/ralf-dev16/hass-zrok/discussions)
- **zrok Documentation:** [docs.zrok.io](https://docs.zrok.io)

## Contributing

Contributions are welcome! Please:
1. Fork the repository
2. Create a feature branch
3. Test your changes thoroughly
4. Submit a pull request

## License

Apache License 2.0 - See [LICENSE](LICENSE) for details

## Credits

- [zrok](https://github.com/openziti/zrok) - Zero-trust networking platform
- [OpenZiti](https://openziti.io) - Zero-trust networking foundation
- [Home Assistant](https://www.home-assistant.io) - Open source home automation

## Security

For security concerns, please review our [security documentation](zrok-share/DOCS.md#security-considerations) or open a private security advisory.

---

**Made with ❤️ for the Home Assistant community**
