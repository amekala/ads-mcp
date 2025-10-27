# Ads MCP

Remote Model Context Protocol (MCP) server for campaign planning, research, and cross-platform ad creation. Supports Google Ads Search & Performance Max and TikTok at launch, with additional networks planned.

## Quick Links

- **MCP Remote URL (SSE):** `https://adspirer-mcp-596892545013.us-central1.run.app/`
- **Registry ID:** `com.adspirer/ads`
- **Authentication:** OAuth 2.1 via Adspirer (paid tiers and rate limits enforced server-side)
- **Website:** https://www.adspirer.com/
- **Support:** abhi@adspirer.com

## What it does

- Plan and validate campaigns using structured prompts
- Generate creative variants and assemble compliant asset bundles
- Create Google Ads Search and Performance Max campaigns, and TikTok campaigns, end-to-end from within MCP-capable clients
- Real-time progress updates for long-running operations (5-30 seconds)

## Tools

### Asset Management
- `help_user_upload` — Returns clear instructions for providing direct media links suitable for ingestion
- `validate_and_prepare_assets` — Downloads and validates media from provided URLs; returns an `asset_bundle_id`. **Streams progress** when supported by the client (typically 5-15 seconds for 5-10 images)

### Campaign Creation
- `create_pmax_campaign` — Atomic PMax creation (uses validate-then-commit pattern). **Streams progress** when supported (typically 15-30 seconds)
- `create_search_campaign` — Text-first Search campaign creation with optional assets

## How to Connect

### ChatGPT
1. Open **Settings → Connectors → Create**
2. Name: **Ads MCP**
3. URL: `https://adspirer-mcp-596892545013.us-central1.run.app/`
4. Follow OAuth 2.1 sign-in; you will see **Adspirer** as the application
5. Link your ad accounts on first use
6. Use tools by asking naturally (e.g., "create a PMAX campaign for...")

### Claude
1. Open **Settings → Connectors → Add custom**
2. Name: **Ads MCP**
3. URL: `https://adspirer-mcp-596892545013.us-central1.run.app/`
4. Complete OAuth 2.1 sign-in
5. Invoke tools as needed

## Features

### Progress Streaming (MCP 2025-03-26)
- Protocol version negotiation with clients
- Real-time progress updates via `notifications/progress`
- Deterministic progress fields: stage, current, total, message
- Works with clients that request `_meta.progressToken`

### Security
- HTTPS URLs only; redirect cap applied
- Private and non-routable destinations blocked
- MIME sniffing and content-type checks enforced
- OAuth 2.1 access tokens validated per request
- Least-privilege scopes applied per operation

### Limits & Reliability
- Server-side rate limits vary by paid tier
- Time and size limits enforced per operation
- Image download retry logic (2 attempts on 404)
- User-Agent header for CDN compatibility
- See pricing and terms at https://www.adspirer.com/

## Documentation

- [Quickstart Guide](docs/index.md)
- [ChatGPT Connector Setup](docs/connectors/chatgpt.md)
- [Claude Connector Setup](docs/connectors/claude.md)
- [Troubleshooting](docs/troubleshooting.md)
- [Changelog](docs/changelog.md)

## Technical Details

- **Protocol**: MCP 2025-03-26 (with fallback to 2024-11-05)
- **Transport**: HTTP+SSE with progress streaming
- **OAuth**: RFC 8252 (Authorization Code + PKCE) with RFC 9728 (Protected Resource Metadata)
- **Progress**: Sparse status messages even without progress token
- **Monitoring**: Comprehensive logging with token usage and duration metrics

## Example: Verify Streaming

```bash
curl -i -N https://adspirer-mcp-596892545013.us-central1.run.app/mcp/tools/call \
  -H 'Content-Type: application/json' \
  -d '{
    "jsonrpc":"2.0",
    "id":2,
    "method":"tools/call",
    "params":{
      "name":"validate_and_prepare_assets",
      "_meta":{"progressToken":"tok-123"},
      "arguments":{
        "marketing_images_square":["https://example.com/image.jpg"]
      }
    }
  }'
```

You should see several `event: message` progress frames followed by a final JSON-RPC `result` on the same stream.

## Support

- **Email:** abhi@adspirer.com
- **Website:** https://www.adspirer.com/
- **Issues:** https://github.com/adspirer/ads-mcp/issues

## Security

See [SECURITY.md](SECURITY.md) for vulnerability reporting and security policies.

## License

Proprietary - See website for terms of service
