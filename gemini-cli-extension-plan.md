# Gemini CLI Extension Plan — Adspirer Ads MCP

**Date:** 2026-04-02
**Status:** Draft
**Author:** Adspirer Team

---

## Overview

Publish the Adspirer MCP server as a Gemini CLI extension so users can install it via:

```bash
gemini extensions install github.com/amekala/ads-mcp
```

The MCP server is already remote (`https://mcp.adspirer.com/mcp`) with OAuth 2.1 + PKCE. Gemini CLI natively supports remote MCP via `url` + `type: "http"` and handles OAuth automatically (detects 401 → discovers endpoints → browser auth → token management). No local server code needed — the extension is purely configuration + context.

---

## Architecture Decision

### Approach: Root-level manifest in existing monorepo

| Consideration | Decision | Rationale |
|--------------|----------|-----------|
| Where to put `gemini-extension.json` | Repo root | Required for `gemini extensions install` and gallery auto-discovery |
| Context file | `GEMINI.md` at root | Avoids conflict with `CLAUDE.md` (Claude Code) |
| Commands | `commands/adspirer/*.toml` | No conflict — Claude Code uses `commands/*.md` |
| Skills | Reuse existing `skills/` | Same `SKILL.md` format as Claude Code, auto-discovered |
| Separate repo? | No | Monorepo philosophy, single source of truth |

### No conflicts with existing files

| New File | Existing Files | Conflict? |
|----------|---------------|-----------|
| `gemini-extension.json` | `.mcp.json`, `server.json` | None — different file |
| `GEMINI.md` | `CLAUDE.md` | None — different file |
| `commands/adspirer/*.toml` | `commands/*.md` | None — different subdir and format |
| Skills reuse | `skills/ad-campaign-management/SKILL.md` | None — same format works for both |

---

## Files to Create

### 1. `gemini-extension.json` (repo root)

The extension manifest. Tells Gemini CLI how to load the extension.

```json
{
  "name": "adspirer-ads",
  "version": "1.0.0",
  "description": "Manage Google, Meta, TikTok & LinkedIn ads via natural language. 100+ tools for campaigns, analytics & optimization.",
  "contextFileName": "GEMINI.md",
  "mcpServers": {
    "adspirer": {
      "url": "https://mcp.adspirer.com/mcp",
      "type": "http",
      "timeout": 120000
    }
  }
}
```

**Key decisions:**
- `url` + `type: "http"` — preferred over deprecated `httpUrl` (confirmed from Gemini CLI source: `mcp-client.ts` line 2120)
- OAuth handled automatically — no `oauth` block needed. Gemini CLI detects 401, discovers endpoints from `.well-known/oauth-protected-resource`, opens browser, manages tokens.
- No `settings` array needed — no API keys required (OAuth handles auth)
- 120s timeout — matches Codex config (`tool_timeout_sec = 120`)
- `contextFileName: "GEMINI.md"` — loads our context file into every session

### 2. `GEMINI.md` (repo root)

Model context file. Loaded into Gemini's context at session start when extension is active.

```markdown
# Adspirer — Ad Campaign Management

Manage advertising campaigns across Google Ads, Meta Ads, LinkedIn Ads, and
TikTok Ads using the Adspirer MCP server (100+ tools).

## Quick Start

1. Call `get_connections_status` to see which ad platforms are connected
2. If no platforms connected, direct user to https://www.adspirer.com to link accounts
3. For campaign performance, call the platform-specific performance tool
4. Present results in tables with key metrics

## When to Use These Tools

Activate when the user:
- Asks about ad campaign performance ("How are my Google Ads doing?")
- Wants to research keywords ("Find keywords for my plumbing business")
- Needs to create campaigns ("Launch a Google Search campaign for...")
- Wants budget optimization ("Where am I wasting ad spend?")
- Mentions advertising platforms (Google Ads, Meta, LinkedIn, TikTok)
- Asks about ad accounts or connections ("Which ad platforms are connected?")

## Core Workflows

### Check Connections (Always Start Here)
Call `get_connections_status` before any ad operation. Shows connected platforms,
primary/secondary accounts, and account IDs.

### Performance Analysis
- **Google Ads:** `get_campaign_performance` — params: `lookback_days` (7/30/60/90, default 30), optional `customer_id`
- **Meta Ads:** `get_meta_campaign_performance` — params: `lookback_days`, optional `ad_account_id`
- **LinkedIn Ads:** `get_linkedin_campaign_performance` — params: `lookback_days`
- **TikTok Ads:** `get_tiktok_campaign_performance` — params: `lookback_days`

Present: impressions, clicks, CTR, spend, conversions, cost/conversion, ROAS. Default to 30-day lookback.

### Cross-Platform Dashboard
When user asks for overall performance or cross-platform comparison:
1. `get_connections_status` — identify active platforms
2. Pull performance from each connected platform
3. Pull waste analysis: `analyze_wasted_spend`, `analyze_meta_wasted_spend`, `analyze_linkedin_wasted_spend`
4. Present unified scorecard table
5. Highlight best/worst platform and campaign
6. Recommend top 3 actions

### Keyword Research
1. `research_keywords` — get volumes, CPC, competition
2. `analyze_search_terms` — see what users actually search
3. Use findings to inform campaign creation or optimization

### Campaign Creation
Always create in PAUSED status. Follow this order:
1. Research: keywords, competitors, audiences
2. Create campaign with appropriate platform tool
3. Present to user for review before any activation

**Google Ads campaigns:** Search, Performance Max, Demand Gen, YouTube
**Meta Ads campaigns:** Image, Carousel
**LinkedIn Ads campaigns:** Sponsored Content, Lead Gen
**TikTok Ads campaigns:** In-feed video/image

### Budget Optimization
- `optimize_budget_allocation` — rebalance budgets across campaigns
- `analyze_wasted_spend` / `analyze_meta_wasted_spend` / `analyze_linkedin_wasted_spend`
- `analyze_search_terms` — find irrelevant search terms burning budget

### Account Management
- `switch_primary_account` — switch between multiple ad accounts
- `get_business_profile` — get account/business details
- `get_usage_status` — check Adspirer plan usage

## Task Reference

| User goal | Key tools |
|-----------|-----------|
| View campaign metrics | `get_campaign_performance`, `get_meta_campaign_performance`, `get_linkedin_campaign_performance` |
| Find keywords | `research_keywords` |
| Create a campaign | Platform-specific creation tools (always PAUSED) |
| Reduce wasted spend | `analyze_wasted_spend`, `analyze_search_terms`, `optimize_budget_allocation` |
| Switch accounts | `switch_primary_account` |
| Check ad fatigue | `detect_meta_creative_fatigue`, `analyze_linkedin_creative_performance` |
| Understand audiences | `get_meta_audience_insights`, `get_linkedin_audience_insights`, `search_audiences` |
| Set up monitoring | `create_monitor`, `list_monitors` |
| Schedule reports | `schedule_brief`, `generate_report_now` |

## Safety Rules

- All new campaigns are created **PAUSED** — never auto-activate
- Cannot delete existing campaigns
- Cannot modify existing budgets without explicit user approval
- Always confirm before executing campaign changes
- Present changes for user review before taking action
```

### 3. Custom Commands (`commands/adspirer/*.toml`)

Gemini CLI commands use TOML format in `commands/<namespace>/<name>.toml`. These become `/adspirer:command-name`.

**`commands/adspirer/setup.toml`:**
```toml
prompt = """
Set up my ad account workspace. Follow these steps:

1. Call `get_connections_status` to check which ad platforms are connected
2. Call `get_business_profile` for account details
3. For each connected platform, pull last 30 days of performance data:
   - Google: `get_campaign_performance` with lookback_days=30
   - LinkedIn: `get_linkedin_campaign_performance` with lookback_days=30
   - Meta: `get_meta_campaign_performance` with lookback_days=30
4. Present a summary: connected accounts, active campaigns, key metrics
5. Ask what I'd like to work on
"""
```

**`commands/adspirer/performance-review.toml`:**
```toml
prompt = """
Run a cross-platform performance review for {{args}}.
Default to last 30 days if no time period specified.

1. Call `get_connections_status` to identify active platforms
2. Pull performance from each connected platform
3. Present a unified scorecard table showing: Platform, Campaigns, Spend, CTR, CPA, ROAS
4. Highlight top and bottom performers
5. Recommend top 3 optimization actions
"""
```

**`commands/adspirer/wasted-spend.toml`:**
```toml
prompt = """
Find and fix wasted ad spend across {{args}}.
Default to all connected platforms if none specified.

1. Call `analyze_wasted_spend` for Google Ads waste
2. Call `analyze_meta_wasted_spend` for Meta Ads waste
3. Call `analyze_linkedin_wasted_spend` for LinkedIn Ads waste
4. Call `analyze_search_terms` to find irrelevant search terms
5. Calculate total waste amount, identify top sources, and recommend specific fixes with expected savings
"""
```

**`commands/adspirer/write-ad-copy.toml`:**
```toml
prompt = """
Write ad copy for {{args}}.

1. Call `get_campaign_structure` to see current ads and keywords
2. Call `analyze_search_terms` to see what users actually search
3. Call `suggest_ad_content` for AI-generated suggestions based on real performance data
4. Generate 5+ headline and description options
5. Present options in a table for review
"""
```

**`commands/adspirer/refresh.toml`:**
```toml
prompt = """
Refresh my ad account data. Pull latest metrics from all connected platforms.

1. Call `get_connections_status`
2. Pull fresh performance data:
   - Google: `get_campaign_performance`
   - LinkedIn: `get_linkedin_campaign_performance`
   - Meta: `get_meta_campaign_performance`
3. Call `get_business_profile`
4. Summarize current state and highlight any notable changes
"""
```

### 4. Skills — Reuse Existing (No New Files)

The existing `skills/ad-campaign-management/SKILL.md` uses the exact same format Gemini CLI expects:
- Frontmatter with `name` and `description`
- Markdown body with workflows

Gemini CLI auto-discovers skills from the `skills/` directory relative to `gemini-extension.json`. The existing skill works as-is.

**Future enhancement:** Add `GEMINI` as a template target in `sync-skills.sh` to generate Gemini-specific skill variants (e.g., removing references to `WebSearch`/`WebFetch` which Gemini CLI may handle differently).

---

## Files to Modify

### 5. `scripts/validate.sh` — Add Gemini checks

Add after existing checks:

```bash
# --------------------------------------------------------------------------
# Gemini CLI Extension Checks
# --------------------------------------------------------------------------
echo ""
echo "--- Gemini CLI Extension ---"

check "gemini-extension.json exists"
if [ -f gemini-extension.json ]; then pass; else fail; fi

check "gemini-extension.json is valid JSON"
if jq empty gemini-extension.json 2>/dev/null; then pass; else fail "Invalid JSON"; fi

check "gemini-extension.json has required fields (name, version)"
if jq -e '.name and .version' gemini-extension.json > /dev/null 2>&1; then pass; else fail "Missing name or version"; fi

check "gemini-extension.json name is lowercase with dashes"
NAME=$(jq -r '.name' gemini-extension.json 2>/dev/null)
if echo "$NAME" | grep -qE '^[a-z0-9-]+$'; then pass; else fail "Name '$NAME' must be lowercase with dashes only"; fi

check "gemini-extension.json mcpServers has adspirer"
if jq -e '.mcpServers.adspirer' gemini-extension.json > /dev/null 2>&1; then pass; else fail "Missing mcpServers.adspirer"; fi

check "GEMINI.md context file exists"
if [ -f GEMINI.md ]; then pass; else fail; fi

check "Gemini commands directory exists"
if [ -d commands/adspirer ]; then pass; else fail; fi

for cmd in commands/adspirer/*.toml; do
  [ -f "$cmd" ] || continue
  check "$(basename "$cmd") contains prompt field"
  if grep -q '^prompt' "$cmd"; then pass; else fail "Missing 'prompt' field"; fi
done
```

### 6. `README.md` — Add Gemini CLI section

Add to the "Supported Clients" or installation section:

```markdown
### Gemini CLI

Install the extension:
```bash
gemini extensions install github.com/amekala/ads-mcp
```

A browser window opens for OAuth authentication on first use. Then:
- Ask: "Show me my Google Ads campaign performance"
- Or use commands: `/adspirer:setup`, `/adspirer:performance-review`, `/adspirer:wasted-spend`
```

### 7. `CONNECTING.md` — Add Gemini CLI connection docs

Add alongside existing platform connection instructions:

```markdown
## Gemini CLI

1. Install the extension:
   ```bash
   gemini extensions install github.com/amekala/ads-mcp
   ```
2. Restart Gemini CLI
3. On first ad-related request, a browser window opens for OAuth authentication
4. Complete sign-in and link your ad accounts at https://www.adspirer.com
5. Return to Gemini CLI — tools are now available

**Troubleshooting:**
- Run `/extensions list` to verify extension is loaded
- Run `/mcp auth adspirer` to re-authenticate if tokens expire
- Press F12 (debug console) to check if MCP tools appear
```

### 8. `scripts/sync-skills.sh` — Add Gemini target (FUTURE)

For v1, the existing `skills/` directory works as-is. In a future update, add Gemini as a fifth IDE target:

```bash
# Add to target directories
GEMINI_SKILLS="$REPO_ROOT/plugins/gemini/adspirer/skills"

# Add Gemini config
# Gemini: CONTEXT_FILE=GEMINI.md, AUTH=extension auth msg, keep_websearch=no, keep_memory=no, keep=GEMINI
```

Add `<!-- BEGIN:GEMINI -->` / `<!-- END:GEMINI -->` conditional blocks to shared templates.

---

## Publishing Options

### Option A: Git Repository Install (Recommended for v1)

**How it works:**
1. Push files to `main` branch
2. Add `gemini-cli-extension` topic to GitHub repo
3. Users install: `gemini extensions install github.com/amekala/ads-mcp`
4. Gallery crawler auto-indexes within 24 hours

**Pros:**
- Simplest — no build step, no CI changes
- Auto-updates when you push to `main`
- Gallery auto-discovery via topic
- Works today with existing repo

**Cons:**
- Clones entire repo (includes Cursor/Codex plugin dirs — ~2MB)
- Users see all plugin files, not just Gemini-relevant ones

**User install experience:**
```bash
gemini extensions install github.com/amekala/ads-mcp
# First ad-related prompt → OAuth browser popup → authenticate → done
```

### Option B: GitHub Releases (Recommended for production)

**How it works:**
1. Create a GitHub Actions workflow that builds a release archive
2. Archive contains only: `gemini-extension.json`, `GEMINI.md`, `commands/adspirer/`, `skills/ad-campaign-management/`
3. Attach archive to GitHub Release
4. Users install from release (faster, smaller download)

**Pros:**
- Smaller download (only Gemini-relevant files)
- Clean install directory
- Version pinning via release tags

**Cons:**
- Requires GitHub Actions workflow
- Manual release process (or automated on tag push)

**GitHub Actions workflow** (`.github/workflows/gemini-release.yml`):
```yaml
name: Gemini CLI Extension Release

on:
  push:
    tags:
      - 'gemini-v*'

jobs:
  release:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Create release archive
        run: |
          mkdir -p release-staging
          cp gemini-extension.json release-staging/
          cp GEMINI.md release-staging/
          cp -r commands/adspirer release-staging/commands/adspirer
          cp -r skills/ad-campaign-management release-staging/skills/ad-campaign-management
          cd release-staging
          tar -czf ../adspirer-ads.tar.gz .

      - name: Create GitHub Release
        uses: softprops/action-gh-release@v1
        with:
          files: adspirer-ads.tar.gz
```

**User install experience:**
```bash
gemini extensions install github.com/amekala/ads-mcp
# Automatically uses latest GitHub Release archive
```

### Option C: Separate Repository

**How it works:**
1. Create `amekala/adspirer-gemini-extension` repo
2. Copy only Gemini-relevant files
3. Independent versioning and releases

**Pros:**
- Cleanest separation
- Dedicated README and documentation
- Independent version lifecycle

**Cons:**
- Breaks monorepo philosophy
- Drift risk (content diverges from main repo)
- Extra maintenance burden

**Not recommended** unless there's a strong reason to decouple.

### Recommendation

**Start with Option A** (Git repo install) for immediate availability. **Move to Option B** (GitHub Releases) once you want a polished production experience. Skip Option C.

---

## Gallery Listing Checklist

The [Gemini CLI extension gallery](https://geminicli.com/extensions/browse/) auto-indexes public repos.

- [ ] `gemini-extension.json` at repo root with valid JSON
- [ ] `name` field is lowercase with dashes (`adspirer-ads`)
- [ ] Public GitHub repository (already: `github.com/amekala/ads-mcp`)
- [ ] Add `gemini-cli-extension` topic to repo (Settings > About > Topics)
- [ ] Gallery crawler picks it up within 24 hours

---

## Testing Plan

### Local Development Testing

```bash
# 1. Link extension locally (no install needed)
cd /path/to/ads-mcp
gemini extensions link .

# 2. Restart Gemini CLI session

# 3. Verify extension loaded
/extensions list
# Should show "adspirer-ads" with version 1.0.0

# 4. Check MCP tools available
# Press F12 (debug console) — verify Adspirer tools listed

# 5. Test OAuth flow
# Ask: "What ad platforms are connected?"
# Should trigger browser OAuth popup on first use

# 6. Test custom commands
/adspirer:setup
/adspirer:performance-review last 7 days
/adspirer:wasted-spend Google Ads
/adspirer:write-ad-copy Google Search brand campaign
/adspirer:refresh

# 7. Test skill activation
# Ask: "Research keywords for AI project management SaaS"
# Should activate ad-campaign-management skill

# 8. Test error cases
# Disconnect auth → verify graceful error message
# Ask about unconnected platform → verify redirect to adspirer.com
```

### Validation

```bash
# Run existing validation suite (updated with Gemini checks)
./scripts/validate.sh

# Run with live endpoint test
./scripts/validate.sh --live
```

---

## Implementation Order

| Step | Task | Files | Priority | Estimated Effort |
|------|------|-------|----------|-----------------|
| 1 | Create `gemini-extension.json` | `gemini-extension.json` | **Required** | 5 min |
| 2 | Create `GEMINI.md` | `GEMINI.md` | **Required** | 15 min |
| 3 | Create custom commands | `commands/adspirer/*.toml` (5 files) | **Recommended** | 10 min |
| 4 | Update README | `README.md` | **Recommended** | 5 min |
| 5 | Update CONNECTING.md | `CONNECTING.md` | **Recommended** | 5 min |
| 6 | Update validate.sh | `scripts/validate.sh` | Nice to have | 10 min |
| 7 | Test locally | `gemini extensions link .` | **Required** | 15 min |
| 8 | Add GitHub topic | GitHub repo settings | **Required** | 1 min |
| 9 | GitHub Actions (Option B) | `.github/workflows/gemini-release.yml` | Future | 20 min |
| 10 | Add Gemini to sync-skills.sh | `scripts/sync-skills.sh` | Future | 30 min |

**Minimum viable extension: Steps 1-2 (manifest + context file). Everything else is enhancement.**

---

## Technical Notes

### OAuth Flow (How It Works Automatically)

Gemini CLI's OAuth handling (from `packages/core/src/mcp/oauth-provider.ts`):

1. Extension connects to `https://mcp.adspirer.com/mcp`
2. Server returns 401 with `www-authenticate` header
3. Gemini CLI discovers OAuth metadata from `https://mcp.adspirer.com/.well-known/oauth-protected-resource`
4. Dynamic client registration (RFC 7591)
5. Browser opens for user authentication
6. Authorization code exchanged for access/refresh tokens
7. Tokens stored in `~/.gemini/mcp-oauth-tokens.json`
8. Connection retried with Bearer token
9. Auto-refresh on expiry

**No configuration needed** — Adspirer's server already implements the required OAuth discovery endpoints.

### Transport Priority (From Gemini CLI Source)

From `mcp-client.ts` line 2120:
1. `httpUrl` → StreamableHTTPClientTransport (deprecated)
2. `url` + `type: "http"` → StreamableHTTPClientTransport (preferred)
3. `url` + `type: "sse"` → SSEClientTransport
4. `url` alone → defaults to StreamableHTTPClientTransport
5. `command` → StdioClientTransport

We use option 2 (`url` + `type: "http"`).

### Gemini CLI Extension Interface (From Source)

```typescript
// packages/cli/src/config/extension.ts
interface ExtensionConfig {
  name: string;                          // "adspirer-ads"
  version: string;                       // "1.0.0"
  description?: string;                  // Gallery description
  mcpServers?: Record<string, MCPServerConfig>;
  contextFileName?: string | string[];   // "GEMINI.md"
  excludeTools?: string[];
  settings?: ExtensionSetting[];
  themes?: CustomTheme[];
  plan?: { directory?: string };
  migratedTo?: string;
}
```

### Supported Subdirectories (Auto-Discovered)

| Directory | Purpose | Format |
|-----------|---------|--------|
| `commands/<namespace>/<name>.toml` | Custom commands → `/namespace:name` | TOML with `prompt` field |
| `skills/<name>/SKILL.md` | Agent skills | Markdown with YAML frontmatter |
| `GEMINI.md` | Context/instructions | Markdown |

---

## Comparison: Adspirer Across All Supported AI Clients

| Feature | Claude Code | Cursor | Codex | OpenClaw | Gemini CLI |
|---------|------------|--------|-------|----------|------------|
| **Manifest** | `.claude-plugin/plugin.json` | `.cursor/plugin.json` | `.codex/config.toml` | `claw.json` | `gemini-extension.json` |
| **MCP Config** | `.mcp.json` | `mcp.json` | `config.toml` | Built-in | `gemini-extension.json` |
| **Context File** | `CLAUDE.md` | `BRAND.md` | `AGENTS.md` | `SKILL.md` | `GEMINI.md` |
| **Skills Format** | `skills/*/SKILL.md` | `.cursor/skills/*/SKILL.md` | `skills/*/SKILL.md` | `SKILL.md` | `skills/*/SKILL.md` |
| **Commands** | `commands/*.md` | N/A | N/A | N/A | `commands/*/*.toml` |
| **Agent** | `agents/*.md` | `.cursor/agents/*.md` | `agents/*.toml` | N/A | N/A (use skills) |
| **Auth** | OAuth via `/mcp` | Auto-negotiate | Auto-negotiate | CLI login | Auto OAuth discovery |
| **Install** | `/plugin marketplace add` | Copy mcp.json | Add to config.toml | `openclaw install` | `gemini extensions install` |
| **Version** | 2.0.0 | 1.0.0 | 1.5.0 | 1.5.0 | **1.0.0 (NEW)** |
