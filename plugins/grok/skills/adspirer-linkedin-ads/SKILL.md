---
name: adspirer-linkedin-ads
description: Create and manage LinkedIn Ads through Adspirer — sponsored content, single image, video, carousel, text ads, and lead-gen forms with B2B job-title, company, and industry targeting. Use for anything on LinkedIn. Every LinkedIn campaign requires a campaign group.
---

# LinkedIn Ads

Everything on LinkedIn goes through the `linkedin_ads` router. Follow `adspirer-mcp` for the
two-step.

Account parameter: `account_id`, as a **string**. Budgets are in the account's currency.

## Every campaign belongs to a campaign group

LinkedIn will not create a bare campaign. Pass either an existing `campaign_group_id`, or a
`campaign_group_name` to create one. There is no default and no implicit group — omitting both
fails.

List the existing groups before you invent a new one; most accounts already have a structure the
user cares about.

## Build order

Campaign group → campaign → creative. Campaigns are created **paused**.

`select_linkedin_campaign_type` picks the format when the user hasn't said. Then
`create_linkedin_image_campaign`, `_video_campaign`, `_carousel_campaign`, or `_text_campaign`.
Creatives attach with `add_linkedin_creative` and its variants.

## Targeting is the point

LinkedIn's value is the professional graph: job title, seniority, function, company, company size,
industry, skills, and groups. That's what the user is paying LinkedIn's CPMs for — a broad,
demographic-only LinkedIn campaign is a waste of money and you should say so.

`search_linkedin_targeting` resolves a name ("VP of Engineering", "Financial Services") to the
facet id you need. `research_business_for_linkedin_targeting` turns a company description into a
targeting proposal. Don't guess facet ids.

LinkedIn enforces a minimum audience size (about 300 members). Over-narrow targeting simply won't
run — check the estimated size before you build.

## Costs are high, so structure matters

LinkedIn CPCs run many times Google's. That changes the advice:

- Budgets under roughly $25/day rarely gather enough data to optimize.
- Lead-gen forms convert far better than sending people to a landing page. Prefer them for
  lead objectives.
- Because clicks are expensive, creative fatigue bites sooner. `analyze_linkedin_creative_performance`
  shows which creative is carrying the campaign.

## Deleting creatives is permanent

`delete_linkedin_creative` cannot be undone. Pausing is almost always what the user meant. Name what
will be lost and ask first.

## Reading performance

Performance goes through the router — there is **no** top-level LinkedIn performance tool. Use
`{"action": "execute", "tool_name": "get_linkedin_campaign_performance", ...}`.

`get_linkedin_engagement_metrics` covers social actions; `analyze_linkedin_wasted_spend` finds
campaigns spending without converting.

Lead-gen submissions contain real people's names, titles, and emails. Summarize them; don't dump
personal data into the conversation unprompted.
