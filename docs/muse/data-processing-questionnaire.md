# Muse data processing questionnaire (transfer impact assessment)

These are our answers to the "Transfer impact assessment" section of the Muse submission form
(guidelines §5.3). Every answer has to match the public privacy policy at
https://www.adspirer.com/privacy, because Meta checks the two against each other. If one
changes, update the other in the same release.

Last reviewed: 2026-10-05

## Business

| Field | Answer |
|---|---|
| Business legal name | BETSONAGI LLC (written exactly as in the privacy policy) |
| What best describes your business? | Technology |
| Countries where the data is stored or accessed | United States |
| Country of business HQ | United States |
| Where the connector is offered | Worldwide |

## Personal data

**Personal data categories**

| Category | Selected | Why |
|---|---|---|
| Account identifiers | Yes | Adspirer user ID, Meta ad account IDs, Page IDs, pixel IDs |
| Contact details | Yes | The authorizing user's business email. Lead-form submissions returned by `get_meta_lead_form_submissions` (name, email, phone) |
| User-generated content | Yes, if write tools are submitted | Ad copy, campaign names and the images or videos users supply to the create tools. Untick it if only read tools are submitted |
| Content returned to the user | Yes | Campaign, performance and lead data returned to Muse |
| Usage and log data | Yes | Tool-call logs, timestamps, IP addresses, errors |
| Messaging data | No | We don't receive conversations, only tool requests |
| Other | No | — |

**Sensitive data categories:** None of the above. Ad spend is the business's own data, not
personal financial data, and location targeting is not a person's precise location.

## Additional organizations (subprocessors)

Choose "Additional organizations will access the data" and add each organization below. All of
them are in the United States, matching the trust center's subprocessor table.

| Organization name | Countries |
|---|---|
| Google LLC (Google Cloud Platform) | United States |
| Clerk, Inc. | United States |
| Stripe, Inc. | United States |
| Twilio Inc. (SendGrid) | United States |
| PostHog, Inc. | United States |
| OpenAI, L.L.C. | United States |
| Anthropic PBC | United States |

## Retention and deletion

**How long will you retain personal data?** 90 days

The question asks how long we keep data after a user leaves. Privacy policy `#after-you-leave`:
when a user deletes their account or asks for deletion, all of their data, including tool-call
logs and backups, is deleted within 90 days. Billing and legal records are the only exception.

**How can personal data be deleted?**

> Users can disconnect Adspirer in Muse's connector settings at any time. This stops Muse from calling Adspirer, and any issued token expires. Users can disconnect Meta and other ad accounts on the Adspirer Connections page, or revoke access in Meta's settings. Users can request full account deletion by emailing support@adspirer.com. We then delete their account information, connected-account data and tool-call logs from our live systems and backups within 90 days. The only exception is billing and legal records we are required to keep.

## Safeguards

**What controls or safeguards protect the data and any international transfers?**

> All data is encrypted in transit with TLS 1.2+ and at rest with AES-256 on Google Cloud. Ad-platform OAuth tokens get an extra layer of application-level encryption. AI-client tokens and API keys are stored only as hashes. Authentication uses OAuth 2.1 with PKCE, with access tokens expiring after 7 days and refresh tokens after 30. Databases run on a private network with no public IP addresses. Each service uses least-privilege access, and secrets are kept in Google Secret Manager. Every tool call is audit-logged without credentials, and each user's data is isolated to their account. We run weekly penetration testing, and our MCP server is certified by BlueRock IO, an independent MCP security firm. Data is stored and processed in the United States. Where international transfers need safeguards, we use appropriate mechanisms such as Standard Contractual Clauses. We never sell user data or use it to train AI models.

**Trust center URL:** https://www.adspirer.com/docs/knowledge-base/security

## Government and third-party requests

**How do you assess and respond to government or third-party requests for access to the data?**

> We disclose user data only in response to a valid, legally binding request, such as a subpoena, court order or warrant. No government has direct or bulk access to our data. Requests must be emailed to support@adspirer.com with the subject "Legal Process Request". They must include the signed legal process, the requesting authority and an official contact on an official domain, the account concerned, and the specific data and date range sought. We verify every requester and check each request for legal validity and scope. We challenge requests that are overbroad or unlawful and disclose only the minimum data needed. Where the law allows, we notify the affected user before disclosing. We don't respond to informal or incomplete requests. Requests from private parties must be served as valid legal process.

**Evidence URL:** https://www.adspirer.com/privacy#government-requests

## Access and AI

| Field | Answer | Why |
|---|---|---|
| For what purpose will you access personal data? | Read only | No Meta tool writes personal data; there is no customer-list upload on Meta. The write tools change campaigns, which appear in the tool documentation (5.4) |
| Is your connector powered by, or does it pass Meta personal data to, any AI model? | Yes | `search_tools` sends the assistant's search text to OpenAI to find matching tools. Adspirer-side features (agents, research jobs, playbooks) use AI models. The privacy policy says both. No model is trained on the data |
| Do you provide payment products or services? | No | We sell subscriptions, and Stripe processes the payments. We don't move money, hold funds or provide wallets or credit. The AML question doesn't apply |
