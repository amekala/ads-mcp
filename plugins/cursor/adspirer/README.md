# Adspirer Performance Marketing Agent for Cursor

Brand-aware paid media management across Google Ads, Meta Ads, LinkedIn Ads, and TikTok Ads — powered by the Adspirer MCP server (100+ tools).

## What This Does

This plugin turns Cursor into a **brand-specific paid media analyst** that:

- **Knows your brand** — scans your local docs (guidelines, media plans, briefs) to understand voice, audience, products
- **Has live data** — connects to your actual ad accounts via Adspirer for real-time performance data
- **Manages campaigns** — creates, analyzes, and optimizes campaigns across 4 platforms
- **Bootstraps itself** — on first use, it reads your folder + pulls live data to build brand context automatically

## Prerequisites

- [Cursor IDE](https://cursor.com/) installed (v2.4+ recommended for subagent support)
- [git](https://git-scm.com/) installed (used by the installer)
- An Adspirer account at [adspirer.com](https://www.adspirer.com) with at least one ad platform connected

---

## Quick Install (One Command)

**Run this from your system terminal** (Terminal.app, iTerm, Windows Terminal, etc.), **not** Cursor's built-in terminal. Cursor's terminal is sandboxed and can't write to `~/.cursor/`, which causes permission errors.

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/amekala/ads-mcp/main/plugins/cursor/adspirer/install.sh)
```

This automatically:
- Installs the performance marketing subagent to `~/.cursor/agents/`
- Installs all 5 Adspirer skills to `~/.cursor/skills/`
- Configures the Adspirer MCP server in `~/.cursor/mcp.json`

Then restart Cursor.

**Note:** The installer does not require authentication. You'll authenticate in the Getting Started steps below.

---

## Getting Started

### 1. Verify the MCP server is connected

Open **Cursor Settings > MCP**. You should see `adspirer` listed.

If it shows a connection error, click on it to authenticate. A browser window will open for Adspirer login — complete the sign-in and return to Cursor.

If `adspirer` is missing entirely, add it manually:

**Cursor Settings > MCP > Add Server** with URL: `https://mcp.adspirer.com/mcp`

### 2. Open your brand folder in Cursor

```bash
cd ~/Clients/YourBrand
cursor .
```

Your brand folder can have docs (`.md`, `.txt`, `.csv`, `.yaml`, `.json`, `.pdf`) or be completely empty.

### 3. Switch to Agent mode and say "set up my brand workspace"

Make sure you're in **Agent mode** (not Ask or Edit mode) in the Cursor chat panel.

The agent will:
1. Connect to your ad accounts (may open a browser for OAuth on first use)
2. Scan the folder for brand docs
3. Pull live campaign data from all connected platforms
4. Create `BRAND.md` with your brand context, performance snapshot, and KPI targets
5. Create `STRATEGY.md` for persisting strategic decisions across sessions
6. Tell you what it found and ask what you'd like to work on

If it doesn't trigger automatically, type: `/adspirer-setup`

### 4. Start managing campaigns

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
cd ads-mcp/plugins/cursor/adspirer
```

### Step 2: Install subagent and skills

```bash
mkdir -p ~/.cursor/agents ~/.cursor/skills
cp .cursor/agents/performance-marketing-agent.md ~/.cursor/agents/
cp -r .cursor/skills/adspirer-ads ~/.cursor/skills/
cp -r .cursor/skills/adspirer-setup ~/.cursor/skills/
cp -r .cursor/skills/adspirer-performance-review ~/.cursor/skills/
cp -r .cursor/skills/adspirer-write-ad-copy ~/.cursor/skills/
cp -r .cursor/skills/adspirer-wasted-spend ~/.cursor/skills/
```

### Step 3: Add the MCP server

Add to `~/.cursor/mcp.json`:

```json
{
  "mcpServers": {
    "adspirer": {
      "url": "https://mcp.adspirer.com/mcp"
    }
  }
}
```

Or use **Cursor Settings > MCP > Add Server** with URL `https://mcp.adspirer.com/mcp`.

### Step 4: Copy rules to your brand folder (optional)

```bash
cd ~/Clients/YourBrand
mkdir -p .cursor/rules
cp /path/to/ads-mcp/plugins/cursor/adspirer/.cursor/rules/*.mdc .cursor/rules/
```

### Step 5: Restart Cursor

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
| **Adspirer Ads** | `/adspirer-ads` or just ask naturally | Full campaign management — 100+ tools, all workflows, all platforms |
| **Setup** | `/adspirer-setup` | Bootstrap a brand workspace (first-time or refresh) |
| **Performance Review** | `/adspirer-performance-review` | Cross-platform performance scorecard |
| **Write Ad Copy** | `/adspirer-write-ad-copy` | Brand-voice ad copy from real data |
| **Wasted Spend** | `/adspirer-wasted-spend` | Find and fix wasted ad spend |

You don't need to remember skill names — just describe what you want and Cursor will match the right skill automatically.

---

## Architecture

```
Cursor IDE (Agent Mode)
│
├── Performance Marketing Agent (subagent)
│   ├── Reads: BRAND.md (brand context), STRATEGY.md (directives), local docs
│   ├── Writes: MEMORY.md (decisions), STRATEGY.md (confirmed directives)
│   ├── Uses: Adspirer MCP (100+ tools)
│   └── Workflows: campaign creation, performance analysis,
│       keyword research, optimization, ad copy, competitive intel
│
├── Skills (playbooks)
│   ├── adspirer-ads — full tool orchestration
│   ├── adspirer-setup — workspace bootstrap
│   └── Quick skills — performance-review, write-ad-copy, wasted-spend
│
├── Rules (.cursor/rules/)
│   ├── use-adspirer.mdc — safety and workflow rules
│   └── brand-workspace.mdc — brand context loading
│
└── Adspirer MCP Server (tools)
    ├── Google Ads (39+ tools)
    ├── LinkedIn Ads (28+ tools)
    ├── Meta Ads (20+ tools)
    ├── TikTok Ads (4+ tools)
    └── Account + monitoring tools
```

## Safety

- All new campaigns are created in **PAUSED** status
- The agent **always asks for confirmation** before creating campaigns or changing budgets
- Rules enforce workflow ordering and prevent skipping safety steps
- Strategy directives from STRATEGY.md guide campaign creation, keyword research, and ad copy
- Budget guardrails from BRAND.md are respected

## Troubleshooting

| Problem | Solution |
|---------|----------|
| Install fails with permission/hooks error | Run the install from your **system terminal**, not Cursor's built-in terminal (it's sandboxed) |
| MCP server not showing | Open Cursor Settings > MCP > Add server with URL `https://mcp.adspirer.com/mcp` |
| MCP connection error | Click the server in Settings > MCP to re-authenticate via browser |
| Authentication failed | Remove and re-add the MCP server in Cursor Settings |
| OAuth window doesn't open | Check browser pop-up blocker. Try restarting Cursor. |
| No ad platforms connected | Connect platforms at [adspirer.com](https://www.adspirer.com) |
| Skills not showing | Verify: `ls ~/.cursor/skills/` — should show `adspirer-*` directories |
| Subagent not triggering | Ensure you're in **Agent mode** (not Ask or Edit). Try `/adspirer-setup` directly. |
| No data returned | Check for active campaigns. Try longer lookback (60/90 days) |
| Rate limit hit | Check Adspirer tier (Free: 10/mo, Plus: 50, Pro: 100, Enterprise: unlimited) |

## Links

- [Adspirer](https://www.adspirer.com) — Connect your ad accounts
- [Cursor IDE](https://cursor.com/) — AI-powered code editor
- [Report Issues](https://github.com/amekala/ads-mcp/issues)
