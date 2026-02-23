# Skill References (Progressive Disclosure)

This directory contains platform-specific deep-dive content that is loaded on-demand when the LLM needs detailed workflows.

## How it works

The main `SKILL.md` is the orchestrator — it covers all platforms and all workflows at a high level. When the user asks for something that requires deeper knowledge (e.g., advanced Google Ads bidding strategies, Meta audience targeting techniques), the LLM loads the relevant reference file from this directory.

## Adding a new reference

Create a markdown file in this directory:

```
references/
  google-ads-advanced.md       ← Deep Google Ads workflows
  meta-ads-advanced.md         ← Deep Meta Ads workflows
  linkedin-ads-advanced.md     ← Deep LinkedIn Ads workflows
  tiktok-ads-advanced.md       ← Deep TikTok Ads workflows
```

Reference files are NOT template-processed — they are copied as-is to all IDE targets. Do not use `{{CONTEXT_FILE}}` or conditional blocks in reference files.

## Current status

No reference files yet. The main SKILL.md (472 lines) currently contains all platform workflows inline. As the skill grows, workflows will be extracted into reference files to keep the main skill focused on orchestration.
