# Claude Plugin Update Playbook & Capability Roadmap

How Adspirer's Claude Code / Cowork plugin updates actually reach users, the
versioning policy we follow (and why), the CI gates that protect releases, and
the plugin capabilities we are not yet using — with concrete implementation
sketches, prioritized.

Sources: [Plugins reference](https://code.claude.com/docs/en/plugins-reference),
[Plugin marketplaces](https://code.claude.com/docs/en/plugin-marketplaces),
[Plugin hints](https://code.claude.com/docs/en/plugin-hints). Verified against
the live docs on 2026-07-16.

---

## 1. How an update reaches users (three channels)

### a. Community marketplace (`adspirer-ads-agent@claude-community`) — most installs

```
push to the repo pinned in the catalog entry
        │  (currently amekala/adspirer-mcp-plugin — until the
        │   adspirer-advertising-agent portal submission replaces it)
        ▼
nightly bump sweep (bump-plugin-shas.yml, ~07:23 UTC daily)
        │  validates the repo at HEAD — manifest + frontmatter of every
        │  skill/command/agent file. A failure = SILENT SKIP, visible only
        │  in the Actions logs of anthropics/claude-plugins-community.
        ▼
bump(adspirer-...) PR auto-opened → Anthropic maintainer merges
        ▼
marketplace.json source.sha advances → users' /plugin update picks it up
        ▼
claude.com/plugins (Cowork directory) syncs nightly — allow +1 day
```

**The three-month lesson (issue #964):** one unquoted `: ` in a command's
frontmatter made validation fail at HEAD, so the sweep skipped us every night
from April to July with no notification. The listing description, category,
and displayed metadata do NOT update via the bump — only `source.sha` moves.
Copy changes require a new portal submission.

**Rules that follow:**
- Every push to the pinned repo must pass `claude plugin validate --strict`
  AND the frontmatter check (CI enforces both — see §3).
- After pushing, confirm the next morning that a `bump(...)` PR appeared in
  `anthropics/claude-plugins-community`; if it didn't, read the latest
  `bump-plugin-shas` run log and grep for our plugin name.
- Keep `amekala/adspirer-mcp-plugin` synced from this repo until the portal
  submission repointing the listing at `amekala/ads-mcp` is published.

### b. Self-hosted marketplace (`/plugin marketplace add amekala/ads-mcp`)

Our own `.claude-plugin/marketplace.json` serves users and teams directly from
this repo. Updates are instant on push — no Anthropic pipeline involved. The
`renames` map migrates users from the old `adspirer-ads-agent` name
(requires Claude Code ≥ 2.1.193).

### c. Partner listing (`anthropics/knowledge-work-plugins`)

Anthropic-internal contributions only; external PRs are closed. Refreshes
happen via staff bulk passes. Nothing to operate here — coordinate through
our Anthropic partner contact.

---

## 2. Versioning policy: commit-SHA, not explicit versions

**Decision: do NOT set `version` in `.claude-plugin/plugin.json`.**

Anthropic's version resolution order (plugins-reference → Version management):

1. `version` in `plugin.json` ← wins if present
2. `version` in the marketplace entry
3. **git commit SHA** ← what we use
4. `unknown`

The docs' own guidance:

> "If you set `version` in `plugin.json`, you must bump it every time you want
> users to receive changes. **Pushing new commits alone is not enough**...
> If you're iterating quickly, leave `version` unset so the git commit SHA is
> used instead."

| Approach | Update behavior | Docs say best for |
|---|---|---|
| Explicit `"version": "x.y.z"` | Users update ONLY when the string changes | "Published plugins with stable release cycles" |
| Commit SHA (no `version` field) | Users update on every new commit / pin bump | "Plugins under active development" |

Why SHA is right for us:

- We ship weekly (13-skill rewrite, host surfaces, router contract — all this
  month). An explicit version is a second manual gate stacked on top of the
  community pin, and forgetting it strands every installed user on old code
  **with no error anywhere**.
- This has bitten us twice: `2.0.0` was deliberately removed on 2026-06-29
  (`f8afa19`) and accidentally re-added in the skills rewrite (`76b05ab`);
  the old repo shipped pinned `2.1.1` the same way.
- The community catalog's `source.sha` pin already provides release gating —
  Anthropic reviews and merges every bump PR.

**Guardrails:**
- Keep a human-readable version in `server.json` / release notes if needed
  for marketing — just never in `plugin.json` or the marketplace entry.
- If we ever move to a stable-release model (e.g., enterprise customers who
  want pinned upgrades), switch deliberately: add `version`, bump every
  release, document in a CHANGELOG, and use `claude plugin tag` for release
  tags. Until then, CI blocks any PR that re-adds a `version` field (see §3).
- Note a validator quirk: `claude plugin validate --strict` treats a *missing*
  version as a warning→error, which is why CI runs plain `validate` plus an
  explicit no-version guard instead of `--strict`.

---

## 3. CI gates (added 2026-07-16)

`.github/workflows/validate-plugin.yml` runs on every PR and push to main:

1. `claude plugin validate .` — manifest and marketplace schema (plain, not
   `--strict`: strict mode errors on our deliberate omission of `version`).
2. No-version guard — fails the build if a `version` field reappears in
   `plugin.json` or `marketplace.json` (§2).
3. `node scripts/validate-frontmatter.mjs` — parses the YAML frontmatter of
   every tracked `.md` file. This is the check the Anthropic sweep runs that
   the local CLI does not; it is what would have caught the April bug the day
   it was written.

Frontmatter rule of thumb: quote any value containing `": "` or starting with
`<`, `[`, `{`.

---

## 4. Capabilities in use (keep)

| Capability | How we use it |
|---|---|
| `skills/` (16 dirs) | Correct multi-skill `SKILL.md` layout |
| `commands/` (5 .md) | Slash commands (`/adspirer:setup`, …) |
| `agents/` | `performance-marketing-agent` with advanced frontmatter: `memory: project`, `skills:` preload, `tools`, `model` |
| `settings.json` `agent` key | Makes our agent the session default — one of only two supported keys |
| `.mcp.json` | Remote HTTP MCP server (`mcp.adspirer.com/mcp`, OAuth 2.1) |
| Marketplace `renames` | Migrates `adspirer-ads-agent` → `adspirer-advertising-agent` |
| Manifest metadata | `displayName`, `author`, `keywords`, `license`, `homepage`, `repository` |

---

## 5. Capabilities NOT in use — roadmap

### P1 — high value, low effort

**`SessionStart` hook: pending-actions greeting.**
No ad plugin in the directory does this. On session start, surface pending
Adspirer approvals/signals so Claude opens with "you have 2 pending campaign
approvals."
```json
// hooks/hooks.json
{
  "hooks": {
    "SessionStart": [
      { "hooks": [ { "type": "command",
        "command": "\"${CLAUDE_PLUGIN_ROOT}\"/scripts/pending-actions.sh" } ] }
    ]
  }
}
```
The script calls our REST API (`api.adspirer.ai`) with the user's stored
token and prints a one-line summary; stdout from a SessionStart hook lands in
Claude's context. Degrade to silence when not authenticated. Keep output ≤ 1
line — it is a per-session token cost.

**Token-cost audit.** Run `claude plugin details adspirer-advertising-agent`.
Every skill/command/agent description loads into every session ("always-on"
cost). With 16 skills we are likely one of the heavier plugins in the
directory; tighten the wordiest descriptions (several run 500+ chars).

**`$schema` in plugin.json** — editor autocomplete/validation:
`"$schema": "https://json.schemastore.org/claude-code-plugin-manifest.json"`.

### P2 — differentiated, moderate effort

**`PreToolUse` guardrail hook.** Client-side second layer on top of
server-side PAUSED-by-default: match our own write tools and require
confirmation context for budget/status changes. Matchers must use the scoped
name form for plugin-bundled servers:
`mcp__plugin_adspirer-advertising-agent_adspirer__<tool>` — a matcher on the
bare server key never fires.

**Monitor (experimental): watch signals in-session.** Today triggered
Adspirer monitors reach users by email only. A plugin monitor polls and
notifies Claude live:
```json
// monitors/monitors.json
[ { "name": "adspirer-signals",
    "command": "\"${CLAUDE_PLUGIN_ROOT}\"/scripts/poll-signals.sh",
    "description": "Triggered Adspirer campaign alerts (ROAS/CPA/budget)" } ]
```
Caveats: experimental schema (declare under `experimental.monitors` when the
docs flip), interactive-CLI-only, does not load for project-scope installs.

### P3 — structural / strategic

**Slim the shipped plugin.** The marketplace source is the repo root, so
`cookbook/`, `docs/`, `dist/*.zip`, and five other hosts' plugin trees are
copied into every user's plugin cache. Fix options: move the Claude plugin
to a subdirectory and use a `git-subdir` source (sparse clone, built for
monorepos), or trim what's committed. Coordinate with a portal resubmission
since the community entry's source path would change.

**Enterprise managed-settings distribution (sales channel).** Customer org
admins can pre-provision Adspirer for every seat: `extraKnownMarketplaces`
(+ `enabledPlugins`) in their `managed-settings.json`, allowlisted via
`strictKnownMarketplaces`. Write a one-page setup guide for enterprise
customers — distribution that doesn't depend on Anthropic curation.

**Official marketplace (`claude-plugins-official`).** No application process —
Anthropic curates at its discretion; the docs say to coordinate through a
partner contact (ours: the maintainers who added/refreshed our
knowledge-work-plugins entry). Assets for the pitch: install count, clean
listing, safety posture (PAUSED-by-default, privacy policy, no telemetry),
validation hygiene. Official listing unlocks the **hint protocol**: a CLI we
ship could emit `<claude-code-hint v="1" type="plugin"
value="...@claude-plugins-official" />` and Claude Code itself prompts users
to install us. Hints referencing community-marketplace plugins are dropped,
so this is post-listing only.

### Not applicable (documented so we don't revisit)

- **LSP servers, themes, output styles** — we're not a code-language plugin.
- **Channels** — requires a plugin-*bundled* MCP server; ours is remote HTTP.
- **`bin/` executables** — MCP covers our surface; revisit only if we ship a CLI.
- **`userConfig`** — OAuth + server-side account state already handle per-user
  config; revisit if we ever need a client-side default (e.g., brand ID).
- **`defaultEnabled: false`** — docs suggest it for external-service plugins,
  but directory installs are already explicit opt-in; keep default.

---

## 6. Release checklist

1. `claude plugin validate . --strict` && `node scripts/validate-frontmatter.mjs` (CI enforces).
2. No `version` field in `plugin.json` or marketplace entries (§2).
3. Tool-count/platform claims consistent — standardized on **"400+ tools"**
   (live router counts 2026-07-16: Google 151, Amazon 61, Meta 58, LinkedIn 54,
   TikTok 37, ChatGPT 31, monitoring 16, GA4 7).
4. Sync `amekala/adspirer-mcp-plugin` (community-pinned repo) until the
   repoint submission publishes.
5. Next morning: confirm the `bump(...)` PR opened and merged in
   `anthropics/claude-plugins-community`.
6. Listing copy changes (description, category, name) → portal resubmission
   (`platform.claude.com/plugins/submit`), category stays **productivity**.
