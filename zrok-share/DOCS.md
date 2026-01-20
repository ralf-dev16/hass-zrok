# zrok Share Add-on - Detailed Documentation

## Table of Contents

1. [Introduction](#introduction)
2. [Architecture](#architecture)
3. [Installation Guide](#installation-guide)
4. [Configuration Reference](#configuration-reference)
5. [Advanced Usage](#advanced-usage)
6. [Security Considerations](#security-considerations)
7. [Troubleshooting](#troubleshooting)
8. [FAQ](#faq)
9. [Development](#development)

---

## Introduction

### What is zrok?

zrok is an open-source zero-trust networking platform built on [OpenZiti](https://openziti.io). It allows you to securely share services (like your Home Assistant) over the internet without opening ports on your router or setting up complex VPN configurations.

### How does it work?

zrok creates an **encrypted tunnel** from your Home Assistant instance to the zrok platform. When you access the public URL, your traffic is securely routed through this tunnel:

```
Internet User → HTTPS → zrok.io Platform → Encrypted Tunnel → Your Home Assistant
```

**Key benefits:**
- ✅ No port forwarding required
- ✅ No VPN configuration needed
- ✅ Zero-trust security (end-to-end encryption)
- ✅ Automatic SSL certificates
- ✅ Works behind NAT and firewalls

### Use Cases

- **Remote Access:** Control your home from anywhere
- **Family Sharing:** Give trusted users access without technical setup
- **IoT/Agricultural Automation:** Secure access to remote installations
- **Testing:** Temporary public access for development
- **Avoiding Cloud Costs:** Free alternative to Nabu Casa

---

## Architecture

### System Components

```
┌──────────────────────────────────────────────────┐
│           Home Assistant OS                      │
│  ┌───────────────────────────────────────────┐  │
│  │     zrok Share Add-on (Docker Container)  │  │
│  │                                           │  │
│  │  ┌─────────────┐    ┌─────────────────┐  │  │
│  │  │  run.sh     │───▶│  zrok binary    │  │  │
│  │  │  (wrapper)  │    │  (share public) │  │  │
│  │  └─────────────┘    └────────┬────────┘  │  │
│  │         ▲                     │           │  │
│  │         │                     │           │  │
│  │    ┌────┴─────┐               │           │  │
│  │    │ options  │               │           │  │
│  │    │   .json  │               │           │  │
│  │    └──────────┘               │           │  │
│  └──────────────────────────────┼───────────┘  │
│                                  │              │
│  ┌──────────────────────────────▼───────────┐  │
│  │   Home Assistant Core (localhost:8123)    │  │
│  └───────────────────────────────────────────┘  │
└──────────────────────────────────────────────────┘
                    │
                    │ OpenZiti Tunnel (Encrypted)
                    ▼
         ┌──────────────────────┐
         │  zrok.io Platform    │
         │  (OpenZiti Network)  │
         └──────────┬───────────┘
                    │
                    │ HTTPS
                    ▼
         ┌──────────────────────┐
         │   End User Browser   │
         └──────────────────────┘
```

### Data Flow

1. **Startup:**
   - Add-on reads configuration from `/data/options.json`
   - Verifies zrok token and enables zrok environment
   - Starts `zrok share public` command
   - Generates public HTTPS URL

2. **Request Flow:**
   - User visits `https://xyz.share.zrok.io`
   - zrok platform routes to your OpenZiti identity
   - Encrypted tunnel delivers request to `localhost:8123`
   - Home Assistant processes and returns response
   - Response travels back through tunnel

3. **Authentication:**
   - Optional Basic Auth (browser popup)
   - Home Assistant login (standard HA auth)
   - Both layers are independent and additive

### Storage and Persistence

**Configuration Storage:**
- Location: `/data/options.json` (managed by Home Assistant)
- Editable: Via HA UI at any time
- Persists: Across add-on restarts and updates

**zrok Environment:**
- Location: `/data/.zrok/`
- Contents: OpenZiti identity, credentials, environment config
- Persists: Across add-on restarts (not across re-enables)

**Logs:**
- Location: stdout/stderr (captured by HA)
- Access: Add-on **Log** tab in HA UI

---

## Installation Guide

### Prerequisites

- Home Assistant OS, Supervised, or Container installation
- Active internet connection
- Email address for zrok account

### Step-by-Step Installation

#### 1. Add Repository

Navigate to **Settings** → **Add-ons** → **Add-on Store**:
1. Click **︙** (three dots) in top right
2. Select **Repositories**
3. Add: `https://github.com/ralf-dev16/hass-zrok`
4. Click **Add** → **Close**

#### 2. Install Add-on

1. Refresh the Add-on Store
2. Find **zrok Share** in the list
3. Click on it → Click **Install**
4. Wait for installation to complete

#### 3. Get zrok Token

1. Visit [zrok.io](https://zrok.io)
2. Click **Get Started** or **Sign Up**
3. Enter your email address
4. Check your email for invitation
5. Copy the token (looks like `a1b2c3d4e5f6g7h8...`)

#### 4. Configure Add-on

1. Go to **Configuration** tab
2. Paste your zrok token in `zrok_token` field
3. (Optional but recommended) Set `basic_auth_username` and `basic_auth_password`
4. Click **Save**

#### 5. Start Add-on

1. Go to **Info** tab
2. Enable **Start on boot** (optional but recommended)
3. Click **Start**
4. Wait 30-60 seconds for startup

#### 6. Get Your Public URL

1. Go to **Log** tab
2. Look for line like: `🌍 Public URL: https://xyz123.share.zrok.io`
3. Copy this URL
4. Test it in a browser (you should see Basic Auth prompt if configured, then HA login)

#### 7. Bookmark and Enjoy

Save the URL in your browser for easy access from anywhere!

---

## Configuration Reference

### zrok_token

**Type:** String (required)
**Description:** Your zrok invitation token from zrok.io
**Example:** `"eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9..."`

**How to get:**
1. Sign up at [zrok.io](https://zrok.io)
2. Check your email
3. Copy the token from the invitation email

**Security:** Token is stored securely by Home Assistant and never logged

---

### backend_url

**Type:** String
**Default:** `http://homeassistant:8123`
**Description:** Internal URL of your Home Assistant instance

**When to change:**
- If using a custom port: `http://homeassistant:8124`
- If HA runs on specific host: `http://192.168.1.100:8123`

**Note:** Do **not** use `https://` unless you have SSL configured internally

---

### basic_auth_username

**Type:** String (optional)
**Default:** Empty (no authentication)
**Description:** Username for HTTP Basic Authentication

**Example:** `"admin"`

**Security Note:** When set (along with password), browsers will show an authentication popup **before** the Home Assistant login page.

---

### basic_auth_password

**Type:** Password (optional)
**Default:** Empty (no authentication)
**Description:** Password for HTTP Basic Authentication

**Example:** `"MySecurePassword123!"`

**Recommendations:**
- Use at least 12 characters
- Include uppercase, lowercase, numbers, symbols
- Don't reuse passwords from other services

**Security:** Stored securely by Home Assistant (encrypted)

---

### share_mode

**Type:** List (public | private | reserved)
**Default:** `public`
**Description:** Type of zrok share to create

**Options:**
- `public` - Anyone with the URL can access (recommended for most users)
- `private` - Requires zrok authentication (advanced)
- `reserved` - Reserved shares for zrok Pro (custom domains)

**Note:** Most users should keep this as `public`

---

### auto_restart

**Type:** Boolean
**Default:** `true`
**Description:** Automatically restart on failure

**When enabled:**
- Add-on restarts if zrok crashes
- Reconnects after network issues
- Exponential backoff (5s, 10s, 15s, ... up to 60s)

**When disabled:**
- Add-on stops on first error
- Requires manual restart

**Recommendation:** Keep enabled for reliability

---

### log_level

**Type:** List (debug | info | warn | error)
**Default:** `info`
**Description:** Logging verbosity level

**Levels:**
- `debug` - Very detailed logs (for troubleshooting)
- `info` - Normal operation logs (recommended)
- `warn` - Only warnings and errors
- `error` - Only errors

**Use `debug` when:**
- Troubleshooting connection issues
- Reporting bugs
- Understanding what's happening internally

---

## Advanced Usage

### Using a Custom Domain (zrok Pro)

zrok Pro users can use custom domains:

1. Configure your domain in zrok dashboard
2. Set `share_mode` to `reserved`
3. Configure the reserved share name in zrok

See [zrok documentation](https://docs.zrok.io) for details.

### Self-Hosted zrok Controller

For maximum privacy, host your own zrok controller:

1. Follow the [zrok self-hosting guide](https://docs.zrok.io/docs/guides/self-hosting/)
2. Enable zrok with your self-hosted controller endpoint
3. Generate token from your controller

**Note:** This requires additional infrastructure and technical knowledge.

### Monitoring

Check add-on status:
```bash
# View logs
ha addons logs zrok-share

# Check add-on info
ha addons info zrok-share
```

### Integration with Home Assistant

You can create sensors to monitor the add-on:

```yaml
# configuration.yaml
sensor:
  - platform: command_line
    name: "zrok Status"
    command: "docker inspect addon_local_zrok-share --format='{{.State.Status}}'"
    scan_interval: 60
```

---

## Security Considerations

### Threat Model

**What zrok protects against:**
- ✅ Network sniffing (end-to-end encryption)
- ✅ Port scanning (no open ports)
- ✅ Man-in-the-middle attacks (certificate pinning)

**What zrok does NOT protect against:**
- ❌ Weak passwords (use strong credentials!)
- ❌ Unpatched vulnerabilities (keep HA updated)
- ❌ Physical access (secure your devices)
- ❌ Compromised tokens (keep tokens secret)

### Security Best Practices

1. **Enable Basic Authentication**
   ```yaml
   basic_auth_username: "admin"
   basic_auth_password: "VeryStrongPassword123!"
   ```

2. **Use Strong Home Assistant Password**
   - At least 16 characters
   - Use a password manager

3. **Enable Two-Factor Authentication in HA**
   - Settings → Users → Your User → Enable MFA

4. **Limit Access**
   - Only share URL with trusted people
   - Regenerate token if compromised

5. **Monitor Logs**
   - Check for suspicious access attempts
   - Review logs regularly

6. **Keep Updated**
   - Update Home Assistant regularly
   - Update this add-on when new versions release

### Defense in Depth

Proper configuration gives you **three security layers**:

```
Layer 1: Basic Authentication (this add-on)
    ↓
Layer 2: Home Assistant Login
    ↓
Layer 3: OpenZiti Zero-Trust Encryption
```

Each layer is independent - even if one fails, the others protect you.

### Data Privacy

- **Traffic:** Encrypted end-to-end via OpenZiti
- **zrok Platform:** Acts only as a relay, cannot decrypt traffic
- **Logs:** No sensitive data logged (passwords are masked)
- **Token:** Stored securely by Home Assistant

---

## Troubleshooting

### Add-on Won't Start

**Symptom:** Add-on shows "Error" status

**Check:**
1. Valid zrok token configured
2. Internet connection active
3. Logs for specific error message

**Solutions:**
```bash
# Check logs
ha addons logs zrok-share

# Restart add-on
ha addons restart zrok-share

# Rebuild add-on (if updated)
ha addons rebuild zrok-share
```

### Invalid Token Error

**Symptom:** `Failed to enable zrok` in logs

**Causes:**
- Expired token
- Already used token
- Typo in token

**Solutions:**
1. Get new token from [zrok.io](https://zrok.io)
2. Double-check for extra spaces or characters
3. Ensure you copied the complete token

### URL Not Working

**Symptom:** Public URL returns error or timeout

**Checks:**
1. Add-on is running (green in HA)
2. URL is complete (starts with `https://`)
3. Wait 60 seconds after start
4. Check logs for errors

**Debug:**
```bash
# From HA SSH terminal
docker exec addon_local_zrok-share zrok status
```

### Connection Drops

**Symptom:** URL works, then stops working

**Causes:**
- Network interruption
- zrok platform maintenance
- Home Assistant restart

**Solutions:**
- Check `auto_restart` is enabled
- Wait 1-2 minutes for auto-reconnect
- Manually restart add-on if needed

### High Latency

**Symptom:** Slow page loads via zrok URL

**Expected:**
- 50-100ms additional latency is normal
- Not suitable for real-time video

**Improvements:**
- Use local network when home (bypass zrok)
- Optimize HA (disable unused integrations)
- Check your internet speed

### Configuration Recovery

**Symptom:** Bad configuration prevents add-on from starting

**Steps:**
1. Stop the add-on (if not already stopped)
2. Go to **Configuration** tab
3. Fix the incorrect settings
4. **Save** the configuration
5. Start the add-on again

**Why this works:**
- Configuration is stored externally by Home Assistant
- You can always edit it, even when add-on is stopped
- No data loss in `/data` volume

---

## FAQ

### Is zrok free?

Yes! zrok offers a free tier with 10 GB/month data transfer. For most Home Assistant usage (UI access, automation control), this is plenty. Heavy media streaming may exceed limits.

### Do I need to open ports on my router?

No! That's the whole point. zrok creates an outbound connection (which works through firewalls/NAT), and the platform routes traffic back through that tunnel.

### What happens if I exceed the free tier limit?

Your share will be paused until the next month. You can upgrade to zrok Pro for higher limits and custom domains.

### Can I use my own domain?

Yes, with zrok Pro you can configure custom domains (e.g., `home.yourdomain.com`).

### Is this as secure as a VPN?

It's based on zero-trust principles (OpenZiti), which many consider superior to traditional VPNs. Traffic is end-to-end encrypted, and there's no network-level access (unlike VPNs which expose your entire local network).

### Does this work with Home Assistant Companion App?

Yes! Configure the app's external URL to your zrok URL, and it will work seamlessly.

### Can I run multiple add-ons?

One add-on creates one zrok share. If you need to share multiple services, install multiple add-ons or use zrok's advanced features.

### What if zrok.io shuts down?

zrok is open-source. You can self-host the entire platform (zrok controller + OpenZiti network) on your own infrastructure.

### Why do I need Basic Auth if Home Assistant has login?

Defense in depth. Basic Auth stops automated scanners and bots before they even reach your Home Assistant login page, reducing attack surface.

### Can I use this in production/commercial settings?

Check zrok's terms of service. For commercial use, consider zrok Pro or self-hosting.

---

## Development

### Building Locally

```bash
# Clone repository
git clone https://github.com/ralf-dev16/hass-zrok
cd hass-zrok/zrok-share

# Build for your architecture
docker build --build-arg BUILD_FROM=ghcr.io/home-assistant/amd64-base:latest -t zrok-share-local .

# Test run
docker run --rm -v /path/to/test/data:/data zrok-share-local
```

### Testing

1. Install add-on locally
2. Configure with test token
3. Verify startup and URL generation
4. Test with/without Basic Auth
5. Test restart scenarios

### Contributing

Contributions welcome! Please:
1. Fork the repository
2. Create a feature branch
3. Test your changes thoroughly
4. Submit a pull request

### Architecture Decisions

**Why external configuration storage?**
- Prevents lock-out scenarios
- Allows editing while add-on is stopped
- Follows HA best practices

**Why single-purpose container?**
- Simple, focused functionality
- Easy to understand and debug
- Follows Docker/containerization best practices

**Why bashio?**
- Standard HA add-on library
- Consistent with other add-ons
- Good logging and config handling

### AI-Assisted Development

This add-on was created with the assistance of **Claude Code** by Anthropic, an AI-powered software engineering tool. The implementation, architecture design, documentation, security considerations, and testing strategies were developed through AI-assisted software engineering practices.

This approach allowed for:
- Rapid prototyping and iteration
- Comprehensive documentation from the start
- Security best practices built-in from day one
- Thorough error handling and edge case consideration

---

## Links and Resources

- **zrok Website:** https://zrok.io
- **zrok Documentation:** https://docs.zrok.io
- **zrok GitHub:** https://github.com/openziti/zrok
- **OpenZiti:** https://openziti.io
- **Home Assistant:** https://www.home-assistant.io
- **This Add-on:** https://github.com/ralf-dev16/hass-zrok

---

**Happy remote accessing!** 🏠🌍🔒
