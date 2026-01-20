# zrok Share Add-on for Home Assistant

![Version](https://img.shields.io/badge/version-0.1.0-blue.svg)
![Supports amd64](https://img.shields.io/badge/amd64-yes-green.svg)
![Supports aarch64](https://img.shields.io/badge/aarch64-yes-green.svg)
![Supports armv7](https://img.shields.io/badge/armv7-yes-green.svg)

Secure remote access to your Home Assistant instance via [zrok](https://zrok.io) zero-trust networking.

## About

This add-on provides a simple way to access your Home Assistant instance remotely without:
- Complex VPN configurations
- Port forwarding
- Paid cloud subscriptions
- Exposing ports on your router

Using zrok's zero-trust networking platform (built on OpenZiti), you get a secure HTTPS URL that tunnels directly to your Home Assistant instance.

## Features

- 🔒 **Zero-Trust Security** - End-to-end encrypted tunnel via OpenZiti
- 🌍 **Public HTTPS URL** - Automatic SSL certificate, no configuration needed
- 🔐 **Optional Password Protection** - Basic Authentication for additional security
- 🔄 **Auto-Restart** - Automatic recovery from crashes and network issues
- 🏗️ **Multi-Architecture** - Supports amd64, aarch64 (ARM64), and armv7 (Raspberry Pi)
- 📊 **Simple Setup** - Configure once, works forever
- 🆓 **Free & Open Source** - No subscription required

## Installation

1. **Add this repository to your Home Assistant:**
   - Navigate to **Settings** → **Add-ons** → **Add-on Store**
   - Click the three dots in the top right → **Repositories**
   - Add: `https://github.com/ralf-dev16/hass-zrok`

2. **Install the zrok Share add-on:**
   - Find "zrok Share" in the add-on store
   - Click **Install**

3. **Get your zrok token:**
   - Visit [zrok.io](https://zrok.io) and create a free account
   - Check your email for the invitation token

4. **Configure the add-on:**
   - Go to the **Configuration** tab
   - Paste your zrok token
   - (Optional) Set username and password for Basic Auth
   - Save the configuration

5. **Start the add-on:**
   - Go to the **Info** tab
   - Click **Start**
   - Check the **Log** tab for your public URL

6. **Access your Home Assistant:**
   - Copy the HTTPS URL from the logs
   - Open it in any browser
   - Bookmark it for future use!

## Configuration

### Required Settings

| Option | Description | Default |
|--------|-------------|---------|
| `zrok_token` | Your zrok invitation token from zrok.io | (none - required) |

### Optional Settings

| Option | Description | Default |
|--------|-------------|---------|
| `backend_url` | Internal Home Assistant URL | `http://homeassistant:8123` |
| `basic_auth_username` | Username for Basic Authentication | (empty - no auth) |
| `basic_auth_password` | Password for Basic Authentication | (empty - no auth) |
| `share_mode` | Share mode (public/private/reserved) | `public` |
| `auto_restart` | Automatically restart on failure | `true` |
| `log_level` | Logging verbosity (debug/info/warn/error) | `info` |

### Example Configuration

```yaml
zrok_token: "a1b2c3d4e5f6g7h8i9j0"
backend_url: "http://homeassistant:8123"
basic_auth_username: "admin"
basic_auth_password: "SecurePassword123!"
share_mode: "public"
auto_restart: true
log_level: "info"
```

## Security Recommendations

1. **Always use Basic Authentication** when exposing to the internet
2. **Enable Home Assistant's built-in authentication** (it's enabled by default)
3. **Use strong passwords** for both Basic Auth and Home Assistant
4. **Consider enabling 2FA** in Home Assistant for additional security
5. **Monitor your logs** regularly for suspicious activity
6. **Keep Home Assistant updated** to the latest version

### Security Layers

When properly configured, you have **three layers of security**:
1. Basic Authentication (this add-on)
2. Home Assistant login
3. OpenZiti zero-trust encryption

## Troubleshooting

### Add-on won't start

**Problem:** Add-on shows error in logs

**Solutions:**
1. Check that your zrok token is valid
2. Ensure you have an active internet connection
3. Review the logs for specific error messages
4. Try regenerating your token at zrok.io

### Can't access the public URL

**Problem:** URL from logs doesn't work

**Solutions:**
1. Make sure the add-on is running (check **Info** tab)
2. Wait 30-60 seconds after start for the tunnel to establish
3. Check if the URL in logs is complete (starts with `https://`)
4. Verify your internet connection

### URL changes every restart

**Problem:** Public URL is different each time

**Solutions:**
- Free zrok accounts get dynamic URLs
- For a custom/permanent domain, upgrade to [zrok Pro](https://zrok.io)
- Bookmark the new URL after each restart

### Configuration locked out

**Problem:** Bad configuration prevents add-on from starting

**Solutions:**
1. Stop the add-on in the Home Assistant UI
2. Edit the configuration in the **Configuration** tab
3. Save the corrected configuration
4. Start the add-on again

Note: Configuration is stored externally by Home Assistant, so it's always editable even when the add-on is stopped!

## How It Works

```
┌─────────────────┐         ┌──────────────┐         ┌─────────────┐
│  Your Browser   │◄───────►│  zrok.io     │◄───────►│ Home        │
│  (anywhere)     │  HTTPS  │  Platform    │ Tunnel  │ Assistant   │
│                 │         │  (OpenZiti)  │         │ + zrok      │
└─────────────────┘         └──────────────┘         └─────────────┘
```

1. zrok creates an encrypted tunnel from your Home Assistant to the zrok platform
2. You get a public HTTPS URL (e.g., `https://abc123.share.zrok.io`)
3. When you visit the URL, traffic is securely tunneled to your local Home Assistant
4. No ports opened on your router - zero-trust security

## Limitations

- **Free Tier:** 10 GB/month transfer limit (usually plenty for Home Assistant UI)
- **Dynamic URLs:** URL changes on restart (use zrok Pro for custom domains)
- **Latency:** Small additional latency (~50-100ms) due to tunneling
- **Not suitable for:** Real-time video streaming or large file transfers

## Support

- **Documentation:** See [DOCS.md](DOCS.md) for detailed information
- **Issues:** Report bugs at [GitHub Issues](https://github.com/ralf-dev16/hass-zrok/issues)
- **Questions:** Ask in [GitHub Discussions](https://github.com/ralf-dev16/hass-zrok/discussions)

## Links

- [zrok Website](https://zrok.io)
- [zrok Documentation](https://docs.zrok.io)
- [OpenZiti Project](https://openziti.io)
- [Home Assistant](https://www.home-assistant.io)

## License

Apache License 2.0 - See [LICENSE](../LICENSE) for details

## Credits and Attributions

Built with:
- **[zrok](https://github.com/openziti/zrok)** - Zero-trust networking platform
  - License: Apache 2.0
  - Copyright: 2019 NetFoundry, Inc.
- **[OpenZiti](https://github.com/openziti)** - Zero-trust networking foundation
  - License: Apache 2.0
  - Copyright: NetFoundry, Inc.
  - OpenZiti was developed and open sourced by NetFoundry, Inc.
- **[Home Assistant](https://www.home-assistant.io)** - Open source home automation
  - License: Apache 2.0

For detailed third-party license information, see [THIRD-PARTY-NOTICES.md](../THIRD-PARTY-NOTICES.md).

---

**Enjoy secure remote access to your Home Assistant!** 🏠🔒
