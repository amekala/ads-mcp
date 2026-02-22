# Adspirer Performance Marketing Agent for OpenAI Codex

Brand-aware paid media management across Google Ads, Meta Ads, LinkedIn Ads, and TikTok Ads — powered by the Adspirer MCP server (100+ tools).

## What This Does

This plugin turns Codex into a **brand-specific paid media analyst** that:

- **Knows your brand** — scans your local docs (guidelines, media plans, briefs) to understand voice, audience, products
- **Has live data** — connects to your actual ad accounts via Adspirer for real-time performance data
- **Manages campaigns** — creates, analyzes, and optimizes campaigns across 4 platforms
- **Bootstraps itself** — on first use, it reads your folder + pulls live data to build brand context automatically

## Prerequisites

- [OpenAI Codex CLI](https://github.com/openai/codex) installed and working
- An Adspirer account at [adspirer.com](https://www.adspirer.com) with at least one ad platform connected (Google Ads, Meta Ads, LinkedIn Ads, or TikTok Ads)

---

## First-Time Setup (5 minutes)

### Step 1: Clone or download the plugin files

```bash
git clone https://github.com/amekala/ads-mcp.git
cd ads-mcp/plugins/codex/adspirer
```

### Step 2: Install skills

Copy the skills to your home directory so Codex can find them globally:

```bash
# Create the skills directory if it doesn't exist
mkdir -p ~/.agents/skills

# Copy all Adspirer skills
cp -r skills/adspirer-ads ~/.agents/skills/
cp -r skills/adspirer-setup ~/.agents/skills/
cp -r skills/adspirer-performance-review ~/.agents/skills/
cp -r skills/adspirer-write-ad-copy ~/.agents/skills/
cp -r skills/adspirer-wasted-spend ~/.agents/skills/
```

### Step 3: Add the Adspirer MCP server

```bash
codex mcp add adspirer --url https://mcp.adspirer.com/mcp
```

This registers the Adspirer MCP server with Codex.

### Step 4: (Optional) Install agent configuration

If you want the full agent role with multi-agent support:

```bash
# Copy agent config
mkdir -p ~/.codex/agents
cp agents/performance-marketing-agent.toml ~/.codex/agents/

# Copy safety rules
mkdir -p ~/.codex/rules
cp rules/campaign-safety.rules ~/.codex/rules/
```

Then add the agent role to your `~/.codex/config.toml` (create the file if it doesn't exist):

```toml
[features]
multi_agent = true

[agents.performance-marketing-agent]
description = "Brand-specific performance marketing agent. Use when the user asks about ad campaigns, campaign performance, budget optimization, keyword research, ad copy, audience targeting, or anything related to Google Ads, Meta Ads, LinkedIn Ads, or TikTok Ads."
config_file = "agents/performance-marketing-agent.toml"
```

> **Note:** If you already have a `config.toml`, merge these sections with your existing configuration. The `[mcp_servers.adspirer]` section is already handled by `codex mcp add` in Step 3.

### Step 5: Restart Codex

```bash
# Close and reopen Codex for changes to take effect
codex
```

### Step 6: Authenticate with Adspirer

On first use, Codex will open a browser window for Adspirer OAuth authentication:

1. Sign in with your Adspirer account
2. Authorize Codex to access your ad accounts
3. Return to Codex — you're authenticated

You can verify the connection by checking `/mcp` in Codex or asking:
```
Check which ad platforms are connected
```

---

## First Use: Brand Workspace Setup

Navigate to your brand's folder and start Codex:

```bash
cd ~/Clients/Acme    # your brand folder (can have docs, or be empty)
codex
```

Then say:

```
Set up my brand workspace
```

or use the skill directly:

```
$adspirer-setup
```

The agent will:
1. Connect to your Adspirer ad accounts
2. Scan the folder for any brand docs (PDFs, media plans, guidelines, etc.)
3. Pull live campaign data from all connected platforms
4. Generate an `AGENTS.md` file with your brand context, performance snapshot, and KPI targets
5. Present a summary and ask what you'd like to work on

### What goes in your brand folder?

Drop any brand-relevant files — the agent reads them all:

```
~/Clients/Acme/
├── brand-guidelines.pdf       # Brand voice, logo usage, tone
├── Q1-media-plan.xlsx         # Budget, targets, timeline
├── campaign-notes.docx        # Past campaign strategy notes
├── competitor-analysis.pdf    # Competitive landscape
└── audience-research.csv      # Target audience data
```

More docs = better brand context = better ad copy and recommendations.

---

## Available Skills

| Skill | Invocation | What it does |
|-------|-----------|--------------|
| **Adspirer Ads** | `$adspirer-ads` or just ask naturally | Full campaign management — 100+ tools, all workflows, all platforms |
| **Setup** | `$adspirer-setup` | Bootstrap a brand workspace (first-time or refresh) |
| **Performance Review** | `$adspirer-performance-review` | Cross-platform performance scorecard |
| **Write Ad Copy** | `$adspirer-write-ad-copy Google Search` | Brand-voice ad copy from real data |
| **Wasted Spend** | `$adspirer-wasted-spend` | Find and fix wasted ad spend |

You don't need to remember skill names — just describe what you want and Codex will match the right skill automatically.

## Example Prompts

```
How are my Google Ads campaigns doing?
Find wasted spend across all platforms
Write new headlines for my Google Search campaigns
Create a LinkedIn campaign targeting IT Directors
What keywords should I bid on for my plumbing business?
Set up weekly performance alerts
Compare my Google and Meta ad performance
```

---

## File Structure

```
plugins/codex/adspirer/
├── .codex/
│   └── config.toml                          # Codex config (MCP + agent role)
├── agents/
│   ├── openai.yaml                          # Plugin UI config
│   └── performance-marketing-agent.toml     # Agent instructions + config
├── skills/
│   ├── adspirer-ads/                        # Core skill (100+ tools, all workflows)
│   │   ├── SKILL.md
│   │   └── agents/openai.yaml
│   ├── adspirer-setup/                      # Workspace bootstrap
│   │   └── SKILL.md
│   ├── adspirer-performance-review/         # Quick: performance scorecard
│   │   └── SKILL.md
│   ├── adspirer-write-ad-copy/              # Quick: brand-voice ad copy
│   │   └── SKILL.md
│   └── adspirer-wasted-spend/               # Quick: find wasted spend
│       └── SKILL.md
├── rules/
│   └── campaign-safety.rules               # Safety rules (prevents direct API calls)
├── assets/
│   ├── adspirer-small.svg
│   └── adspirer.png
└── README.md                               # This file
```

## Architecture

```
Codex (CLI / IDE)
│
├── Performance Marketing Agent (brain)
│   ├── Reads: AGENTS.md (brand context), local docs
│   ├── Uses: Adspirer MCP (100+ tools)
│   └── Workflows: campaign creation, performance analysis,
│       keyword research, optimization, ad copy, competitive intel
│
├── Skills (playbooks)
│   ├── adspirer-ads — full tool orchestration
│   ├── adspirer-setup — workspace bootstrap
│   └── Quick skills — performance-review, write-ad-copy, wasted-spend
│
└── Adspirer MCP Server (hands)
    ├── Google Ads tools
    ├── Meta Ads tools
    ├── LinkedIn Ads tools
    ├── TikTok Ads tools
    └── Account + monitoring tools
```

## Supported Platforms

| Platform | Tools | Capabilities |
|----------|-------|-------------|
| Google Ads | 39+ | Search campaigns, PMax, keywords, bidding, ad extensions, budget optimization |
| LinkedIn Ads | 28+ | Image campaigns, audience insights, creative performance, B2B targeting |
| Meta Ads | 20+ | Campaign management, audience analysis, creative fatigue detection, placements |
| TikTok Ads | 4+ | Video campaigns, asset management |

## Safety

- All new campaigns are created in **PAUSED** status
- The agent **always asks for confirmation** before creating campaigns or changing budgets
- Shell-level safety rules prevent direct API calls to ad platforms (must go through Adspirer MCP)
- Budget guardrails from AGENTS.md are respected

## Troubleshooting

| Problem | Solution |
|---------|----------|
| MCP server not found | Run `codex mcp add adspirer --url https://mcp.adspirer.com/mcp` and restart Codex |
| Authentication failed | Run `codex mcp login adspirer` to re-authenticate |
| No ad platforms connected | Connect platforms at [adspirer.com](https://www.adspirer.com) |
| Skills not showing | Verify skills are in `~/.agents/skills/` — run `ls ~/.agents/skills/` |
| No data returned | Check if the platform has active campaigns. Try a longer lookback period (60/90 days) |
| Rate limit hit | Check your Adspirer tier (Free: 10/mo, Plus: 50, Pro: 100, Enterprise: unlimited) |

## Links

- [Adspirer](https://www.adspirer.com) — Connect your ad accounts
- [Adspirer MCP Documentation](https://docs.adspirer.com)
- [OpenAI Codex](https://github.com/openai/codex) — The AI coding agent
- [Report Issues](https://github.com/amekala/ads-mcp/issues)
