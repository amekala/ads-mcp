# ads-mcp: Shared Skills Architecture

> **Status**: Implemented. This document describes the architecture as built, not a future proposal.
>
> **History**: The original plan proposed separate repos with a sed/awk build pipeline. A second iteration proposed symlinks. Both were replaced by the current approach: template compilation with conditional blocks. See [Appendix A](#appendix-a-archived-plans) for the archived plans.

---

## Context

The `ads-mcp` public repo bundles the MCP registry listing plus plugins for 4 platforms: Claude Code (at repo root), Cursor (`plugins/cursor/`), Codex (`plugins/codex/`), and OpenClaw (`plugins/openclaw/`). Skills are ~95% identical across the 3 template-compiled IDEs — only context file names, auth instructions, tool availability, and memory support differ. OpenClaw uses a standalone skill with a different structure.

**The problem this solves**: ~1,300 lines of skill content were duplicated across IDE plugins. When a new ad platform is added (YouTube Ads, Snapchat Ads) or a workflow changes, the same edit had to be made in 3 places. As skills grow, this drift compounds. Adding a new skill for N IDEs should be O(1) editing, not O(N).

**What this repo is NOT**: This is a public repo for MCP server registration and client-side plugin distribution. The actual backend — tool implementations, Cloud SQL connections, ad platform integrations, deployments — lives in a private repo.

---

## Architecture: Single Repo, Shared Templates, Build-Time Compilation

### How it works

1. **Author once** in `shared/skills/` — templates with `{{variables}}` and `<!-- BEGIN:BLOCK -->` conditional blocks
2. **Run `scripts/sync-skills.sh`** — compiles templates into IDE-specific skill files
3. **Commit both** the templates and the generated files
4. **Validate with `scripts/validate.sh`** — 39 checks ensure consistency

### Why not separate repos?

Every major platform natively supports subdirectories within a single repo:

| Platform | Subdirectory Support | Mechanism |
|---|---|---|
| **Cursor** | Yes, native | `marketplace.json` maps plugin names to subdirectories |
| **Claude Code** | Yes, native | Marketplace `source` field supports relative paths |
| **Codex** | Yes, native | Skills are directories with `SKILL.md` — scans from CWD to repo root |
| **MCP Registry** | Yes, native | `server.json` has `repository.subfolder` field |
| **GitHub raw URLs** | Yes | Full path-based access to any file in any subdirectory |

### Why not symlinks?

An earlier iteration of this plan proposed symlinking `plugins/*/skills/` to `shared/skills/`. This was rejected because:

1. **GitHub raw URLs don't follow symlinks** — install scripts that `curl` from `raw.githubusercontent.com` would get the symlink text, not the file content
2. **The IDE differences turned out to be more than variable substitution** — Codex needs WebSearch/WebFetch tool references stripped, memory blocks removed, and different auth troubleshooting text. Symlinks can't handle conditional content.
3. **Generated files are always correct** — no risk of broken symlink resolution at clone time or on Windows

### What differs per IDE

| Component | Why it differs | Handling |
|---|---|---|
| Context file name | `CLAUDE.md` vs `BRAND.md` vs `AGENTS.md` | `{{CONTEXT_FILE}}` variable |
| Auth troubleshooting | Browser OAuth vs CLI login | `{{AUTH_TROUBLESHOOT}}` variable |
| Memory support | Cursor + Claude Code have it, Codex doesn't | `<!-- BEGIN:HAS_MEMORY -->` / `<!-- BEGIN:NO_MEMORY -->` blocks |
| IDE-specific instructions | Different step-by-step flows | `<!-- BEGIN:CURSOR_CLAUDE -->` / `<!-- BEGIN:CODEX -->` blocks |
| WebSearch/WebFetch tools | Cursor + Claude Code have native web tools, Codex doesn't | Sed-based tool name stripping (see Known Tech Debt) |
| Agent definitions | `.md` (Claude/Cursor) vs `.toml` (Codex) | Separate per IDE, not templated |
| Rules | `.mdc` (Cursor) vs `.rules` (Codex) | Separate per IDE, not templated |
| Config manifests | `plugin.json` vs `config.toml` | Separate per IDE, not templated |
| Install scripts | Different target paths and config formats | Separate per IDE |

### What is shared (the 95%)

- All 5 skill SKILL.md files (~1,300 lines total)
- Tool reference documentation and workflow definitions
- Safety rules within skills (paused campaigns, budget guardrails, confirmation requirements)
- Campaign management procedures (research, creation, optimization, reporting)

---

## Directory Structure

```
ads-mcp/
├── shared/                                    # SOURCE OF TRUTH — edit here
│   └── skills/
│       ├── adspirer-ads/SKILL.md             # ~472 lines — main campaign management skill
│       ├── adspirer-setup/SKILL.md           # ~154 lines — brand workspace bootstrap
│       ├── adspirer-write-ad-copy/SKILL.md
│       ├── adspirer-wasted-spend/SKILL.md
│       └── adspirer-performance-review/SKILL.md
│
├── scripts/
│   ├── sync-skills.sh                        # Template compiler (generates IDE-specific skills)
│   └── validate.sh                           # 39-check validation suite
│
├── [ROOT — Claude Code plugin + MCP registry]
│   ├── .claude-plugin/
│   ├── agents/performance-marketing-agent.md
│   ├── skills/ad-campaign-management/SKILL.md  # GENERATED from shared/skills/adspirer-ads
│   ├── commands/                               # Claude Code only (setup, wasted-spend, etc.)
│   ├── .mcp.json, server.json, settings.json
│   └── README.md, TERMS.md, PRIVACY.md, etc.
│
├── plugins/
│   ├── cursor/adspirer/
│   │   ├── .cursor/
│   │   │   ├── plugin.json
│   │   │   ├── agents/performance-marketing-agent.md
│   │   │   ├── rules/use-adspirer.mdc, brand-workspace.mdc
│   │   │   └── skills/                         # GENERATED — 5 skills
│   │   ├── mcp.json
│   │   ├── install.sh
│   │   └── README.md
│   ├── codex/adspirer/
│   │   ├── .codex/config.toml
│   │   ├── agents/performance-marketing-agent.toml
│   │   ├── rules/campaign-safety.rules
│   │   ├── skills/                             # GENERATED — 5 skills
│   │   │   └── adspirer-ads/agents/openai.yaml # Codex-specific extra (preserved by sync)
│   │   ├── install.sh
│   │   └── README.md
│   └── openclaw/
│       ├── claw.json                           # Registry manifest (standalone, NOT templated)
│       ├── SKILL.md                            # Self-contained skill (326 lines, NOT generated)
│       └── README.md
│
├── docs/
│   ├── architecture.md                        # Template syntax, sync workflow
│   ├── adding-platforms.md                    # How to add YouTube Ads, Snapchat, etc.
│   └── adding-ides.md                         # How to add Windsurf, Cline, etc.
│
└── .gitignore
```

### Key distinction: GENERATED vs IDE-SPECIFIC

Files in `plugins/*/skills/` and `skills/ad-campaign-management/` are **generated** — never edit them directly. They will be overwritten by `sync-skills.sh`.

Files in `plugins/*/agents/`, `plugins/*/rules/`, `commands/`, and config files are **IDE-specific** — edit them directly. They are not templated because their formats are fundamentally different across IDEs.

---

## Template System

### Variable substitution

Templates use `{{VARIABLE}}` placeholders replaced at build time:

| Variable | Cursor | Codex | Claude Code |
|---|---|---|---|
| `{{CONTEXT_FILE}}` | `BRAND.md` | `AGENTS.md` | `CLAUDE.md` |
| `{{AUTH_TROUBLESHOOT}}` | Reconnect via your AI assistant's connector settings | Run \`codex mcp login adspirer\` to re-authenticate | Reconnect via your AI assistant's connector settings |

### Conditional blocks

Templates use HTML comment markers for IDE-specific sections:

```markdown
<!-- BEGIN:CURSOR_CLAUDE -->
Content only in Cursor and Claude Code versions.
<!-- END:CURSOR_CLAUDE -->

<!-- BEGIN:CODEX -->
Content only in Codex version.
<!-- END:CODEX -->

<!-- BEGIN:HAS_MEMORY -->
Content only for IDEs with persistent memory (Cursor, Claude Code).
<!-- END:HAS_MEMORY -->

<!-- BEGIN:NO_MEMORY -->
Content only for IDEs without memory (Codex).
<!-- END:NO_MEMORY -->
```

### Per-IDE compilation config

| Parameter | Cursor | Codex | Claude Code |
|---|---|---|---|
| `context_file` | BRAND.md | AGENTS.md | CLAUDE.md |
| `keep_block` | CURSOR_CLAUDE | CODEX | CURSOR_CLAUDE |
| `keep_websearch` | yes | no | yes |
| `keep_memory` | yes | no | yes |
| Skills generated | All 5 | All 5 | Only adspirer-ads (renamed `ad-campaign-management`) |

### Why Claude Code only gets 1 generated skill

Claude Code's other 4 workflows (setup, performance-review, write-ad-copy, wasted-spend) are implemented as **slash commands** in `commands/`, not as skills. This is a deliberate design choice — Claude Code's command system provides a better UX for these single-purpose workflows than the skill system does.

---

## Tooling

### sync-skills.sh

The template compiler. Reads templates from `shared/skills/`, applies per-IDE configuration, writes generated files to each IDE's skill directory.

```bash
./scripts/sync-skills.sh          # Generate all IDE-specific skills
./scripts/sync-skills.sh --check  # Verify generated files match committed files (CI mode)
./scripts/sync-skills.sh --diff   # Show differences between generated and committed
```

### validate.sh

Comprehensive validation suite with 39 checks:

```bash
./scripts/validate.sh             # All offline checks
./scripts/validate.sh --live      # Also test MCP endpoint connectivity
```

Checks performed:
1. **Sync consistency** — templates generate files matching committed skills
2. **Frontmatter validation** — all skills have `name` and `description` fields
3. **Skill inventory** — all expected skills present in all IDE targets
4. **Context file correctness** — no cross-contamination (BRAND.md never in Codex, etc.)
5. **No leaked template markers** — no `{{...}}` or `<!-- BEGIN: -->` in generated files
6. **Codex extras preserved** — `openai.yaml` not deleted by sync
7. **OpenClaw files present** — `claw.json` and `SKILL.md` exist with valid metadata
8. **Shared templates exist** — all 5 source templates present
9. **MCP endpoint reachable** (with `--live` flag)

### Workflow: editing a skill

1. Edit the template in `shared/skills/<skill>/SKILL.md`
2. Run `./scripts/sync-skills.sh`
3. Run `./scripts/validate.sh` to verify consistency
4. Commit all generated files along with the template

---

## Scaling: Adding New Skills and IDEs

### Adding a new skill (e.g., YouTube Ads)

1. Create `shared/skills/adspirer-youtube-ads/SKILL.md` with template syntax
2. Run `./scripts/sync-skills.sh` — all 3 IDEs get the new skill automatically
3. If the skill needs a Claude Code command, add `commands/youtube-ads.md`
4. If the skill needs IDE-specific content, add conditional blocks
5. Run `./scripts/validate.sh`, commit

**Effort**: Write once, get 3 IDE versions. This is the core value of the architecture.

### Adding a new IDE (e.g., Windsurf)

1. Create `plugins/windsurf/` with IDE-specific files (agent, rules, config, install.sh)
2. Add the new IDE to `sync-skills.sh` (copy the Cursor block, change variables)
3. Add the new IDE to `validate.sh` (add inventory checks, context file checks)
4. If the IDE has unique constraints, add a new conditional block type (e.g., `<!-- BEGIN:WINDSURF -->`)
5. Run sync + validate, commit

See [docs/adding-ides.md](docs/adding-ides.md) for detailed instructions.

### Adding a new ad platform (e.g., Snapchat Ads)

The backend team adds new MCP tools. On this repo's side:

1. Add the new platform's workflows to `shared/skills/adspirer-ads/SKILL.md`
2. Add platform-specific tools to the tool reference table
3. Optionally create a dedicated skill (e.g., `shared/skills/adspirer-snapchat-ads/SKILL.md`)
4. Run sync + validate, commit

See [docs/adding-platforms.md](docs/adding-platforms.md) for detailed instructions.

---

## Known Tech Debt

### Fragile WebSearch/WebFetch stripping

The sync script uses 16 hardcoded `sed` substitutions to strip `WebSearch`/`WebFetch` tool references for Codex (which doesn't have native web tools). These are brittle — if someone rewrites a sentence in the shared skill that mentions WebFetch, the corresponding sed rule silently stops matching.

**Current approach** (`sync-skills.sh:63-86`):
```bash
# 16 case-specific sed rules like:
sed 's/Use `WebFetch` to crawl/Crawl/g'
sed 's/Use `WebSearch` to search for:/Search for:/g'
# ...etc
```

**Recommended fix**: Replace these with a `<!-- BEGIN:HAS_WEBSEARCH -->` conditional block, matching the pattern already used for memory and IDE blocks. This would:
- Eliminate all 16 fragile sed rules
- Make WebSearch-dependent content explicitly visible in templates
- Follow the same pattern contributors already understand

---

## Platform Inventory

| Platform | Plugin Format | Context File | Agent Format | Skill Format | Status |
|----------|--------------|-------------|-------------|-------------|--------|
| **Claude Code** | `.claude-plugin/`, agents/, skills/, commands/ | `CLAUDE.md` | .md + YAML frontmatter | SKILL.md | Implemented |
| **Cursor** | `.cursor/plugin.json`, agents/, skills/, rules/ | `BRAND.md` | .md + YAML frontmatter | SKILL.md | Implemented |
| **Codex** | `.codex/config.toml`, agents/, skills/, rules/ | `AGENTS.md` | .toml | SKILL.md | Implemented |
| **OpenClaw** | claw.json + SKILL.md | N/A (self-contained) | Embedded in skill | SKILL.md + claw.json | Implemented (standalone) |

### OpenClaw

OpenClaw uses a single self-contained skill (`claw.json` + `SKILL.md`) that combines agent behavior, safety rules, tool reference, pricing, and troubleshooting. Its SKILL.md has a completely different structure — not generated from shared templates. The TypeScript plugin code (OAuth, MCP client, tool registry) is published separately as the `openclaw-adspirer` npm package and installed via `openclaw plugins install openclaw-adspirer`. The skill is listed on [ClawHub](https://clawhub.ai/amekala/adspirer-ads-agent).

---

## Verification Checklist

Current status: **39/39 checks passing**.

- [x] `shared/skills/` contains all 5 canonical templates
- [x] `scripts/sync-skills.sh` generates IDE-specific skills from templates
- [x] `scripts/validate.sh` runs 39 checks with 0 failures
- [x] Cursor skills reference only `BRAND.md`
- [x] Codex skills reference only `AGENTS.md`
- [x] Claude Code skill references only `CLAUDE.md`
- [x] No `{{...}}` or `<!-- BEGIN: -->` markers leak into generated files
- [x] Codex `openai.yaml` extra preserved after sync
- [x] All frontmatter has `name` and `description` fields
- [x] Claude Code root plugin works (agents, commands, generated skill)
- [x] Install scripts reference generated files (not templates)
- [x] OpenClaw skill (`plugins/openclaw/claw.json` + `SKILL.md`) present
- [x] OpenClaw `claw.json` has valid `name` field

### Not yet done

- [ ] GitHub Action to run `validate.sh` on PRs
- [ ] Replace WebSearch/WebFetch sed rules with `<!-- BEGIN:HAS_WEBSEARCH -->` blocks
- [ ] Clean up stale feature branches

---

## Comparison: Evolution of Approaches

| Aspect | Plan A: Separate Repos | Plan B: Symlinks | Implemented: Template Compilation |
|---|---|---|---|
| **Repos** | 4 | 1 | 1 |
| **Build tooling** | build.sh + publish.sh | None | sync-skills.sh (91 lines) |
| **Validation** | None | None | validate.sh (39 checks) |
| **Skill duplication** | Eliminated via `{{vars}}` | Eliminated via symlinks | Eliminated via templates + conditional blocks |
| **IDE-specific content** | sed/awk at publish time | Agent handles it at runtime | Conditional blocks at build time |
| **WebSearch handling** | Template variable | Hope the agent figures it out | Sed stripping (works, but fragile) |
| **Memory handling** | Template variable | Hope the agent figures it out | `<!-- BEGIN:HAS_MEMORY -->` blocks |
| **GitHub raw URLs** | Work (separate repos) | Broken (symlinks not followed) | Work (generated files committed) |
| **CI readiness** | No | No | Yes (`--check` mode) |
| **Adding a new skill** | Edit + rebuild + publish to 3 repos | Edit once | Edit once + run sync |
| **Adding a new IDE** | New repo + publish pipeline | New dir + symlink | New dir + add to sync script |

---

## Appendix A: Archived Plans

<details>
<summary>Click to expand Plan A: Separate Repos (archived)</summary>

### Original Goal

Author shared content in one place (`ads-mcp`), publish each IDE plugin to its own standalone repo for clean installs.

### Why It Was Replaced

1. All major platforms support subdirectories — no need for separate repos
2. Shell-based templating (sed/awk) is fragile for multi-line blocks and special characters
3. 3 extra repos create maintenance overhead
4. publish.sh force-replaces files, destroying standalone git history
5. No CI/CD was defined
6. No versioning strategy

</details>

<details>
<summary>Click to expand Plan B: Symlinks (archived)</summary>

### Goal

Replace duplicated skill files with symlinks pointing to `shared/skills/`.

### Why It Was Replaced

1. **GitHub raw URLs don't follow symlinks** — install scripts that `curl` from `raw.githubusercontent.com` would break
2. **IDE differences are more than variable substitution** — Codex needs WebSearch/WebFetch references stripped, memory blocks removed, different auth text. Symlinks can't conditionally modify content.
3. **Generated files are safer** — no risk of broken symlink resolution on clone, across platforms (Windows), or in CI

### Original Template Variables

| Variable | Cursor | Codex |
|----------|--------|-------|
| `{{CONTEXT_FILE}}` | `BRAND.md` | `AGENTS.md` |
| `{{MEMORY_PATH}}` | `.cursor/memory/.../MEMORY.md` | *(empty — stripped)* |
| `{{TROUBLESHOOT_AUTH}}` | `Reconnect via connector settings` | `Run codex mcp login` |
| `{{AUTH_INSTRUCTIONS}}` | *(multi-line block)* | *(multi-line block)* |

</details>
