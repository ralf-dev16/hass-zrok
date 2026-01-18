# Software Definition Document (SDD)
## zrok Share Add-on for Home Assistant

**Version:** 1.0  
**Date:** January 18, 2026  
**Author:** Ralf  
**Project Status:** Planning/Development

---

## 1. Executive Summary

### 1.1 Project Overview
This project aims to create a Home Assistant Add-on that enables secure remote access to Home Assistant instances via zrok, an open-source zero-trust networking platform. The add-on will provide users with a simple, GUI-based alternative to complex VPN setups or port forwarding configurations.

### 1.2 Problem Statement
Current remote access solutions for Home Assistant require:
- Complex VPN configurations
- Port forwarding and firewall rules
- Paid cloud subscriptions (Nabu Casa)
- Technical knowledge of networking

This add-on solves these problems by providing:
- Zero-configuration remote access
- No port forwarding required
- No VPN setup needed
- Free and open-source solution
- Privacy-focused (self-hosted option available)

### 1.3 Target Audience
- Home Assistant users seeking simple remote access
- Privacy-conscious users avoiding cloud services
- Agricultural/industrial automation users (IoT scenarios)
- Users with dynamic IPs or restrictive ISPs
- Technical users wanting zero-trust networking

---

## 2. Project Objectives

### 2.1 Primary Objectives
1. Create a functional Home Assistant Add-on for zrok integration
2. Provide secure remote access without port forwarding
3. Support optional password protection (Basic Auth)
4. Enable automatic startup and crash recovery
5. Support multi-architecture builds (amd64, arm64, armv7)

### 2.2 Secondary Objectives
1. Implement status monitoring in Home Assistant
2. Add custom domain support (zrok Pro feature)
3. Provide comprehensive logging
4. Create user-friendly documentation
5. Publish to community add-on repository

### 2.3 Success Criteria
- \u2705 Add-on installs successfully on HA OS
- \u2705 Generates working public HTTPS URL
- \u2705 Survives Home Assistant restarts
- \u2705 Works on Raspberry Pi and x86 systems
- \u2705 Basic Auth protection functional
- \u2705 Clear error messages for misconfigurations

---

## 3. Technical Architecture

### 3.1 System Components

```
\u250c\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2510
\u2502           Home Assistant OS                      \u2502
\u2502  \u250c\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2510  \u2502
\u2502  \u2502     zrok Share Add-on (Docker Container)  \u2502  \u2502
\u2502  \u2502                                           \u2502  \u2502
\u2502  \u2502  \u250c\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2510    \u250c\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2510  \u2502  \u2502
\u2502  \u2502  \u2502  run.sh     \u2502\u2500\u2500\u2500\u25b6\u2502  zrok binary    \u2502  \u2502  \u2502
\u2502  \u2502  \u2502  (wrapper)  \u2502    \u2502  (share public) \u2502  \u2502  \u2502
\u2502  \u2502  \u2514\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2518    \u2514\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u252c\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2518  \u2502  \u2502
\u2502  \u2502         \u25b2                     \u2502           \u2502  \u2502
\u2502  \u2502         \u2502                     \u2502           \u2502  \u2502
\u2502  \u2502    \u250c\u2500\u2500\u2500\u2500\u2534\u2500\u2500\u2500\u2500\u2500\u2510               \u2502           \u2502  \u2502
\u2502  \u2502    \u2502config.yaml\u2502              \u2502           \u2502  \u2502
\u2502  \u2502    \u2502(user conf)\u2502              \u2502           \u2502  \u2502
\u2502  \u2502    \u2514\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2518               \u2502           \u2502  \u2502
\u2502  \u2514\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u253c\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2518  \u2502
\u2502                                  \u2502              \u2502
\u2502  \u250c\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u25bc\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2510  \u2502
\u2502  \u2502   Home Assistant Core (localhost:8123)    \u2502  \u2502
\u2502  \u2514\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2518  \u2502
\u2514\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2518
                    \u2502
                    \u2502 Encrypted Tunnel
                    \u25bc
         \u250c\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2510
         \u2502  zrok.io Platform    \u2502
         \u2502  (OpenZiti Network)  \u2502
         \u2514\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u252c\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2518
                    \u2502
                    \u2502 HTTPS
                    \u25bc
         \u250c\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2510
         \u2502   End User Browser   \u2502
         \u2502  (Any Device)        \u2502
         \u2514\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2518
```

### 3.2 Technology Stack

**Core Technologies:**
- **Container Base:** Home Assistant Base Images (Alpine Linux)
- **Networking:** zrok (OpenZiti-based)
- **Scripting:** Bash (run.sh wrapper)
- **Configuration:** YAML (Home Assistant standard)
- **Build System:** Docker, GitHub Actions

**Dependencies:**
- zrok binary (latest from GitHub releases)
- curl (for downloads)
- jq (for JSON parsing)
- bash (for scripting)
- bashio (HA helper library)

### 3.3 Architecture Patterns

**Container Pattern:** Single-purpose container
- One add-on = one zrok share instance
- Stateless design (configuration via HA)
- Restart-safe (environment persists)

**Configuration Pattern:** Declarative YAML
- User-friendly options in HA UI
- Schema validation
- Secure password handling

---

## 4. Functional Requirements

### 4.1 Core Features

#### FR-1: Add-on Installation
- **Priority:** Critical
- **Description:** User can install add-on from repository
- **Acceptance Criteria:**
  - Add-on appears in Add-on Store
  - Installation completes without errors
  - Configuration UI is accessible

#### FR-2: zrok Token Configuration
- **Priority:** Critical
- **Description:** User can configure zrok invitation token
- **Acceptance Criteria:**
  - Token field in configuration
  - Validation of token format
  - Clear error if token is invalid/missing

#### FR-3: Public HTTPS Share
- **Priority:** Critical
- **Description:** Generate public HTTPS URL for Home Assistant
- **Acceptance Criteria:**
  - URL generated on add-on start
  - URL visible in logs
  - URL accessible from internet
  - HTTPS certificate valid

#### FR-4: Password Protection
- **Priority:** High
- **Description:** Optional Basic Authentication
- **Acceptance Criteria:**
  - Username/password configurable
  - Auth prompt appears before HA login
  - Incorrect credentials rejected
  - Empty credentials = no auth

#### FR-5: Auto-Restart
- **Priority:** High
- **Description:** Add-on survives crashes and restarts
- **Acceptance Criteria:**
  - Automatic restart on failure
  - Survives HA system restarts
  - Re-enables zrok if needed
  - Same URL maintained (if possible)

#### FR-6: Multi-Architecture Support
- **Priority:** High
- **Description:** Runs on multiple CPU architectures
- **Acceptance Criteria:**
  - Works on amd64 (x86_64)
  - Works on aarch64 (ARM 64-bit)
  - Works on armv7 (Raspberry Pi)

### 4.2 Configuration Options

```yaml
zrok_token: string (required)
  # Token from zrok.io invitation

backend_url: string (default: "http://homeassistant:8123")
  # Internal Home Assistant URL

basic_auth_username: string (optional)
  # Username for Basic Auth

basic_auth_password: password (optional)
  # Password for Basic Auth (secured in HA)

share_mode: string (default: "public")
  # Future: private, reserved

auto_restart: boolean (default: true)
  # Auto-restart on failure

log_level: string (default: "info")
  # Logging verbosity: debug, info, warn, error
```

### 4.3 User Workflows

#### Workflow 1: First-Time Setup
1. User installs add-on from repository
2. User visits zrok.io and creates account
3. User receives invitation token via email
4. User opens add-on configuration
5. User pastes token
6. User optionally sets username/password
7. User starts add-on
8. User copies public URL from logs
9. User accesses Home Assistant via URL

#### Workflow 2: Daily Usage
1. Add-on runs automatically (boot: auto)
2. User accesses HA via saved bookmark
3. User enters Basic Auth (if configured)
4. User logs into Home Assistant normally

#### Workflow 3: Troubleshooting
1. User notices connection issues
2. User checks add-on logs
3. Logs show clear error message
4. User fixes configuration
5. User restarts add-on
6. Connection restored

---

## 5. Non-Functional Requirements

### 5.1 Performance

**NFR-1: Startup Time**
- Add-on starts within 30 seconds
- zrok share established within 60 seconds

**NFR-2: Latency**
- Additional latency < 100ms (typical)
- Acceptable for UI interaction
- Not suitable for real-time video

**NFR-3: Resource Usage**
- Memory: < 50 MB idle
- CPU: < 5% average
- Disk: < 100 MB total

### 5.2 Security

**NFR-4: Authentication**
- Support for Basic Auth (RFC 7617)
- Passwords stored securely by HA
- HTTPS enforced (via zrok)

**NFR-5: Zero-Trust Architecture**
- End-to-end encryption (OpenZiti)
- No open ports on router
- Certificate-based authentication

**NFR-6: Privacy**
- No data stored on zrok servers (encrypted tunnel only)
- Optional self-hosted zrok controller
- Logs contain no sensitive data

### 5.3 Reliability

**NFR-7: Availability**
- Auto-restart on crash
- Graceful handling of network issues
- Clear error messages

**NFR-8: Compatibility**
- Works with HA OS, Supervised, Container
- Compatible with HA versions 2023.x+
- Forward-compatible with zrok updates

### 5.4 Usability

**NFR-9: Documentation**
- README with setup instructions
- Configuration examples
- Troubleshooting guide
- FAQ section

**NFR-10: Error Handling**
- User-friendly error messages
- Actionable suggestions
- Logs visible in HA interface

---

## 6. File Structure

```
ha-addons/
\u251c\u2500\u2500 .github/
\u2502   \u2514\u2500\u2500 workflows/
\u2502       \u251c\u2500\u2500 builder.yaml           # Multi-arch build workflow
\u2502       \u251c\u2500\u2500 lint.yaml              # Code quality checks
\u2502       \u2514\u2500\u2500 release.yaml           # Release automation
\u2502
\u251c\u2500\u2500 zrok-share/                    # Main add-on directory
\u2502   \u251c\u2500\u2500 config.yaml                # Add-on manifest
\u2502   \u251c\u2500\u2500 Dockerfile                 # Container definition
\u2502   \u251c\u2500\u2500 build.json                 # Build configuration
\u2502   \u251c\u2500\u2500 run.sh                     # Startup script
\u2502   \u251c\u2500\u2500 README.md                  # User documentation
\u2502   \u251c\u2500\u2500 DOCS.md                    # Detailed documentation
\u2502   \u251c\u2500\u2500 CHANGELOG.md               # Version history
\u2502   \u251c\u2500\u2500 icon.png                   # Add-on icon (256x256)
\u2502   \u2514\u2500\u2500 logo.png                   # Repository logo
\u2502
\u251c\u2500\u2500 repository.yaml                # Repository metadata
\u251c\u2500\u2500 README.md                      # Repository overview
\u2514\u2500\u2500 LICENSE                        # Open source license (Apache 2.0)
```

---

## 7. Development Phases

### Phase 1: MVP (Minimum Viable Product)
**Timeline:** Week 1-2  
**Goals:**
- \u2705 Basic add-on structure
- \u2705 zrok token configuration
- \u2705 Public share working
- \u2705 Manual testing on amd64

**Deliverables:**
- Functional add-on (local install)
- Basic documentation
- Test on developer's HA instance

### Phase 2: Enhancement
**Timeline:** Week 3-4  
**Goals:**
- \u2705 Basic Auth implementation
- \u2705 Auto-restart logic
- \u2705 Multi-arch builds (GitHub Actions)
- \u2705 Improved logging

**Deliverables:**
- GitHub repository with CI/CD
- Multi-architecture Docker images
- Comprehensive README

### Phase 3: Polish
**Timeline:** Week 5-6  
**Goals:**
- \u2705 Icon and branding
- \u2705 Advanced configuration options
- \u2705 Status sensor (optional)
- \u2705 Testing on multiple platforms

**Deliverables:**
- Production-ready add-on
- Complete documentation
- Community repository submission

### Phase 4: Community Release
**Timeline:** Week 7+  
**Goals:**
- \u2705 Publish to community repository
- \u2705 Gather user feedback
- \u2705 Bug fixes and improvements
- \u2705 Feature requests handling

**Deliverables:**
- Public release
- Community support
- Ongoing maintenance

---

## 8. GitHub Actions CI/CD

### 8.1 Build Pipeline

**Trigger Events:**
- Push to `main` branch \u2192 Test build
- Pull request \u2192 Test build
- New tag `v*` \u2192 Release build
- Manual workflow dispatch

**Build Matrix:**
```yaml
architectures:
  - amd64
  - aarch64
  - armv7
```

**Build Steps:**
1. Checkout code
2. Parse add-on configuration
3. Set up QEMU (for cross-compilation)
4. Set up Docker Buildx
5. Build Docker image per architecture
6. Run tests (optional)
7. Push to GitHub Container Registry (on release)
8. Create GitHub Release

### 8.2 Quality Gates

**Pre-commit Checks:**
- YAML syntax validation
- Dockerfile linting (hadolint)
- Shell script checking (shellcheck)
- Markdown linting

**Build Checks:**
- All architectures build successfully
- Images size within limits (< 200 MB)
- No critical vulnerabilities (Trivy scan)

**Release Checks:**
- Version number updated
- CHANGELOG.md updated
- Documentation complete

---

## 9. Testing Strategy

### 9.1 Unit Testing
- Shell script validation (shellcheck)
- Configuration schema validation
- Dockerfile best practices (hadolint)

### 9.2 Integration Testing
- Manual testing on developer HA instance
- Test on multiple architectures
- Test with/without Basic Auth
- Test restart scenarios

### 9.3 User Acceptance Testing
- Community beta testing
- Feedback collection via GitHub issues
- Documentation clarity testing

### 9.4 Test Scenarios

**Scenario 1: Fresh Installation**
- Install add-on
- Configure token
- Start add-on
- Verify URL generated
- Access from external network

**Scenario 2: With Authentication**
- Configure username/password
- Start add-on
- Verify auth prompt appears
- Test correct/incorrect credentials

**Scenario 3: Restart Resilience**
- Add-on running
- Restart Home Assistant
- Verify add-on restarts
- Verify URL still works

**Scenario 4: Error Handling**
- Start without token \u2192 clear error
- Invalid token \u2192 clear error
- Network down \u2192 graceful handling

---

## 10. Dependencies

### 10.1 External Dependencies

**zrok:**
- Source: https://github.com/openziti/zrok
- Version: Latest stable
- License: Apache 2.0
- Update strategy: Manual, track releases

**Home Assistant Base Images:**
- Source: ghcr.io/home-assistant/
- Versions: amd64-base, aarch64-base, armv7-base
- Update strategy: Automatic (Renovate bot)

**bashio:**
- Included in HA base images
- Provides HA-specific shell functions

### 10.2 Service Dependencies

**zrok.io Platform:**
- Free tier: 10 GB/month transfer
- Provides: Token generation, OpenZiti network
- Fallback: Self-hosted zrok controller

**GitHub:**
- Repository hosting
- GitHub Container Registry (ghcr.io)
- GitHub Actions (CI/CD)

---

## 11. Security Considerations

### 11.1 Threat Model

**Threats:**
1. Unauthorized access to Home Assistant
2. Man-in-the-middle attacks
3. zrok token compromise
4. Credential brute-force

**Mitigations:**
1. Basic Auth + HA authentication (2 layers)
2. HTTPS enforced, OpenZiti encryption
3. Token stored securely by HA, not in logs
4. Rate limiting by zrok platform

### 11.2 Security Best Practices

**Code Security:**
- No hardcoded credentials
- Input validation for all config
- Secure password handling
- Minimal attack surface

**Operational Security:**
- Recommend strong passwords
- Document 2FA setup in HA
- Warn about public exposure
- Suggest private shares for sensitive data

### 11.3 Compliance

**Data Privacy:**
- GDPR-friendly (no PII collected)
- Data remains encrypted in transit
- Optional self-hosting

**Open Source:**
- Apache 2.0 license
- Transparent code
- Community audit possible

---

## 12. Documentation Plan

### 12.1 User Documentation

**README.md:**
- Quick start guide
- Installation instructions
- Configuration examples
- Basic troubleshooting

**DOCS.md:**
- Detailed feature explanation
- Advanced configuration
- Architecture overview
- Security considerations
- FAQ

**CHANGELOG.md:**
- Version history
- Breaking changes
- New features
- Bug fixes

### 12.2 Developer Documentation

**Contributing Guide:**
- Development setup
- Code style guidelines
- Pull request process
- Testing requirements

**Architecture Document:**
- System design
- Component interaction
- Extension points
- API documentation (if applicable)

---

## 13. Maintenance Plan

### 13.1 Update Strategy

**Regular Updates:**
- Monthly dependency checks
- zrok version updates (quarterly)
- Home Assistant compatibility testing
- Security patches (as needed)

**Versioning:**
- Semantic versioning (MAJOR.MINOR.PATCH)
- MAJOR: Breaking changes
- MINOR: New features
- PATCH: Bug fixes

### 13.2 Support Channels

**Primary:**
- GitHub Issues (bug reports, features)
- GitHub Discussions (questions, ideas)

**Community:**
- Home Assistant Community Forum
- Discord (optional)

**Response Time:**
- Critical bugs: 24-48 hours
- Feature requests: Best effort
- Questions: 1-7 days

---

## 14. Success Metrics

### 14.1 Adoption Metrics
- GitHub stars: > 50 (6 months)
- Installations: > 100 active users
- Community repository approval

### 14.2 Quality Metrics
- Bug reports: < 5 open critical bugs
- Build success rate: > 95%
- User satisfaction: > 4.0/5.0

### 14.3 Performance Metrics
- Startup time: < 60 seconds
- Memory usage: < 50 MB
- Crash rate: < 1% of startups

---

## 15. Risk Assessment

### 15.1 Technical Risks

| Risk | Probability | Impact | Mitigation |
|------|------------|--------|------------|
| zrok API changes | Medium | High | Version pinning, monitor releases |
| Multi-arch build fails | Low | Medium | Extensive CI testing |
| HA compatibility break | Low | High | Test on beta versions |
| Docker registry issues | Low | Medium | Mirror to Docker Hub |

### 15.2 Operational Ris