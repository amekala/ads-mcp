# Google Ads bid strategies

A smart bidding strategy is a prediction model. With no conversions to learn from, it predicts
nothing and underdelivers — the campaign quietly stops serving. Match the strategy to the data the
account actually has.

## When each becomes viable

| Strategy | Use when | Conversions needed first |
|---|---|---|
| **Manual CPC** | Brand-new account, or you need absolute control | none |
| **Maximize clicks** | Cold start; you need traffic to generate conversion data | none |
| **Maximize conversions** | Conversions are flowing, no strict cost ceiling | ~15–30 / month |
| **Target CPA** | You know what a conversion may cost | ~30 / month, stable |
| **Maximize conversion value** | Order values vary a lot | ~30 / month with values |
| **Target ROAS** | E-commerce, revenue tracked per conversion | ~50 / month with values |
| **Target impression share** | Brand defense, competitor bidding on your name | none |

## The usual sequence

1. Launch on **maximize clicks** with a sane CPC cap.
2. Accumulate 30 conversions. Verify they are real conversions, not thank-you-page reloads.
3. Move to **maximize conversions**.
4. Once CPA is stable, set a **target CPA** near the achieved average — not at the number the user
   wishes for.

## Things that go wrong

**Setting a target CPA far below the current CPA.** The campaign stops serving. If the account
converts at $80 and the user sets a $30 target, impressions collapse and they conclude Google is
broken. Move toward a target in steps of 10–20%.

**Switching strategies weekly.** Each change restarts the learning period — roughly 7 days of
unstable delivery. Change one thing, then wait.

**Target ROAS without conversion values.** ROAS is revenue over spend. No revenue on the conversion
means no ROAS to target. Check `list_conversion_actions` for whether values are set.

**Optimizing toward a conversion that isn't the business goal.** A form view is not a lead. Look at
what the conversion action actually fires on before you optimize toward it.

Change strategy with `update_bid_strategy`. Say what the learning period will do to delivery before
you do it.
