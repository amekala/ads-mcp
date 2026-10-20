---
name: adspirer-tag-manager
description: Inspect Google Tag Manager tags, triggers, and variables through Adspirer when diagnosing conversion tracking, and apply a tag fix only after an explicit yes. Publishing the container is a second yes. A tag that exists is not proof it fires.
---

# Google Tag Manager

The router is `google_tag_manager`. It appears only when Tag Manager is connected. Follow `adspirer-mcp`: `{"action": "list_tools"}` first, then execute an exact name from that list. `get_tool_schema` before any write.

If it isn't connected, say so and point the user at `https://adspirer.ai/connections`. The ads-manager check in `adspirer-ads-manager-browser` can still describe tag health from the ad platform's UI.

## Resolve one level at a time

Account, then container, then workspace. The first call lists account options. Labels can be identical, so always show the id next to the label. If a level has several options, the user picks. Never assume an id. A write to the wrong container changes the wrong website, quietly.

Confirm which conversion is in scope, then read the tags, triggers, and variables that serve it. Say whether what you have is configuration only. A tag existing in the container does not prove it fires, and a tag warning in Google Ads does not, by itself, condemn an import-based conversion. See `adspirer-ads-manager-browser`.

## A fix is a proposal until they say yes

Draft the smallest change that addresses the problem. Note consent or privacy impact. Never disable a consent control to "make the tag fire."

Before any write, show the exact change, the target workspace, a testing plan, and how to roll it back. Get an explicit yes for that change.

**Publishing the container changes the live website and needs its own yes.** If the live tool list has no publish action, tell the user to preview and publish in Tag Manager themselves. Never publish as part of an audit, and never publish because a write was accepted.

Read the result back. Say which preview or runtime checks are still open. A configured tag you have not watched fire is "not verified", not "fixed".
