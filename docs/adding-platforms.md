# Adding a New Ad Platform

When Adspirer adds support for a new ad platform (e.g., Snapchat Ads, Amazon Ads, Pinterest Ads), follow these steps to update skills across all IDEs at once.

## Step 1: Update the main skill template

Edit `shared/skills/adspirer-ads/SKILL.md`:

1. **Performance Analysis** — Add a new bullet:
   ```markdown
   - **[Platform] Ads:** `get_[platform]_campaign_performance` — params: `lookback_days`
   ```

2. **Cross-Platform Dashboard** — Add the platform to the performance pull and waste analysis lists.

3. **Campaign Creation** — Add a new platform section:
   ```markdown
   **[Platform] Ads:**
   1. Campaign Research — crawl brand + competitor websites
   2. [platform-specific steps]
   3. Create campaign — created in PAUSED status
   ```

4. **Available Tools table** — Add a new row:
   ```markdown
   | [Platform] Ads | `tool_1`, `tool_2`, ... |
   ```

5. **Platform Guidance table** — Add minimum budgets and use cases.

## Step 2: Add platform-specific reference (optional)

For complex platforms, add a reference file:

```
shared/skills/adspirer-ads/references/[platform]-ads-advanced.md
```

Include detailed workflows, targeting options, creative formats, etc. The main SKILL.md links to this file for on-demand loading.

## Step 3: Generate and validate

```bash
./scripts/sync-skills.sh
./scripts/validate.sh
```

## Step 4: Update IDE-specific rules (if needed)

If the platform has special safety considerations:
- Cursor: Update `plugins/cursor/adspirer/.cursor/rules/use-adspirer.mdc`
- Codex: Update `plugins/codex/adspirer/rules/campaign-safety.rules`

## Step 5: Commit

Commit the template change + all generated files together:

```bash
git add shared/skills/ plugins/cursor/ plugins/codex/ skills/
git commit -m "Add [Platform] Ads support to skills"
```

One edit to the template updates all IDEs automatically.
