# Muse connector (Meta)

Muse is Meta's AI assistant. Its connector platform lets third-party services expose tools to it,
and Adspirer is submitting its MCP server as a connector. This folder holds everything for that
submission. It lives on the long-running `muse-connector` branch, the same way the ChatGPT
plugin work lives on `chatgpt-plugins`.

This repo is public. Keep test credentials and internal security notes out of it.

## Source documents

| Document | URL |
|---|---|
| Connector guidelines | https://muse.ai/platform/docs |
| Connector Platform Terms | https://muse.ai/platform/terms |
| Meta data protection requirements (incorporated DPA) | https://www.facebook.com/legal/terms/Privacy |
| Adspirer privacy policy (must match our answers) | https://www.adspirer.com/privacy (plain text: `/privacy.txt`) |
| Adspirer trust center | https://www.adspirer.com/docs/knowledge-base/security |

## What Muse requires

**Core requirements (guidelines §1)**
- Finish the tasks the connector starts. Don't hand the user back to a website to complete them.
- Add value beyond Muse's own browser. A read-only connector qualifies when the information is
  the outcome; an account performance report counts.

**Tool permissions (§3)**
- Offer a read-only option for account access where the platform allows it.
- Muse sorts every tool into one of three classes:
  - **Read:** no change to data, account state or permissions.
  - **Write:** creates, changes or deletes something.
  - **Sensitive write:** consequential or irreversible, such as spending money, sending email or
    deleting data.
- A tool that both reads and writes counts as a write.
- Sensitive writes ask the user for approval every time; "Always allow" is never offered for them.
- If any detail changes after approval (price, recipient, scope), the user must approve again.
- Tool descriptions must be factual. They must never tell Muse to bypass its rules or take actions
  the user didn't ask for.

**Trust and integrity (§4 and Terms §4.3)**
- Collect only the minimum data needed.
- Data received through the connector may be used only to fulfil the user's request. That rules
  out selling it, using it for unrelated ads, building profiles, inferring sensitive traits or
  training models.
- Delete the data when it's no longer needed, when the user revokes access, or when they ask for
  deletion.
- Encrypt data in transit and sensitive data at rest. Use least privilege and isolate each
  user's data.
- Never put credentials or secrets in prompts, tool descriptions, URLs, analytics or logs.
- **Notify Meta at vendor-incident@meta.com within 48 hours** of any security incident involving
  user data, and cooperate with the investigation.
- Meta may audit compliance once a year, or more often if it suspects a material violation.
- Adspirer and Meta are each an **independent controller** of the user data.

## Submission checklist (guidelines §5)

| # | Item | Status |
|---|---|---|
| 5.1 | Connector overview: users, tasks, why it beats the browser, account/plan/region limits | To do |
| 5.2 | Business verification + terms: legal name BETSONAGI LLC, brand assets, privacy and terms URLs, support and security contacts, maintainer | In progress |
| 5.3 | Data processing questionnaire | Answers ready, see [data-processing-questionnaire.md](data-processing-questionnaire.md) |
| 5.4 | Integration credentials + tool documentation: endpoint, OAuth setup, scopes, inputs and outputs, read/write/sensitive classes, side effects, errors, rate limits | To do |
| 5.5 | Test account + demo, kept accessible for the whole review | To do (credentials go through the portal's secure flow, never into this repo) |
| 5.6 | Tool annotation (coming to the portal; for now it goes inside the 5.4 documentation) | To do |
| 5.7 | Watch review status in the portal (Meta won't answer status emails) | — |

**Review (§6)** happens in three stages:
1. Risk assessment (security, privacy, integrity).
2. Per-tool review. Only tools Meta approves go live.
3. End-to-end QA, including a check that sensitive writes always ask for approval.

## Changes made for this submission

| Date | Change | Where |
|---|---|---|
| 2026-10-05 | Privacy policy: data deleted within 90 days of account deletion or a deletion request, including backups (`#after-you-leave`) | Adspirer/website-v3-claude-code PR #47 |
| 2026-10-05 | Privacy policy: incident notice, including Meta within 48 hours (`#security-incidents`) | PR #47 |
| 2026-10-05 | Privacy policy: how we handle government and third-party requests (`#government-requests`) | PR #47 |
| 2026-10-05 | Privacy policy: how to submit a legal process request, and what it must include | PR #48 |
| 2026-10-05 | Trust center: Data Handling & Compliance section; access token lifetime corrected to 7 days | Adspirer/docs `09d2556` |
