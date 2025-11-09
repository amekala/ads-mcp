# Connecting to Ads MCP

Ads MCP's Model Context Protocol server enables AI clients to research keywords, analyze campaign performance, and create Google Ads and TikTok advertising campaigns with real-time progress updates.

## Quick Links

- [Connecting Ads MCP to Claude](#connecting-ads-mcp-to-claude-end-users)
- [Add Ads MCP as an Organizational Custom Connector](#add-ads-mcp-as-an-organizational-custom-connector-to-claude-owners)
- [Connecting to other agents (ChatGPT)](#connecting-to-other-agents-chatgpt-cursor-relay)
- [FAQ](#faq)

---

## Connecting Ads MCP to Claude

### MCP Remote Server URL

```
https://mcp.adspirer.com/mcp
```

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
   - Link your Google Ads and/or TikTok Ads accounts
5. **You're done!** Claude will redirect you back automatically

💡 **If you're already logged in to Adspirer**, the browser should automatically redirect back to Claude. If you're not logged in, you'll need to sign in on the Adspirer authorization screen.

### Allowing Tools

The first time Claude tries to use a tool, there will be a popup where you can choose to allow it always or just once.

⚠️ **Choose "Allow once"** for campaign creation tools (`create_pmax_campaign`, `create_search_campaign`, `create_tiktok_campaign`) to ensure you can explicitly confirm any actual changes to your advertising accounts.

**Most other tools are read-only:**
- ✅ `get_campaign_performance` - Read-only
- ✅ `research_keywords` - Read-only
- ✅ `discover_existing_assets` - Read-only
- ✅ `discover_tiktok_assets` - Read-only
- ✅ `help_user_upload` - Read-only
- ⚠️ `create_search_campaign` - Creates campaigns (costs money)
- ⚠️ `create_pmax_campaign` - Creates campaigns (costs money)
- ⚠️ `create_tiktok_campaign` - Creates campaigns (costs money)
- 🔧 `validate_and_prepare_assets` - Validates images (no cost)
- 🔧 `validate_and_prepare_tiktok_assets` - Validates images (no cost)

---

## Add Ads MCP as an Organizational Custom Connector to Claude (Owners)

### Enterprise and Team Plans (Owners and Primary Owners)

**Note:** While anyone can build and host connectors using remote MCP, only Primary Owners or Owners can enable it on Claude for Work plans (Team and Enterprise). Once a connector has been configured on a Team or Enterprise organization, users individually connect to and enable that connector. This ensures that Claude can only access tools and data that the individual user has access to.

**Steps:**
1. Navigate to **Settings → Connectors**
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

1. Navigate to **Settings → Connectors**
2. Locate the **"Connectors"** section
3. Click **"Add custom connector"** at the bottom of the section
4. Enter the connector details:
   - **Name:** Ads MCP
   - **URL:** `https://mcp.adspirer.com/mcp`
   - **Authentication:** OAuth
5. Click **"Add"** to finish configuring your connector

---

## Connecting to Other Agents (ChatGPT, Cursor, Relay)

Although we recommend using Ads MCP in Claude, our remote server works anywhere that supports the full MCP protocol. These clients are rapidly evolving and may require some experimentation.

### ChatGPT

As of November 2024, OpenAI has added support for custom MCP servers for users with a **Plus or Pro plan** (ChatGPT web client).

**To connect:**
1. Open ChatGPT Settings → **Connectors**
2. Click **"Add custom connector"**
3. Enter:
   - **Name:** Ads MCP
   - **URL:** `https://mcp.adspirer.com/mcp`
   - **Authentication:** OAuth 2.1
4. Follow the OAuth flow to authorize Adspirer
5. Link your Google Ads and/or TikTok accounts

**Tip:** Unlike Claude's implementation of MCP, ChatGPT may be more conservative in which tools it calls automatically. You may need to explicitly ask ChatGPT to use the Ads MCP tools (e.g., "Use the research_keywords tool to...").

Full instructions to connect to ChatGPT are [here](https://help.openai.com/en/articles/9883373-mcp-servers-with-chatgpt).

### Cursor

Manage advertising campaigns directly in your code editor. You can add Ads MCP using this configuration in your `mcp.json`:

```json
"Ads MCP": {
  "url": "https://mcp.adspirer.com/mcp",
  "headers": {}
}
```

More on how to use MCP tools in Cursor [here](https://docs.cursor.com/advanced/mcp).

### Relay

You can connect Ads MCP to a Relay agent or use specific Ads MCP tools in Relay workflows by following the instructions [here](https://www.relay.app/integrations/mcp).

---

## FAQ

### Do I need a paid plan to use Ads MCP?

Yes, Ads MCP requires an Adspirer account. **Free trial available** at https://www.adspirer.com. After the trial, paid plans start at $29/month.

### Do I need advertising accounts to use Ads MCP?

Yes, you need:
- **Google Ads account** (for Google Ads campaign tools)
- **TikTok Ads account** (for TikTok campaign tools)
- Accounts must have **billing enabled** to create campaigns

You can connect either or both platforms depending on your needs.

### Is Ads MCP in beta?

Ads MCP is in **General Availability (GA)**. The service is production-ready and fully supported. However, MCP protocol support across different AI assistants is still evolving.

### What AI agents can I connect to Ads MCP?

Ads MCP works with any MCP-compatible client:
- **Claude** (Recommended) - Full support with progress streaming
- **ChatGPT** - Supported (Plus/Pro plans)
- **Cursor** - Supported
- **Relay** - Supported
- **Claude Code** - Supported

### Do I need a paid AI agent account to connect to Ads MCP?

Each platform has different requirements:
- **Claude:** MCP support is included on Pro, Team, and Enterprise plans
- **ChatGPT:** MCP support requires Plus or Pro plan
- **Cursor:** MCP support included in paid plans
- **Claude Code:** MCP support included

### What use cases can I use with Ads MCP?

The possibilities are endless, but here are some examples to get you started:

#### 🔌 Sample Prompts Using Ads MCP in Claude:

**Keyword Research & Planning:**
```
"Research keywords for my emergency plumbing business in Chicago.
Show me high-intent keywords with real CPC data and budget recommendations."
```

**Performance Analysis:**
```
"Show me campaign performance for the last 30 days.
Which keywords are converting best and what optimization opportunities do you see?"
```

**Campaign Creation:**
```
"Create a Google Performance Max campaign for luxury watches targeting
New York with a $50/day budget. Use existing brand assets if available,
otherwise I'll upload new images."
```

**Multi-Platform Strategy:**
```
"I want to advertise my handmade jewelry business. Research keywords for
Google Ads and create both a Search campaign and a TikTok In-Feed campaign
with complementary targeting strategies."
```

**Competitive Analysis:**
```
"Research keywords for 'organic dog food' and tell me what the competitive
landscape looks like based on CPC data. Should I focus on high-intent or
broader terms for my budget?"
```

#### 🔌 Advanced Workflows (Multi-Tool):

**Complete Campaign Launch:**
```
"Help me launch a new product campaign:
1. Research keywords for premium coffee makers
2. Analyze my current campaign performance to understand what's working
3. Create a new Performance Max campaign with optimized targeting
4. Set it to PAUSED so I can review before going live"
```

### What tools are available in Ads MCP?

**Keyword Research & Analysis:**
- `research_keywords` - Google Keyword Planner API with CPC data and intent analysis
- `get_campaign_performance` - Performance metrics with optimization recommendations

**Campaign Creation:**
- `create_search_campaign` - Build complete Search campaigns with ad groups, keywords, ads
- `create_pmax_campaign` - Create Performance Max campaigns with asset groups
- `create_tiktok_campaign` - Launch TikTok In-Feed image ad campaigns

**Asset Management:**
- `help_user_upload` - Instructions for uploading images
- `validate_and_prepare_assets` - Validate Google Ads assets (images, aspect ratios)
- `validate_and_prepare_tiktok_assets` - Validate TikTok assets
- `discover_existing_assets` - Browse existing assets in Google Ads
- `discover_tiktok_assets` - Browse existing assets in TikTok

**Account Management:**
- Resources: Account information, campaign lists

### Does Ads MCP support progress updates?

Yes! Ads MCP implements **MCP 2025-03-26** with progress streaming:
- Campaign creation shows real-time status (typically 15-30 seconds)
- Asset validation streams progress for multiple images (5-15 seconds)
- Keyword research provides live updates (3-8 seconds)

You'll see progress messages in Claude during long-running operations.

### Is my data secure?

Yes. Ads MCP uses:
- **OAuth 2.1** with PKCE for secure authentication
- **HTTPS/TLS** for all data transmission
- **Encrypted storage** for OAuth tokens
- **No conversation logging** - We only process tool requests, not full chat history

See our [Privacy Policy](https://github.com/amekala/ads-mcp/blob/main/PRIVACY.md) and [Terms of Service](https://github.com/amekala/ads-mcp/blob/main/TERMS.md) for details.

### Who pays for the advertising costs?

**You do.** Ads MCP creates campaigns in your Google Ads and TikTok accounts, which are billed directly by those platforms. Ads MCP does not process payments or control your ad spend.

- Google Ads bills you based on your campaign budgets and performance
- TikTok bills you separately based on TikTok campaign spend
- Adspirer subscription fees are separate from advertising costs

### Can Ads MCP delete or modify existing campaigns?

**No.** Ads MCP only creates new campaigns and retrieves performance data. It cannot:
- ❌ Delete existing campaigns
- ❌ Pause running campaigns
- ❌ Modify campaign budgets
- ❌ Edit existing ads or keywords

**Safety by design:** All campaign creation tools are marked with `_destructiveHint: false`.

### What happens if I disconnect Ads MCP?

When you disconnect:
1. OAuth tokens are immediately revoked
2. Ads MCP can no longer access your advertising accounts
3. Your existing campaigns continue running normally in Google Ads/TikTok
4. Your data is deleted per our retention policy (see Privacy Policy)

**Your campaigns are owned by you**, not by Ads MCP. Disconnecting only removes our access.

### How do I get help or report issues?

**Email:** abhi@adspirer.com
**Response Time:** Within 24 hours on business days
**Bug Reports:** https://github.com/amekala/ads-mcp/issues
**Documentation:** https://github.com/amekala/ads-mcp
**Status:** Check https://mcp.adspirer.com/health for server status

---

## Additional Resources

- **GitHub Repository:** https://github.com/amekala/ads-mcp
- **Privacy Policy:** https://github.com/amekala/ads-mcp/blob/main/PRIVACY.md
- **Terms of Service:** https://github.com/amekala/ads-mcp/blob/main/TERMS.md
- **Troubleshooting:** https://github.com/amekala/ads-mcp/blob/main/docs/troubleshooting.md
- **Website:** https://www.adspirer.com

---

**Last Updated:** January 9, 2025
