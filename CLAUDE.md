# CLAUDE.md — Project Instructions for ads-mcp

## What This Repo Is

Public monorepo for the Adspirer MCP server registration and multi-IDE plugin distribution. Ships plugins for Claude Code, Cursor, Codex, and OpenClaw — all from a single repo. The actual backend (tool implementations, Cloud SQL, ad platform integrations) lives in a private repo.

## Architecture: Shared Skills + Shared Agent Prompt

Skills are authored once as templates in `shared/skills/`, and the performance marketing agent prompt is authored once in `shared/agents/`, then compiled into IDE-specific versions by `scripts/sync-skills.sh`. This is the core architecture — understand it before making changes.

```
shared/skills/              ← SOURCE OF TRUTH (edit here)
    adspirer-ads/SKILL.md
    adspirer-setup/SKILL.md
    adspirer-performance-review/SKILL.md
    adspirer-write-ad-copy/SKILL.md
    adspirer-wasted-spend/SKILL.md

plugins/cursor/.../skills/  ← GENERATED (never edit directly)
plugins/codex/.../skills/   ← GENERATED (never edit directly)
skills/ad-campaign-management/ ← GENERATED (never edit directly)

shared/agents/performance-marketing-agent/PROMPT.md ← SOURCE OF TRUTH (edit here)
agents/performance-marketing-agent.md               ← GENERATED (never edit directly)
plugins/cursor/.../agents/performance-marketing-agent.md ← GENERATED (never edit directly)
plugins/codex/.../agents/performance-marketing-agent.toml ← GENERATED (never edit directly)

plugins/openclaw/           ← STANDALONE (edit directly, not templated)
```

**Critical rule:** Never edit files in `plugins/*/skills/`, `skills/`, `agents/`, or `plugins/*/agents/` directly — they are generated and will be overwritten by `sync-skills.sh`.

## Template Syntax

Templates use two mechanisms:

**Variables** — replaced per IDE:
- `{{CONTEXT_FILE}}` → BRAND.md (Cursor), AGENTS.md (Codex), CLAUDE.md (Claude Code)
- `{{AUTH_TROUBLESHOOT}}` → IDE-specific auth recovery instructions

**Conditional blocks** — include/exclude per IDE:
```markdown
<!-- BEGIN:CURSOR_CLAUDE -->
Content for Cursor and Claude Code only
<!-- END:CURSOR_CLAUDE -->

<!-- BEGIN:CODEX -->
Content for Codex only
<!-- END:CODEX -->

<!-- BEGIN:HAS_MEMORY -->
Content for IDEs with persistent memory (Cursor, Claude Code)
<!-- END:HAS_MEMORY -->

<!-- BEGIN:NO_MEMORY -->
Content for IDEs without memory (Codex)
<!-- END:NO_MEMORY -->
```

## Common Tasks

### Editing an existing skill

1. Edit the template in `shared/skills/<skill>/SKILL.md`
2. Run `./scripts/sync-skills.sh`
3. Run `./scripts/validate.sh`
4. Commit all generated files along with the template

### Editing the performance marketing agent (all IDEs)

1. Edit `shared/agents/performance-marketing-agent/PROMPT.md`
2. Run `./scripts/sync-skills.sh`
3. Run `./scripts/validate.sh`
4. Commit generated agent outputs:
   - `agents/performance-marketing-agent.md`
   - `plugins/cursor/adspirer/.cursor/agents/performance-marketing-agent.md`
   - `plugins/codex/adspirer/agents/performance-marketing-agent.toml`

### Adding a new skill (e.g., adspirer-youtube-ads)

1. Create `shared/skills/adspirer-youtube-ads/SKILL.md` with template syntax
2. Run `./scripts/sync-skills.sh` — all IDEs get the new skill automatically
3. Run `./scripts/validate.sh` — auto-discovers and validates the new skill
4. Update documentation:
   - `plugins/cursor/adspirer/README.md` — add row to skills table
   - `plugins/codex/adspirer/README.md` — add row to skills table
   - `docs/changelog.md` — add entry
5. Optional: add a Claude Code slash command in `commands/`
6. If agent behavior should change for the new skill, update `shared/agents/performance-marketing-agent/PROMPT.md`
7. Commit everything

**No script changes needed** — install scripts, sync, and validation all auto-discover from `shared/skills/`.

### Adding a new IDE plugin (e.g., Windsurf)

See `docs/adding-ides.md` for full instructions.

### Adding a new ad platform (e.g., Snapchat)

See `docs/adding-platforms.md` for full instructions.

## Scripts

```bash
./scripts/sync-skills.sh          # Generate IDE-specific skills from templates
./scripts/sync-skills.sh --check  # Verify generated files match committed (CI mode)
./scripts/sync-skills.sh --diff   # Show differences
./scripts/validate.sh             # Run all offline validation checks
./scripts/validate.sh --live      # Also test MCP endpoint connectivity
```

Always run both sync and validate before committing skill changes.

## Key Files

| File | Purpose | Edit directly? |
|------|---------|---------------|
| `shared/skills/*/SKILL.md` | Canonical skill templates | Yes — this is the source of truth |
| `scripts/sync-skills.sh` | Template compiler | Only when adding a new IDE |
| `scripts/validate.sh` | Validation suite | Only when adding new check types |
| `shared/agents/performance-marketing-agent/PROMPT.md` | Canonical cross-IDE agent prompt | Yes — source of truth |
| `agents/performance-marketing-agent.md` | Generated Claude Code agent definition | No — overwritten by sync |
| `plugins/cursor/adspirer/.cursor/agents/` | Generated Cursor agent definition | No — overwritten by sync |
| `plugins/codex/adspirer/agents/` | Generated Codex agent definition | No — overwritten by sync |
| `plugins/openclaw/SKILL.md` | OpenClaw standalone skill | Yes (not templated) |
| `plugins/*/install.sh` | One-command installers | Yes (auto-discover skills) |
| `server.json` | MCP registry metadata | Yes |
| `plugins/*/skills/*/SKILL.md` | Generated IDE skills | No — overwritten by sync |
| `skills/ad-campaign-management/SKILL.md` | Generated Claude Code skill | No — overwritten by sync |

## Directory Layout

```
ads-mcp/
├── shared/skills/                  # Skill templates (source of truth)
├── shared/agents/                  # Agent prompt templates (source of truth)
├── scripts/                        # sync-skills.sh, validate.sh
├── plugins/
│   ├── cursor/adspirer/            # Cursor plugin (agent, rules, generated skills, installer)
│   ├── codex/adspirer/             # Codex plugin (agent, rules, generated skills, installer)
│   └── openclaw/                   # OpenClaw skill (standalone claw.json + SKILL.md)
├── agents/                         # Generated Claude Code agent definition
├── skills/                         # Claude Code generated skill
├── commands/                       # Claude Code slash commands
├── .claude-plugin/                 # Claude Code plugin metadata
├── docs/                           # Developer docs (architecture, adding platforms/IDEs, changelog)
├── server.json                     # MCP registry
├── .mcp.json                       # MCP server config
├── README.md                       # Public-facing README
├── CONNECTING.md                   # Setup guide for all platforms
├── monorepo-restructure-plan.md    # Architecture decision record
└── PRIVACY.md, TERMS.md, etc.     # Legal
```

## Guardrails

- Do not deploy to Cloud Run or push to remote without explicit confirmation
- Do not modify `plugins/*/skills/`, `skills/`, `agents/`, or `plugins/*/agents/` directly — use `shared/skills/` and `shared/agents/`
- Run `validate.sh` before every commit that touches skills
- All campaigns created by skills must use PAUSED status
- Never commit secrets (.env, credentials, tokens)
