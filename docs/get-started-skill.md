# The Adspirer get-started skill — agent-native signup

Website copy + rationale for distributing Adspirer onboarding as an
installable agent skill, modeled on here.now's distribution pattern
(`npx skills add heredotnow/skill --skill here-now -g`).

## What it is

`skills/adspirer-get-started/SKILL.md` is a small, self-contained skill whose
only job is onboarding: detect which AI client the agent is running in —
distinguishing **chat apps** (Claude web/Cowork, the ChatGPT app: no shell,
directory-listing installs only) from **coding agents** (Claude Code, Cursor,
Codex, Gemini CLI) — install the right Adspirer artifact, walk the user
through the OAuth signup (sign in with Google/email → account created →
connect ad platforms → plan), and verify with `get_connections_status`
before handing off to `start_here` or `/adspirer:setup`.

For chat apps it leads with the official listings Adspirer already has:
the [ChatGPT App Store listing](https://chatgpt.com/apps/adspirer/asdk_app_69461dc91ee48191ae4a14eb9bde1c21)
and the [Claude plugin directory listing](https://claude.ai/directory/plugins/adspirer-ads-agent%40knowledge-work-plugins),
falling back to custom-connector setup only when a listing isn't available
on the user's plan or workspace.

The classic web signup flow (read → email → web app → onboarding → connect
ads → pick plan) stays as-is. This is a parallel, agent-native funnel: the
user starts inside the AI client they already use, and the OAuth redirect IS
the signup.

## Website section (drop-in copy)

---

### Add Adspirer to your AI

One command (or one tap) — your agent handles the rest: installation,
account sign-in, connecting your ad platforms.

**Using the ChatGPT or Claude app?** Install with one tap:

- ChatGPT: [Adspirer on the ChatGPT App Store](https://chatgpt.com/apps/adspirer/asdk_app_69461dc91ee48191ae4a14eb9bde1c21)
- Claude: [Adspirer in the Claude plugin directory](https://claude.ai/directory/plugins/adspirer-ads-agent%40knowledge-work-plugins)

Or paste a prompt instead. **In Claude:**

> Fetch https://raw.githubusercontent.com/amekala/ads-mcp/main/skills/adspirer-get-started/SKILL.md
> and follow it to set up Adspirer for me.

**In ChatGPT** (which won't follow fetched files, by design — ask it to act
for you instead):

> Find the Adspirer app in the app store and help me install and connect it
> so I can manage my ad campaigns from this chat.

**In a terminal?** One command installs the skill and drops you straight
into setup (launches Claude Code automatically when it's installed):

```bash
curl -fsSL https://www.adspirer.com/install.sh | bash
```

With npm instead (installs the skill for Claude Code, Cursor, Codex, and
more, then starts setup):

```bash
npx skills add amekala/ads-mcp --skill adspirer-get-started -g && claude "set up adspirer"
```

New campaigns are always created paused; nothing spends without your
say-so.

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
| Paste-a-prompt (fetch-style) | Agent fetches the SKILL.md from raw GitHub and follows it as instructions | Claude (claude.ai / desktop). **Not ChatGPT** — it refuses to follow fetched files (verified 2026-07-16); give ChatGPT users the intent-framed prompt or the App Store link instead |
| Plugin (existing) | The same skill ships inside the plugin, so plugin users get onboarding help for teammates/other machines | Claude Code / Cowork plugin installs |

## Maintenance

- The skill carries a `Skill version:` line — bump it when content changes.
- It deliberately defers volatile facts (pricing, quotas, per-client quirks)
  to https://www.adspirer.com/docs and CONNECTING.md, so it goes stale
  slowly. Keep those pages current instead.
- CI validates its frontmatter like every other skill
  (`scripts/validate-frontmatter.mjs`).
