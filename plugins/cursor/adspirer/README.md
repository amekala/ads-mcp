# Adspirer for Cursor and Grok Bot

Create, analyze, and optimize paid-media campaigns without leaving Cursor. Adspirer connects
Cursor and Grok Bot to live ad accounts on Google Ads, Meta Ads, TikTok Ads, LinkedIn Ads,
Amazon Ads, and ChatGPT Ads through Adspirer's hosted MCP server.

## Install

1. Open **Cursor Settings -> Plugins**.
2. Search for **Adspirer**.
3. Click **Install**, then complete the Adspirer sign-in prompt.

Or run `/add-plugin adspirer` in chat.

On first connection, Cursor opens Adspirer's OAuth flow in the browser. Sign in, then connect
the ad accounts you want to manage at [adspirer.com/connections](https://www.adspirer.com/connections).
No API key or client secret is required.

## Get started

Open a project or brand folder in Cursor and ask:

```text
Set up my brand workspace
```

Adspirer checks your connected accounts, reads relevant brand files in the folder, pulls a live
performance snapshot, and proposes a `BRAND.md` workspace profile. It asks before writing files
and preserves existing project instructions.

You can also ask:

```text
How are my Google and Meta campaigns doing this month?
Find wasted spend across all connected platforms.
Write new Search ad headlines using my best-performing queries.
Plan a LinkedIn campaign for IT directors with a $100 daily budget.
Audit my conversion tracking before I launch anything.
```

## What agents can do

| Area | Capabilities |
| --- | --- |
| Cross-platform reporting | Compare spend, conversions, CPA, ROAS, CTR, and pacing across connected platforms |
| Google Ads | Search, Performance Max, Demand Gen, YouTube, Display, keywords, assets, and extensions |
| Meta Ads | Facebook and Instagram campaigns, audiences, creatives, lead generation, and performance |
| TikTok Ads | In-feed video, Spark Ads, carousel, app promotion, targeting, and analytics |
| LinkedIn Ads | Sponsored content, lead-gen forms, campaign groups, B2B targeting, and reporting |
| Amazon Ads | Sponsored Products, Sponsored Brands, Sponsored Display, search terms, bids, and ACoS |
| ChatGPT Ads | Campaigns, ad groups, creative assets, chat-card ads, and reporting |
| Optimization | Wasted-spend analysis, budget pacing, creative fatigue, and actionable recommendations |

## Included guidance

The plugin includes focused skills for setup, campaign launches, optimization, performance
reviews, creative, each supported ad platform, and the Adspirer MCP call contract. It also ships
a performance-marketing subagent that can use the same live tools with brand context.

The hosted runtime is the source of truth for tool names and schemas. The plugin teaches the
agent how to discover the current tool surface instead of hardcoding every operation.

## Safety

- The agent reads account state and performance before proposing changes.
- New campaigns are created paused.
- Campaign creation, budget changes, bid changes, and other spend-affecting writes require the
  user's explicit approval.
- The agent reads created or changed resources back before reporting success.
- Campaigns are never deleted automatically.

## MCP and authentication

```json
{
  "mcpServers": {
    "adspirer": {
      "type": "http",
      "url": "https://mcp.adspirer.com/mcp"
    }
  }
}
```

Authentication uses OAuth 2.1 with PKCE and dynamic client registration. Cursor handles the
browser sign-in; the plugin contains no API keys, tokens, client secrets, or environment variables.
Ad-platform credentials remain server-side with Adspirer and are scoped to the accounts the user
connects.

## Network and execution surface

The marketplace distribution connects only to `https://mcp.adspirer.com/mcp`. It contains no
hooks, local executables, or bundled server code. Skills, rules, and the subagent are Markdown
guidance loaded by Cursor.

## Support and source

- Website: [adspirer.com](https://www.adspirer.com)
- Connections: [adspirer.com/connections](https://www.adspirer.com/connections)
- Support: [support@adspirer.com](mailto:support@adspirer.com)
- Source and issues: [Adspirer/adspirer-cursor-plugin](https://github.com/Adspirer/adspirer-cursor-plugin)

## License

MIT. See [LICENSE](LICENSE).
