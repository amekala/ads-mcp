# Skill Architecture

## Overview

Skills are authored once in `shared/skills/` as templates, then generated into IDE-specific copies by `scripts/sync-skills.sh`. This ensures a single source of truth across all IDE plugins (Cursor, Codex, Claude Code). OpenClaw uses a standalone skill (`plugins/openclaw/`) that is not template-compiled.

## Directory Structure

```
ads-mcp/
├── shared/skills/                          ← EDIT HERE (source of truth)
│   ├── adspirer-ads/SKILL.md              ← Main skill template (472 lines)
│   │   └── references/                    ← Future: platform-specific deep dives
│   ├── adspirer-setup/SKILL.md
│   ├── adspirer-performance-review/SKILL.md
│   ├── adspirer-write-ad-copy/SKILL.md
│   └── adspirer-wasted-spend/SKILL.md
│
├── plugins/cursor/.../skills/              ← GENERATED (don't edit directly)
├── plugins/codex/.../skills/               ← GENERATED (don't edit directly)
├── skills/ad-campaign-management/          ← GENERATED (don't edit directly)
│
├── plugins/openclaw/                       ← STANDALONE (edit directly)
│   ├── claw.json                          ← Registry manifest
│   └── SKILL.md                           ← Self-contained skill (not templated)
│
├── scripts/
│   ├── sync-skills.sh                     ← Generates IDE-specific skills
│   └── validate.sh                        ← Validates consistency (39 checks)
│
├── agents/                                 ← IDE-SPECIFIC (edit directly)
├── plugins/cursor/.../agents/              ← IDE-SPECIFIC (edit directly)
├── plugins/codex/.../agents/               ← IDE-SPECIFIC (edit directly)
├── plugins/cursor/.../rules/               ← IDE-SPECIFIC (edit directly)
├── plugins/codex/.../rules/                ← IDE-SPECIFIC (edit directly)
```

## How to Edit Skills

1. Edit the template in `shared/skills/<skill>/SKILL.md`
2. Run `./scripts/sync-skills.sh`
3. Run `./scripts/validate.sh` to verify consistency
4. Commit all generated files along with the template

**Never edit files in `plugins/*/skills/` or `skills/` directly** — they will be overwritten by the sync script.

## Template Syntax

### Variable Substitution

| Variable | Cursor | Codex | Claude Code |
|---|---|---|---|
| `{{CONTEXT_FILE}}` | BRAND.md | AGENTS.md | CLAUDE.md |
| `{{AUTH_TROUBLESHOOT}}` | Reconnect via connector settings | `codex mcp login adspirer` | Reconnect via connector settings |

### Conditional Blocks

```markdown
<!-- BEGIN:CURSOR_CLAUDE -->
Content only in Cursor and Claude Code versions
<!-- END:CURSOR_CLAUDE -->

<!-- BEGIN:CODEX -->
Content only in Codex version
<!-- END:CODEX -->

<!-- BEGIN:HAS_MEMORY -->
Content only for IDEs with memory support (Cursor, Claude Code)
<!-- END:HAS_MEMORY -->

<!-- BEGIN:NO_MEMORY -->
Content only for IDEs without memory support (Codex)
<!-- END:NO_MEMORY -->
```

For Cursor/Claude Code: `CURSOR_CLAUDE` and `HAS_MEMORY` blocks are kept, `CODEX` and `NO_MEMORY` blocks are removed.

For Codex: `CODEX` and `NO_MEMORY` blocks are kept, `CURSOR_CLAUDE` and `HAS_MEMORY` blocks are removed.

### WebSearch/WebFetch Handling

The templates use explicit `WebFetch`/`WebSearch` tool names (Cursor/Claude Code style). The sync script automatically strips these to generic verbs ("Crawl", "Search") when generating Codex output. This means you can write instructions using `WebFetch`/`WebSearch` naturally — the sync script handles the adaptation.

## What's IDE-Specific (edit directly, not via templates)

| Component | Location | Why it's separate |
|---|---|---|
| Agent definitions | `agents/`, `plugins/*/agents/` | Different formats: `.md` (Cursor/Claude) vs `.toml` (Codex) |
| Rules | `plugins/cursor/.../rules/*.mdc`, `plugins/codex/.../rules/*.rules` | Different syntax per IDE |
| Config manifests | `.cursor/plugin.json`, `.codex/config.toml` | Different config formats |
| Install scripts | `plugins/*/install.sh` | Different install targets per IDE |
| MCP config | `mcp.json`, `.mcp.json` | Different config schemas |
| Commands | `commands/` | Claude Code only |
| OpenClaw skill | `plugins/openclaw/` | Self-contained format (claw.json + SKILL.md), not template-compiled |

## Skill Inheritance via Progressive Disclosure

Skills can include a `references/` subdirectory with supporting documents. When the LLM invokes a skill, it reads `SKILL.md` first (the orchestrator), then loads relevant reference files on-demand based on the user's request.

```
shared/skills/adspirer-ads/
  SKILL.md                       ← Orchestrator (all platforms, all workflows)
  references/
    google-ads-advanced.md       ← (future) Deep Google Ads workflows
    meta-ads-advanced.md         ← (future) Deep Meta Ads workflows
    linkedin-ads-advanced.md     ← (future) Deep LinkedIn Ads workflows
    tiktok-ads-advanced.md       ← (future) Deep TikTok Ads workflows
```

Reference files are copied as-is (no template processing needed) since platform-specific content doesn't have IDE-specific variations.

## Scripts

### sync-skills.sh

```bash
# Generate all IDE-specific skill files
./scripts/sync-skills.sh

# Verify generated files match committed files (CI mode)
./scripts/sync-skills.sh --check

# Show diff between generated and committed files
./scripts/sync-skills.sh --diff
```

### validate.sh

```bash
# Run all offline checks (39 checks)
./scripts/validate.sh

# Also test MCP endpoint connectivity
./scripts/validate.sh --live
```

Checks performed:
1. Sync consistency (templates match committed skills)
2. Frontmatter validation (name + description fields)
3. Skill inventory (all 5 skills in all 3 IDE targets)
4. Context file correctness (no cross-contamination)
5. No leaked template markers
6. Codex extras preserved (openai.yaml)
7. OpenClaw files present (claw.json + SKILL.md with valid metadata)
8. Shared templates exist
9. MCP endpoint reachable (with `--live`)
