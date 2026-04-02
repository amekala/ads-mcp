# Adspirer Cookbook Plan — Cross-Platform Submissions

**Date:** 2026-04-02
**Status:** In Progress — OpenAI submitted, others pending

---

## Submission Status

| Platform | Status | PR/Link | Notes |
|----------|--------|---------|-------|
| **OpenAI** | **Submitted** | [openai/openai-cookbook#2575](https://github.com/openai/openai-cookbook/pull/2575) | Notebook + registry + authors entry. Awaiting review (best-effort, no ETA). |
| **Anthropic** | Not started | — | Same notebook, adapt setup for Claude connector |
| **Google Gemini** | Not started | — | Must file issue first for pre-approval, sign CLA |
| **xAI** | Not started | — | Fork + PR, same content |
| **Perplexity** | Not started | — | Convert to MDX format |

---

## What Was Submitted to OpenAI

### Files Created on Fork (`amekala/openai-cookbook`, branch `add-adspirer-mcp-cookbook`)

1. **`examples/mcp/adspirer_mcp_ad_campaign_creation.ipynb`** — The notebook
   - 16 markdown cells (no code cells — MCP is conversational, not Python)
   - Title: "How AI Agents Are Replacing the Slowest Part of Paid Media"
   - Scenario: DTC skincare brand launching Google Search + Meta campaigns
   - 6-step workflow: Check connections → Research → Google campaign → Meta campaign (8 variants) → Monitoring → Review
   - All expected outputs shown as formatted tables/trees
   - Tools reference table at the end
   - About Adspirer section with links

2. **`registry.yaml`** — Added entry at top (newest first):
   ```yaml
   - title: How AI Agents Are Replacing the Slowest Part of Paid Media
     path: examples/mcp/adspirer_mcp_ad_campaign_creation.ipynb
     slug: adspirer-mcp-ad-campaign-creation
     description: Create a complete multi-platform ad campaign (Google Search + Meta Ads with 8 creative variants) in a single ChatGPT conversation using the Adspirer MCP server.
     date: 2026-04-02
     authors:
       - amekala
     tags:
       - mcp
       - advertising
       - google-ads
       - meta-ads
   ```

3. **`authors.yaml`** — Added entry:
   ```yaml
   amekala:
     name: "Abhi Mekala"
     website: "https://www.adspirer.com"
     avatar: "https://avatars.githubusercontent.com/u/3914723?v=4"
   ```

### How We Submitted (GitHub API — no clone needed)

The repo is 757MB so cloning is impractical. We used the GitHub API:

```bash
# 1. Fork exists at amekala/openai-cookbook

# 2. Create branch from main
MAIN_SHA=$(gh api repos/amekala/openai-cookbook/git/ref/heads/main --jq '.object.sha')
gh api repos/amekala/openai-cookbook/git/refs -X POST \
  -f ref="refs/heads/add-adspirer-mcp-cookbook" \
  -f sha="$MAIN_SHA"

# 3. Upload notebook (base64 encode, PUT to contents API)
CONTENT=$(base64 -i cookbook/openai/adspirer_mcp_ad_campaign_creation.ipynb)
gh api repos/amekala/openai-cookbook/contents/examples/mcp/adspirer_mcp_ad_campaign_creation.ipynb \
  -X PUT -f message="Add notebook" -f content="$CONTENT" -f branch="add-adspirer-mcp-cookbook"

# 4. Update registry.yaml (download, prepend entry, upload with SHA)
# 5. Update authors.yaml (download, append entry, upload with SHA)

# 6. Create PR
gh pr create --repo openai/openai-cookbook \
  --head amekala:add-adspirer-mcp-cookbook \
  --base main \
  --title "Add Adspirer MCP cookbook: AI-powered ad campaign creation across Google & Meta"
```

### PR Checklist (from OpenAI's template)

- [x] Added entry in `registry.yaml`
- [x] Added entry in `authors.yaml`
- [x] Relevance: Uses ChatGPT with MCP
- [x] Uniqueness: First MCP cookbook for ad campaign creation
- [x] Spelling/Grammar: Checked
- [x] Clarity: 6-step walkthrough with prompts and outputs
- [x] Correctness: Based on real production tool calls
- [x] Completeness: Research → Create → Monitor with tool reference

---

## The Pitch

**A human spends a full day** creating a multi-platform ad campaign: research keywords, build ad groups, write 15 headline variations, set up targeting, configure ad sets, upload creatives, set budgets — across Google, Meta, and LinkedIn. Each platform has a different UI, different rules, different formats.

**With Adspirer MCP + any AI chat, this takes minutes.** One conversation. Natural language. All platforms.

The cookbook title: **"How AI Agents Are Replacing the Slowest Part of Paid Media"**

Core message: Strategy stays human, execution becomes instant.

---

## Format Decision

### Jupyter Notebook — Hybrid Approach

Since Adspirer is an MCP server (users chat, not code), notebooks use:
- **Markdown cells only** for the conversational workflow (prompts + explanations + expected outputs)
- No code cells needed (MCP is not a Python SDK — users interact via ChatGPT/Claude/Gemini)
- Expected outputs shown as formatted ASCII tables and tree structures

This matches existing OpenAI MCP cookbooks in `examples/mcp/`.

### Where Each Platform Accepts Submissions

| Platform | Repo | Format | Submit | Pre-approval? |
|----------|------|--------|--------|--------------|
| **OpenAI** | [openai/openai-cookbook](https://github.com/openai/openai-cookbook) | .ipynb | Fork + PR + `registry.yaml` | No |
| **Anthropic** | [anthropics/anthropic-cookbook](https://github.com/anthropics/anthropic-cookbook) | .ipynb | Fork + PR + `registry.yaml` | No |
| **Google Gemini** | [google-gemini/cookbook](https://github.com/google-gemini/cookbook) | .ipynb (Colab) | File issue first, then PR | **Yes** + CLA |
| **xAI** | [xai-org/xai-cookbook](https://github.com/xai-org/xai-cookbook) | .ipynb | Fork + PR + `registry.yaml` | No |
| **Perplexity** | [perplexityai/api-cookbook](https://github.com/perplexityai/api-cookbook) | .mdx | Fork + PR | No |

---

## Cookbook Content — What's Inside

### Scenario
DTC skincare brand launching a Vitamin C serum campaign.

### 6-Step Workflow

| Step | Prompt | MCP Tools Called |
|------|--------|-----------------|
| 1. Check connections | "What ad platforms do I have connected?" | `get_connections_status` |
| 2a. Keyword research | "Research keywords for vitamin C serum..." | `research_keywords` |
| 2b. Audience research | "Search for Meta targeting options..." | `search_meta_targeting` |
| 3. Google Search campaign | "Create a Google Search campaign..." (budget, keywords, 5 headlines, 3 descriptions) | `create_search_campaign`, `add_sitelinks`, `add_callout_extensions` |
| 4. Meta campaign + 8 variants | "Create Meta image campaign with 5 angles..." then "Add 3 retargeting variants..." | `discover_meta_assets`, `create_meta_image_campaign`, `add_meta_ad` |
| 5. Monitoring | "Set up CPA alerts and weekly reports..." | `create_monitor`, `schedule_brief` |
| 6. Review | "Summarize everything we created..." | (summary only) |

### Real-World Evidence (from BLOG_RESEARCH_USE_CASES.md)
- **Blushwood Health:** 174 ad operations, 15 messaging angles, solo DTC founder
- **Vyve Agency:** 64 campaigns across 5 formats, clients in Dubai + Delhi
- **MarketingBrigad:** $6K/day campaign, 42 performance checks, 99 ad updates

---

## Content Reuse Strategy

One master notebook adapted per platform:

| Section | Changes Per Platform |
|---------|---------------------|
| Setup | ChatGPT connector vs Claude connector vs Gemini CLI extension vs Grok |
| Prompts | Identical |
| Tool outputs | Identical |
| Intro framing | Platform-specific context |
| Style | Colab template for Gemini, ruff for Anthropic, etc. |

### Source Files

| File | Purpose |
|------|---------|
| `cookbook/master-notebook.md` | Master markdown version (source of truth) |
| `cookbook/openai/adspirer_mcp_ad_campaign_creation.ipynb` | OpenAI submission (16 cells, 23KB) |
| `cookbook-plan.md` | This file |

---

## Submission Steps Per Platform

### Anthropic (Next)
1. Fork `anthropics/anthropic-cookbook`
2. Copy notebook to `third_party/adspirer_campaign_launch.ipynb`
3. Change setup section: Claude connector instead of ChatGPT
4. Change "ChatGPT calls..." to "Claude calls..." throughout
5. Add `registry.yaml` entry (title, description, path, authors, date, categories)
6. Run `uv run ruff check` and `uv run ruff format`
7. Use conventional commit: `feat(third_party): add adspirer mcp cookbook`
8. PR with their template

### Google Gemini (Requires Pre-Approval)
1. **File issue first** at google-gemini/cookbook explaining the cookbook idea
2. Wait for approval
3. Sign Google CLA at cla.developers.google.com
4. Use their template at `quickstarts/Template.ipynb`
5. Change setup: Gemini CLI extension install
6. Run `nbfmt` and `nblint`
7. Submit PR with Colab link

### xAI
1. Fork `xai-org/xai-cookbook`
2. Copy notebook to `examples/adspirer_campaign_launch.ipynb`
3. Change setup section for Grok
4. Add `registry.yaml` entry
5. PR title: `[Content] Multi-Platform Ad Campaign Launch with Adspirer MCP`

### Perplexity
1. Fork `perplexityai/api-cookbook`
2. Convert notebook to MDX: `docs/showcase/adspirer-campaign-launch/README.mdx`
3. Add MDX frontmatter (title, description, sidebar_position, keywords)
4. Submit PR with their template

---

## Secondary Cookbook Topics (Phase 2)

| Topic | Based On | Best Platform |
|-------|----------|---------------|
| "174 Ad Creatives in 10 Days: The AI A/B Testing Playbook" | Blushwood Health data | Anthropic, OpenAI |
| "How One Agency Manages 64 Campaigns From a Single Chat" | Vyve agency data | OpenAI |
| "The $6,000/Day Campaign: AI Monitoring for High-Stakes Ads" | MarketingBrigad data | xAI, Anthropic |
