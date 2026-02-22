# Connecting to Ads MCP

Ads MCP enables AI assistants to manage advertising campaigns across **Google Ads, Meta Ads, TikTok Ads, and LinkedIn Ads** -- 91 tools for campaign creation, keyword research, performance analysis, and optimization.

## Quick Links

- [Connecting to Claude](#connecting-ads-mcp-to-claude)
- [Connecting to Claude Code](#claude-code)
- [Add as Organization Connector](#add-ads-mcp-as-an-organizational-custom-connector-to-claude-owners)
- [Connecting to ChatGPT](#chatgpt)
- [Connecting to Cursor](#cursor)
- [Connecting to OpenAI Codex](#openai-codex)
- [FAQ](#faq)

---

## MCP Remote Server URL

```
https://mcp.adspirer.com/mcp
```

---

## Connecting Ads MCP to Claude

**Your Anthropic admin will have to add Ads MCP as an organization integration before you can add Ads MCP as a connected app.** If you don't see Ads MCP in your list of connections, ask your admin to add it to Claude. [Click here for admin instructions](#add-ads-mcp-as-an-organizational-custom-connector-to-claude-owners).

### End User Authentication

Once Ads MCP is added by your admin:

1. **Start a new Claude chat** (https://claude.ai/new)
2. **Click "Connect apps"** on the bottom right, below the text input
3. **Scroll down and click "Connect"** next to Ads MCP
4. **Authorize via OAuth 2.1:**
   - You'll be redirected to Adspirer's login page
   - Sign in with Google or email
   - Authorize Ads MCP to access your advertising accounts
   - Link your Google Ads, Meta Ads, TikTok Ads, and/or LinkedIn Ads accounts
5. **You're done!** Claude will redirect you back automatically

If you're already logged in to Adspirer, the browser should automatically redirect back to Claude.

### Allowing Tools

The first time Claude tries to use a tool, there will be a popup where you can choose to allow it always or just once.

**Choose "Allow once"** for campaign creation tools to ensure you explicitly confirm any changes to your advertising accounts.

**Tool safety categories:**
- Read-only tools (performance analysis, keyword research, account info)
- Asset management tools (validation, discovery -- no cost)
- Campaign creation tools (creates campaigns -- costs money)

All tools include safety annotations (`readOnlyHint`, `destructiveHint`) so Claude understands which tools modify data.

---

## Add Ads MCP as an Organizational Custom Connector to Claude (Owners)

### Enterprise and Team Plans (Owners and Primary Owners)

**Note:** Only Primary Owners or Owners can enable connectors on Claude for Work plans. Once configured, users individually connect and authenticate.

**Steps:**
1. Navigate to **Settings > Connectors**
2. Toggle to **"Organization connectors"** at the top of the page
3. Locate the **"Connectors"** section
4. Click **"Add custom connector"** at the bottom of the section
5. Enter the connector details:
   - **Name:** Ads MCP
   - **URL:** `https://mcp.adspirer.com/mcp`
   - **Authentication:** OAuth
6. Click **"Add"** to finish configuring your connector
7. Users can now individually connect to Ads MCP in their settings

### Pro and Max Plans

1. Navigate to **Settings > Connectors**
2. Locate the **"Connectors"** section
3. Click **"Add custom connector"** at the bottom of the section
4. Enter the connector details:
   - **Name:** Ads MCP
   - **URL:** `https://mcp.adspirer.com/mcp`
   - **Authentication:** OAuth
5. Click **"Add"** to finish configuring your connector

---

## Connecting to Other AI Assistants

### Claude Code

**Option 1: Full Plugin (Recommended)** — includes brand-aware agent, campaign skills, slash commands, and persistent memory:

1. Open Claude Code in your brand/project folder
2. Run `/plugin marketplace add amekala/ads-mcp`
3. Run `/plugin install adspirer`
4. Run `/mcp` — find **plugin:adspirer:adspirer** and click to authenticate via OAuth
5. Run `/adspirer:setup` — the agent will pull your campaign data and create a brand workspace (CLAUDE.md)

Available commands after setup:
- `/adspirer:setup` — Set up brand workspace
- `/adspirer:performance-review` — Cross-platform performance review
- `/adspirer:write-ad-copy` — Write brand-voice ad copy
- `/adspirer:wasted-spend` — Find and fix wasted spend
- `/adspirer:refresh-brand-context` — Re-scan docs and refresh brand data

**Option 2: MCP-only** — just the raw tools, no agent or skills:

```bash
claude mcp add --transport http adspirer https://mcp.adspirer.com/mcp
```

### ChatGPT

Requires a **Plus or Pro plan**.

1. Open ChatGPT Settings > **Connectors**
2. Click **"Add custom connector"**
3. Enter:
   - **Name:** Ads MCP
   - **URL:** `https://mcp.adspirer.com/mcp`
   - **Authentication:** OAuth 2.1
4. Follow the OAuth flow to authorize Adspirer
5. Link your ad platform accounts

Full instructions: [OpenAI MCP Servers Guide](https://help.openai.com/en/articles/9883373-mcp-servers-with-chatgpt)

### Cursor

Add to your `mcp.json` (global: `~/.cursor/mcp.json` or per-project: `.cursor/mcp.json`):

```json
{
  "mcpServers": {
    "adspirer": {
      "url": "https://mcp.adspirer.com/mcp"
    }
  }
}
```

More on Cursor MCP: [Cursor MCP Docs](https://docs.cursor.com/advanced/mcp)

### OpenAI Codex

Add to `~/.codex/config.toml`:

```toml
[mcp_servers.adspirer]
url = "https://mcp.adspirer.com/mcp"
```

### Relay

Connect Ads MCP to a Relay agent or workflow: [Relay MCP Integration](https://www.relay.app/integrations/mcp)

---

## FAQ

### Do I need a paid plan to use Ads MCP?

Yes, Ads MCP requires an Adspirer account. **Free trial available** at https://www.adspirer.com. After the trial, paid plans start at $29/month.

### Do I need advertising accounts?

Yes, you need active accounts on the platforms you want to manage:
- **Google Ads account** for Google Ads tools (39 tools)
- **Meta Ads account** for Meta Ads tools (20 tools)
- **LinkedIn Ads account** for LinkedIn Ads tools (28 tools)
- **TikTok Ads account** for TikTok Ads tools (4 tools)

Accounts must have billing enabled to create campaigns. You can connect any combination of platforms.

### Is Ads MCP in beta?

No. Ads MCP is in **General Availability (GA)**. The service is production-ready and fully supported.

### What AI assistants work with Ads MCP?

Ads MCP works with any MCP-compatible client:
- **Claude** (Recommended) -- Full support with progress streaming
- **Claude Code** -- Full support
- **ChatGPT** -- Supported (Plus/Pro plans)
- **Cursor** -- Supported
- **OpenAI Codex** -- Supported
- **Relay** -- Supported

### What tools are available?

**91 tools** across 4 platforms:

| Platform | Tools | Key Capabilities |
|----------|-------|-----------------|
| Google Ads | 39 | Keyword research, Search campaigns, Performance Max, performance analysis, asset management, ad extensions (sitelinks, structured snippets) |
| LinkedIn Ads | 28 | Sponsored content, lead gen forms, audience targeting, campaign management, analytics |
| Meta Ads | 20 | Image campaigns, carousel campaigns, audience management, performance tracking |
| TikTok Ads | 4 | In-feed campaigns, asset validation |

Plus 2 resources (account info) and 6 prompts (guided workflows).

### Sample Prompts

**Keyword Research & Planning:**
```
Research keywords for my emergency plumbing business in Chicago.
Show me high-intent keywords with real CPC data and budget recommendations.
```

**Performance Analysis:**
```
Show me campaign performance for the last 30 days across all platforms.
Which campaigns are converting best and what should I optimize?
```

**Campaign Creation:**
```
Create a Google Performance Max campaign for luxury watches targeting
New York with a $50/day budget. Use existing brand assets if available.
```

**LinkedIn Campaigns:**
```
Create a LinkedIn sponsored content campaign targeting marketing directors
at companies with 500+ employees. Budget $100/day for lead generation.
```

**Multi-Platform Strategy:**
```
I want to advertise my SaaS product. Research keywords for Google Ads,
create a LinkedIn campaign targeting decision makers, and set up a
Meta Ads campaign for retargeting website visitors.
```

### Is my data secure?

Yes. Ads MCP uses:
- **OAuth 2.1** with PKCE for secure authentication
- **Dynamic client registration** (RFC 7591) for CLI tools
- **HTTPS/TLS** for all data transmission
- **Encrypted storage** for OAuth tokens
- **No conversation logging** -- only tool requests are processed

See our [Privacy Policy](PRIVACY.md) and [Terms of Service](TERMS.md).

### Who pays for the advertising costs?

**You do.** Ads MCP creates campaigns in your ad platform accounts, which are billed directly by those platforms. Adspirer subscription fees are separate from advertising costs.

### What happens if I disconnect?

1. OAuth tokens are immediately revoked
2. Ads MCP can no longer access your advertising accounts
3. Your existing campaigns continue running normally
4. Your data is deleted per our retention policy (see Privacy Policy)

Your campaigns are owned by you, not by Ads MCP.

### How do I get help?

- **Email:** abhi@adspirer.com (response within 24 hours on business days)
- **Issues:** https://github.com/amekala/ads-mcp/issues
- **Status:** https://mcp.adspirer.com/health
- **Website:** https://www.adspirer.com

---

## Additional Resources

- [Privacy Policy](PRIVACY.md)
- [Terms of Service](TERMS.md)
- [Security](SECURITY.md)
- [Support](SUPPORT.md)

---

**Last Updated:** February 14, 2026
