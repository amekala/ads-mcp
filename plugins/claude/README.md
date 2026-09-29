# Adspirer Advertising Agent for Claude

Run your ad campaigns from Claude Code and Cowork. Adspirer connects Claude to your live ad
accounts on Google Ads, Meta Ads (Facebook and Instagram), TikTok Ads, LinkedIn Ads, Amazon Ads,
Microsoft Advertising (Bing), and ChatGPT Ads through Adspirer's hosted MCP server, so you can
research keywords, launch and optimize PPC and paid social campaigns, and report on ROAS, CPA, CTR,
and cost per lead without leaving the conversation.

## Use it for

- **Paid search (PPC):** Google Ads Search and Performance Max, Microsoft Advertising (Bing), keyword
  research with live CPC and search volume, negative keywords, and search term reports.
- **Paid social:** Facebook and Instagram ads, TikTok Spark Ads and in-feed video, LinkedIn B2B lead
  generation, and YouTube and Demand Gen campaigns.
- **Retail and marketplace ads:** Amazon Sponsored Products, Sponsored Brands, and Sponsored Display,
  with ACoS and bid management.
- **Reporting:** cross-platform performance for spend, conversions, ROAS, CPA, CTR, CPC, and cost per
  lead, with pacing against budget.
- **Optimization:** find wasted spend, shift budget to what converts, catch creative fatigue, and
  audit conversion tracking before you scale.
- **Ad copy:** headlines, descriptions, and primary text written to each platform's limits and your
  brand voice.

## Install

In Claude Code:

```text
/plugin marketplace add Adspirer/adspirer-claude-plugin
/plugin install adspirer-advertising-agent@adspirer
```

On first use, Claude opens Adspirer's OAuth sign-in in the browser. Sign in, then connect the ad
accounts you want to manage at [adspirer.ai/connections](https://adspirer.ai/connections). No API
key or client secret is required.

## Get started

Open a project or brand folder and ask:

```text
Set up my brand workspace
```

Adspirer checks your connected accounts, reads relevant brand files in the folder, pulls a live
performance snapshot, and proposes a `CLAUDE.md` brand profile. It asks before writing files and
preserves existing project instructions.

You can also ask:

```text
How are my Google and Meta campaigns doing this month?
Find wasted spend across all connected platforms.
Write new Search ad headlines using my best-performing queries.
Plan a LinkedIn campaign for IT directors with a $100 daily budget.
Audit my conversion tracking before I launch anything.
```

Slash commands: `/setup`, `/performance-review`, `/wasted-spend`, `/write-ad-copy`,
`/refresh-brand-context` (prefixed `/adspirer-advertising-agent:` if another plugin uses the same name).

## What the agent can do

| Area | Capabilities |
| --- | --- |
| Cross-platform reporting | Compare spend, conversions, CPA, ROAS, CTR, and pacing across connected platforms |
| Google Ads | Search, Performance Max, Demand Gen, YouTube, Display, keywords, assets, and extensions |
| Meta Ads | Facebook and Instagram campaigns, audiences, creatives, lead generation, and performance |
| TikTok Ads | In-feed video, Spark Ads, carousel, app promotion, targeting, and analytics |
| LinkedIn Ads | Sponsored content, lead-gen forms, campaign groups, B2B targeting, and reporting |
| Amazon Ads | Sponsored Products, Sponsored Brands, Sponsored Display, search terms, bids, and ACoS |
| Microsoft Advertising | Bing search campaigns, ad groups, ads, keywords, extensions, audiences, budgets, and bids |
| ChatGPT Ads | Campaigns, ad groups, creative assets, chat-card ads, and reporting |
| Optimization | Wasted-spend analysis, budget pacing, creative fatigue, and actionable recommendations |

## What's included

- **Skills** for setup, campaign launches, optimization, performance reviews, creative, each
  supported ad platform, and the Adspirer MCP call contract.
- **A performance-marketing subagent** that uses the same live tools with your brand context.
- **Slash commands** for the most common workflows.
- **The Adspirer MCP server** connection (`.mcp.json`).

The hosted server is the source of truth for tool names and schemas. The plugin teaches the agent
how to discover the current tools instead of hardcoding every operation.

## Safety

- The agent reads account state and performance before proposing changes.
- New campaigns are created paused.
- Campaign creation, budget changes, bid changes, and other spend-affecting writes require your
  explicit approval.
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

Authentication uses OAuth 2.1 with PKCE. Claude handles the browser sign-in; the plugin contains no
API keys, tokens, client secrets, or environment variables. Ad-platform credentials stay
server-side with Adspirer and are scoped to the accounts you connect.

## Network and execution surface

The plugin connects only to `https://mcp.adspirer.com/mcp`. It contains no hooks, scripts, local
executables, or bundled server code. Skills, commands, and the subagent are Markdown guidance.

## Privacy, support, and source

- Privacy policy: [adspirer.com/privacy](https://www.adspirer.com/privacy)
- Website: [adspirer.com](https://www.adspirer.com)
- Support: [support@adspirer.com](mailto:support@adspirer.com)
- Source and issues: [Adspirer/adspirer-claude-plugin](https://github.com/Adspirer/adspirer-claude-plugin)

This repository is generated from [amekala/ads-mcp](https://github.com/amekala/ads-mcp)
(`plugins/claude/`) by a daily sync. Changes to skills, the agent, or commands belong there.

## License

MIT. See [LICENSE](LICENSE).
