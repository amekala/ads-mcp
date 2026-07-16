# The Adspirer get-started skill — agent-native signup

Website copy + rationale for distributing Adspirer onboarding as an
installable agent skill, modeled on here.now's distribution pattern
(`npx skills add heredotnow/skill --skill here-now -g`).

## What it is

`skills/adspirer-get-started/SKILL.md` is a small, self-contained skill whose
only job is onboarding: detect which AI client the agent is running in,
install the right Adspirer artifact (Claude Code plugin, Claude/ChatGPT
connector, Cursor/Codex MCP config, Gemini extension), walk the user through
the OAuth signup (sign in with Google/email → account created → connect ad
platforms → plan), and verify with `get_connections_status` before handing
off to `start_here` or `/adspirer:setup`.

The classic web signup flow (read → email → web app → onboarding → connect
ads → pick plan) stays as-is. This is a parallel, agent-native funnel: the
user starts inside the AI client they already use, and the OAuth redirect IS
the signup.

## Website section (drop-in copy)

---

### Add Adspirer to your AI agent

Have your agent set Adspirer up for you — installation, account, ad platform
connections, first campaign review.

**If you have npm** (installs for Claude Code, Cursor, Codex, and more):

```bash
npx skills add amekala/ads-mcp --skill adspirer-get-started -g
```

**If not** (Claude Code / Claude Cowork):

```bash
curl -fsSL https://www.adspirer.com/install.sh | bash
```

**No terminal at all?** Paste this into Claude, ChatGPT, or any assistant
that can read the web:

> Fetch https://raw.githubusercontent.com/amekala/ads-mcp/main/skills/adspirer-get-started/SKILL.md
> and follow it to set up Adspirer for me.

Then say **"set up adspirer"** — your agent takes it from there. New
campaigns are always created paused; nothing spends without your say-so.

---

## Hosting checklist (to go live)

1. Serve `scripts/install-skill.sh` at `https://www.adspirer.com/install.sh`
   (redirect or copy; the script itself downloads the skill from raw
   GitHub `main`, so it always installs the latest version).
2. Add the section above to the website (docs page and/or landing page).
3. Optional: register the skill on skills.sh (the `npx skills` registry
   indexes public GitHub repos with `skills/` directories automatically —
   verify `amekala/ads-mcp` appears and the exact add command works).

## How each path works

| Path | Mechanism | Reaches |
|---|---|---|
| `npx skills add amekala/ads-mcp --skill adspirer-get-started -g` | Vercel `skills` CLI reads this repo's `skills/` dir, installs to every detected agent's global skills location | Claude Code, Cursor, Codex, other CLI agents |
| `curl … install.sh \| bash` | Downloads SKILL.md into `~/.claude/skills/adspirer-get-started/` (auto-discovered, no install step) | Claude Code, Claude Cowork |
| Paste-a-prompt | Agent fetches the SKILL.md from raw GitHub and follows it as instructions | claude.ai, ChatGPT web/desktop — anything with web fetch |
| Plugin (existing) | The same skill ships inside the plugin, so plugin users get onboarding help for teammates/other machines | Claude Code / Cowork plugin installs |

## Maintenance

- The skill carries a `Skill version:` line — bump it when content changes.
- It deliberately defers volatile facts (pricing, quotas, per-client quirks)
  to https://www.adspirer.com/docs and CONNECTING.md, so it goes stale
  slowly. Keep those pages current instead.
- CI validates its frontmatter like every other skill
  (`scripts/validate-frontmatter.mjs`).
