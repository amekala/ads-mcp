# Google Ads bid strategies

Smart bidding predicts which auctions will convert. It learns from the campaign's own conversions
and from the rest of the account, so how much data it has depends on the whole account, not just the
new campaign. Pick the strategy from the data the account actually has.

## Rules of thumb (not hard requirements)

| Strategy | Usually fits when |
|---|---|
| **Manual CPC** | You need tight control, or the account has no conversion tracking yet |
| **Maximize clicks** | Little or no conversion history; you need traffic to learn from |
| **Maximize conversions** | Conversions are tracked and flowing, with no strict cost ceiling |
| **Target CPA** | Conversion volume is steady and you know what a conversion may cost |
| **Maximize conversion value** | Conversions carry values that vary a lot |
| **Target ROAS** | Revenue is tracked per conversion and volume is steady |
| **Target impression share** | Brand defense, or a visibility goal rather than a cost goal |

Volume guidance you'll often see (around 15–30 conversions a month for a CPA target, more for ROAS)
is a rough indicator of stability. It isn't a prerequisite Google enforces; treat it as a reason to
be cautious, not a rule.

## Things that go wrong

**A target far below the current CPA.** If the account converts at 80 and the target is set to 30,
delivery can collapse. Move a target in steps of about 10–20%.

**Changing strategy often.** Each change starts a new learning period, typically about a week of
less stable delivery. Change one thing, then wait.

**Target ROAS without conversion values.** No revenue on the conversion means there's nothing to
target. Check `list_conversion_actions` first.

**Optimizing toward the wrong conversion.** A page view isn't a lead. Check what the conversion
action fires on before optimizing toward it.

Targets and caps are in the account's currency. Change strategy with `update_bid_strategy`, after the
user agrees, and say what the learning period will do to delivery.
