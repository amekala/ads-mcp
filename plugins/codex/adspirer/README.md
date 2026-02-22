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
- [git](https://git-scm.com/) installed (used by the installer)
- An Adspirer account at [adspirer.com](https://www.adspirer.com) with at least one ad platform connected

---

## Quick Install (One Command)

Open your terminal and run:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/amekala/ads-mcp/main/plugins/codex/adspirer/install.sh)
```

This automatically:
- Downloads all 5 Adspirer skills to `~/.agents/skills/`
- Installs the agent configuration to `~/.codex/agents/`
- Configures the Adspirer MCP server in `~/.codex/config.toml`
- Enables multi-agent and registers the agent role

Then restart Codex (close and reopen).

**Note:** The installer does not require authentication. You'll authenticate in the Getting Started steps below.

---

## Getting Started

### 1. Verify the MCP server is registered

Before opening Codex, confirm the server is present:

```bash
codex mcp list
```

Look for `adspirer` in the output. It's normal for auth to show **Unsupported** at this point — that resolves after login.

If `adspirer` is missing entirely, run:

```bash
codex mcp add adspirer --url https://mcp.adspirer.com/mcp
```

### 2. Authenticate with Adspirer

```bash
codex mcp login adspirer
```

A browser window will open. Sign in with your Adspirer account and authorize access. Return to your terminal when complete.

Verify auth succeeded:

```bash
codex mcp list
```

`adspirer` should now show as **enabled**.

### 3. Open your brand folder in Codex

```bash
cd ~/Clients/YourBrand
codex
```

Your brand folder can have docs (`.md`, `.txt`, `.csv`, `.yaml`, `.json`, `.pdf`) or be completely empty.

### 4. Say "set up my brand workspace"

The agent will:
1. Connect to your ad accounts
2. Scan the folder for brand docs
3. Pull live campaign data from all connected platforms
4. Create `AGENTS.md` with your brand context, performance snapshot, and KPI targets
5. Tell you what it found and ask what you'd like to work on

If it doesn't trigger automatically, run: `$adspirer-setup`

### 5. Start managing campaigns

```
How are my Google Ads campaigns doing?
Find wasted spend across all platforms
Write new headlines for my Google Search campaigns
Create a LinkedIn campaign targeting IT Directors
What keywords should I bid on?
Compare my Google and Meta ad performance
```

That's it. You're up and running.

---

## Manual Install (Alternative)

If you prefer to install manually instead of using the one-command script:

<details>
<summary>Click to expand manual steps</summary>

### Step 1: Clone the repo

```bash
git clone https://github.com/amekala/ads-mcp.git
cd ads-mcp/plugins/codex/adspirer
```

### Step 2: Install skills

```bash
mkdir -p ~/.agents/skills
cp -r skills/adspirer-ads ~/.agents/skills/
cp -r skills/adspirer-setup ~/.agents/skills/
cp -r skills/adspirer-performance-review ~/.agents/skills/
cp -r skills/adspirer-write-ad-copy ~/.agents/skills/
cp -r skills/adspirer-wasted-spend ~/.agents/skills/
```

### Step 3: Add the MCP server

```bash
codex mcp add adspirer --url https://mcp.adspirer.com/mcp
```

### Step 4: Install agent config

```bash
mkdir -p ~/.codex/agents
cp agents/performance-marketing-agent.toml ~/.codex/agents/
```

### Step 5: Update config.toml

Add to `~/.codex/config.toml`:

```toml
[features]
multi_agent = true

[agents.performance-marketing-agent]
description = "Brand-specific performance marketing agent. Use for ad campaigns, performance, keywords, ad copy, budgets."
config_file = "agents/performance-marketing-agent.toml"
```

### Step 6: Restart Codex

</details>

---

## What Goes in Your Brand Folder?

Drop any brand-relevant files — the agent reads them all:

```
~/Clients/Acme/
├── brand-guidelines.md        # Brand voice, tone, prohibited words
├── Q1-media-plan.csv          # Budget, targets, timeline
├── campaign-notes.txt         # Past campaign strategy notes
├── competitor-analysis.pdf    # Competitive landscape
├── audience-research.csv      # Target audience data
└── config.yaml                # Any structured brand config
```

Supported file types: `.md`, `.txt`, `.csv`, `.yaml`, `.json`, `.pdf`

More docs = better brand context = better ad copy and recommendations. No docs? That's fine too — the agent builds context from your live ad platform data.

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

---

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
    ├── Google Ads (39+ tools)
    ├── LinkedIn Ads (28+ tools)
    ├── Meta Ads (20+ tools)
    ├── TikTok Ads (4+ tools)
    └── Account + monitoring tools
```

## Safety

- All new campaigns are created in **PAUSED** status
- The agent **always asks for confirmation** before creating campaigns or changing budgets
- Shell-level safety rules prevent direct API calls to ad platforms (must go through Adspirer MCP)
- Budget guardrails from AGENTS.md are respected

## Troubleshooting

| Problem | Solution |
|---------|----------|
| MCP server not found | Run `codex mcp add adspirer --url https://mcp.adspirer.com/mcp` and restart |
| MCP shows "Unsupported" | Run `codex mcp login adspirer` to complete OAuth authentication |
| Authentication failed | Run `codex mcp login adspirer` to re-authenticate |
| Install appears to hang | A browser window may have opened for OAuth — complete sign-in and return to terminal |
| No ad platforms connected | Connect platforms at [adspirer.com](https://www.adspirer.com) |
| Skills not showing | Verify: `ls ~/.agents/skills/` — should show `adspirer-*` directories |
| No data returned | Check for active campaigns. Try longer lookback (60/90 days) |
| Rate limit hit | Check Adspirer tier (Free: 10/mo, Plus: 50, Pro: 100, Enterprise: unlimited) |

## Links

- [Adspirer](https://www.adspirer.com) — Connect your ad accounts
- [OpenAI Codex](https://github.com/openai/codex) — The AI coding agent
- [Report Issues](https://github.com/amekala/ads-mcp/issues)
