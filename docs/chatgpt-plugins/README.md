# ChatGPT plugins: how we build and ship them

OpenAI's plugin directory (shared by ChatGPT and Codex) takes a **ZIP upload**. There's no Git
integration: the repo is where we keep the source so each ZIP can be rebuilt exactly.

Rules checked against OpenAI's docs on 2026-09-30:
[package](https://developers.openai.com/plugins/build/plugins) ·
[submit](https://developers.openai.com/plugins/deploy/submission) ·
[errors](https://developers.openai.com/plugins/deploy/submission-errors) ·
[guidelines](https://developers.openai.com/plugins/plugin-guidelines) ·
[MCP review](https://developers.openai.com/plugins/deploy/app-review).
Append `.md` to any of those URLs for the raw text. Re-read them before each submission; they change.

## Where things live

| Path | What |
|---|---|
| `plugins/chatgpt/<plugin>/` | The plugin root: exactly what goes in the ZIP |
| `plugins/chatgpt/<plugin>/plugin.json` | Identity, listing text, icons, onboarding skill, review test cases, release notes |
| `plugins/chatgpt/<plugin>/mcp.json` | The one remote MCP server |
| `plugins/chatgpt/<plugin>/skills/<skill>/SKILL.md` | Bundled skills (auto-discovered) |
| `plugins/chatgpt/<plugin>/assets/` | `logo` and `composerIcon` (square, at least 48x48) |
| `docs/chatgpt-plugins/<plugin>.md` | Everything entered in the portal instead of the ZIP: reviewer credentials (where they're kept, never the password), domain verification, the demo video, open blockers |
| `scripts/validate-chatgpt-plugin.mjs` | Checks the published rules |
| `scripts/package-chatgpt-plugin.sh <plugin>` | Validates (including live URL checks), then writes `dist/chatgpt/<plugin>-<version>.zip` |

`plugins/chatgpt/adspirer/` is the older skills-only upload for the main Adspirer app and is built
by `scripts/package-chatgpt-skills.sh`. It's a different thing; don't mix them.

## Branch

Work happens on the long-running `chatgpt-plugins` branch, checked out in its own worktree at
`../ads-mcp-chatgpt-plugins`. Merge it into `main` through a PR after each submitted version. Tag the
exact commit you uploaded as `chatgpt/<plugin>/v<version>`, so a ZIP can always be rebuilt from that
tag.

## Release steps

1. **Bump `version`** in `plugin.json`. The portal rejects a re-upload with an unchanged version.
2. **Edit** listing text, skills, or test cases. Keep the limits in mind (the validator enforces them):
   - name 30 characters and subtitle (`shortDescription`) 30 characters, one line each
   - long description 4,000 characters
   - up to 3 starter prompts, 128 characters each, no `@mentions`
   - category from OpenAI's fixed list
   - four HTTPS URLs: website, support, privacy and terms, all public
3. **Build:** `./scripts/package-chatgpt-plugin.sh <plugin>`. Fix every error it reports.
4. **Upload** at <https://platform.openai.com/plugins>, under "Upload new or existing plugin" and the
   verified developer identity (BETSONAGI LLC). For an update, open the existing plugin and choose
   **Upload plugin to make changes**.
5. **Resolve findings:**
   - **Metadata & Skills:** skill scans can take up to 2 hours.
   - **MCPs:** connect the server, pass domain verification, and complete OAuth.
   - Use **Copy issues**, fix the source here, rebuild and re-upload.
6. **Review details (portal only):** reviewer credentials and the demo video URL, if it isn't in
   the ZIP. Then **Submit for review** and complete the attestations.
7. **Publish** once it's approved. Tag the commit.

## What needs a new ZIP and what doesn't

| Change | What to do |
|---|---|
| Listing text, icons, skills, test cases, release notes | New version plus a ZIP upload |
| Tool descriptions, schemas or annotations on the MCP server | Deploy the server, then **Rescan** in the portal. No ZIP |
| MCP URL (path or host) | Contact OpenAI support. The submission guide says URL changes aren't supported in the update flow; the review guide says a path change can ship as a new version. Assume support is needed |
| MCP origin (`mcp.adspirer.com`) | Not allowed. It would have to be a brand-new plugin |

After publication OpenAI rescans the server daily. A changed tool keeps its old approved definition
until the new one passes, so keep old input schemas working during that gap.

## Never put in the ZIP

- Passwords or reviewer instructions (`test_credentials` / `reviewer_instructions` are rejected)
- `.app.json` or `apps` (references to an existing app) and lifecycle hooks: both block submission
- `.codex-plugin/` alongside `extensions.com.openai`. It's ignored, so keep one source of truth
- Pricing, plans, trials or upgrade prompts, anywhere in listing text, skills or tool output
