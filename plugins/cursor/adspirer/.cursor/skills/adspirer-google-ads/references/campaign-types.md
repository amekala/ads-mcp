# Google Ads campaign types

Pick by what the user is trying to do, not by what sounds impressive. When they haven't said, run
`select_google_campaign_type` rather than guessing.

## Search

Text ads against what people type. **The default when there is existing demand** — someone is
already looking for a plumber, a CRM, a flight.

- Needs: keywords, ad copy, a landing page, extensions.
- Budget to learn: about $20–30/day minimum. Below that you get too few clicks to tell signal from
  noise.
- Highest intent, most controllable, easiest to explain. Start here unless there's a reason not to.

## Performance Max

One campaign serves across Search, Display, YouTube, Gmail, Maps, and Discover. Google decides the
mix.

- Needs: an asset group (headlines, descriptions, images, logos, ideally video), conversion tracking
  that actually works, and audience signals.
- Budget to learn: about $50–100/day, and give it 4–6 weeks. PMax is a machine-learning campaign; it
  is genuinely bad until it has data.
- **Do not run PMax without working conversion tracking.** It optimizes toward conversions, so with
  broken tracking it optimizes toward nothing and spends the whole budget doing it. Check with
  `audit_conversion_tracking` first.
- Run `discover_existing_assets` before building — the account usually has usable images already.
- Reporting is opaque by design. If the user wants to know exactly which keyword drove which sale,
  PMax will frustrate them.

## Demand Gen

Visual, feed-based demand creation across YouTube, Discover, and Gmail. Closer to paid social than
to Search.

- Needs: strong image and video creative. Weak creative fails here in a way it doesn't on Search.
- For creating demand, not capturing it. Judge it on assisted conversions and view-through, not
  last-click.

## YouTube (Video)

Video ads on YouTube. Awareness and consideration, occasionally direct response with a strong offer.

- Needs: a hosted video. `validate_video` checks it before you build.
- Judge on view rate, cost per view, and lift — not on clicks.

## Display

Banner ads across the Google Display Network. Cheap impressions, low intent.

- Best used for **retargeting** people who already visited. Prospecting on Display burns budget for
  impressions nobody asked for.
- Placement, topic, and audience controls are in the `*_display_*` tools. Use exclusions
  aggressively; the default placements include a lot of junk.

## Quick guide

| Situation | Type |
|---|---|
| People are searching for this already | Search |
| Broad goal, decent budget, tracking works, wants automation | Performance Max |
| Nobody knows the product exists yet | Demand Gen |
| Has good video, wants reach | YouTube |
| Wants to win back site visitors | Display (retargeting) |
| Small budget, needs to prove ROI fast | Search, exact match, tight geo |
