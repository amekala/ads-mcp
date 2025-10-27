# Security Policy

## Reporting Vulnerabilities

**Email:** abhi@adspirer.com
**Response Time:** Within 48 hours

Please include:
- Description of the vulnerability
- Steps to reproduce
- Potential impact
- Suggested fix (if any)

## Security Measures

### URL Fetching
- HTTPS required for all public endpoints
- Block private/loopback/link-local addresses
- Cap redirects (≤5)
- Enforce per-URL and overall timeouts
- Size limits enforced (10MB per image)

### MIME Sniffing
- Reject unexpected content types for a given tool
- Validate Content-Type headers
- Test image validity with PIL before accepting

### OAuth 2.1
- Bearer tokens validated per request
- Least-privilege scopes applied per operation
- Refresh token rotation enforced
- PKCE required for all flows

### Logging
- Logs exclude secrets and access tokens
- Correlation identifiers used for tracing
- Token usage and duration metrics logged

## Supported Versions

| Version | Supported          |
| ------- | ------------------ |
| 1.0.x   | :white_check_mark: |

## Disclosure Policy

We follow responsible disclosure practices:
1. Report received and acknowledged
2. Investigation and fix development
3. Coordinated disclosure after fix deployment
4. Credit to reporter (unless anonymity requested)
