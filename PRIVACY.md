# Ads MCP Privacy Policy

**Effective Date:** January 9, 2025
**Last Updated:** January 9, 2025

## Introduction

Ads MCP ("we," "our," "us") is a Model Context Protocol server developed by Adspirer that enables AI assistants (Claude, ChatGPT) to manage advertising campaigns on your behalf. This Privacy Policy explains how we collect, use, and protect your data when you use the Ads MCP service.

**This privacy policy supplements our main privacy policy at https://www.adspirer.com/privacy**

## Information We Collect

### Authentication Data
- **OAuth Tokens:** Access tokens from Google Ads and TikTok Ads obtained through OAuth 2.1 authorization
- **Account Identifiers:** Google Ads customer IDs and TikTok advertiser IDs for connected advertising accounts
- **Session Tokens:** Clerk session tokens for user authentication and authorization

### Campaign Data
- **Campaign Parameters:** Campaign names, budgets, targeting parameters, and settings you create through MCP tools
- **Keywords and Ad Copy:** Keywords, headlines, descriptions, and ad creative text you submit
- **Asset Bundles:** Images, logos, and other creative assets you provide for campaign creation
- **Targeting Settings:** Geographic locations, demographics, and audience specifications

### Performance Data
- **Metrics:** Performance metrics you request including clicks, impressions, conversions, costs, and ROAS
- **Date Ranges:** Time periods and filters applied to performance reports
- **Account Summaries:** Account-level performance aggregations

### Usage Data
- **Tool Invocations:** Logs of which MCP tools were called, timestamps, and parameters (excluding sensitive content)
- **Error Logs:** Technical error messages for troubleshooting and service improvement
- **Progress Updates:** Status messages for long-running operations

## What We Do NOT Collect

We are committed to minimal data collection. We do NOT collect:

- **Conversation History:** Your full conversations with Claude, ChatGPT, or other AI assistants
- **Chat Context:** Personal information or context beyond what's needed for tool execution
- **Cross-Server Data:** Data from other MCP servers or Claude tools you may be using
- **Browsing Activity:** Your browsing history or activity outside our MCP server
- **Unnecessary Metadata:** Chat metadata, user preferences, or application settings unrelated to campaign management

## How We Use Your Data

We use your data exclusively to:

- **Authenticate You:** Verify your identity and connect to your advertising platforms
- **Execute Tools:** Create and manage campaigns, research keywords, and analyze performance as you request
- **Provide Reports:** Retrieve and format performance metrics you request
- **Troubleshoot Errors:** Diagnose and fix service issues
- **Improve Service:** Enhance reliability, performance, and user experience

## Data Retention

| Data Type | Retention Period | Rationale |
|-----------|------------------|-----------|
| OAuth Tokens | Until you disconnect your account | Required for ongoing API access |
| Campaign Parameters | 90 days after last access | Historical reference and troubleshooting |
| Performance Metrics | 30 days | Temporary caching for performance |
| Error Logs | 7 days | Short-term troubleshooting |
| Asset Bundles (in-memory) | 60 minutes | Temporary validation only |

**Automatic Deletion:** Data is automatically deleted after the retention period expires. No manual intervention required.

## Data Sharing and Disclosure

We do NOT sell, rent, or trade your data. We share data only in the following limited circumstances:

### With Advertising Platforms
- **Google Ads and TikTok:** We transmit campaign data and asset bundles to these platforms as necessary to execute your requests (create campaigns, upload assets, retrieve metrics)
- **Scope:** Only the data necessary for the specific operation you requested
- **Authorization:** Based on OAuth permissions you explicitly granted

### Service Providers
- **Infrastructure Providers:** Google Cloud Platform for hosting (subject to their security standards)
- **Authentication Provider:** Clerk for user authentication (subject to their privacy policy)
- **Database Provider:** PostgreSQL and Redis for data storage (encrypted at rest)

### Legal Requirements
- **Legal Compliance:** When required by law, court order, or government regulation
- **Rights Protection:** To enforce our Terms of Service or protect our legal rights
- **Safety:** To protect the safety of users or the public

**We will notify you of any legal requests unless prohibited by law.**

## Data Security

We implement industry-standard security measures:

### In Transit
- **TLS 1.3 Encryption:** All data transmitted over HTTPS with modern encryption
- **Certificate Validation:** Verified certificates from recognized authorities
- **HTTPS-Only:** No unencrypted HTTP connections accepted

### At Rest
- **Database Encryption:** PostgreSQL with encryption at rest (AES-256)
- **Token Encryption:** OAuth tokens stored with additional encryption layer
- **Access Controls:** Restricted database access with authentication required

### Operational Security
- **Regular Audits:** Periodic security assessments and penetration testing
- **Minimal Exposure:** Least-privilege access for all services
- **Monitoring:** Automated detection of anomalous activity

## Your Rights

You have the following rights regarding your data:

### Access
- **Request a Copy:** Email abhi@adspirer.com to request a copy of your data
- **Response Time:** Within 14 business days

### Correction
- **Update Information:** Request corrections to inaccurate campaign data
- **Method:** Email abhi@adspirer.com with specific corrections

### Deletion
- **Disconnect Accounts:** Disconnect your advertising accounts via Claude/ChatGPT settings
- **Full Deletion Request:** Email abhi@adspirer.com with subject "Delete My Data"
- **Confirmation:** We will confirm deletion within 7 business days
- **Scope:** All data except legally required retention (e.g., financial records)

### Revoke Access
- **OAuth Revocation:** Disconnect via your Claude or ChatGPT settings
- **Immediate Effect:** OAuth tokens are revoked immediately upon disconnection

**Note:** Some data may persist in backups for up to 30 days after deletion.

## International Data Transfers

- **Server Location:** Our servers are located in the United States (Google Cloud Platform us-central1)
- **Consent:** By using Ads MCP, you consent to data transfer to and processing in the United States
- **Protections:** We comply with applicable data protection laws and use standard contractual clauses where required

## Third-Party Services

Ads MCP integrates with:

- **Google Ads API:** Subject to [Google's Privacy Policy](https://policies.google.com/privacy)
- **TikTok Ads API:** Subject to [TikTok's Privacy Policy](https://www.tiktok.com/legal/privacy-policy)
- **Clerk Authentication:** Subject to [Clerk's Privacy Policy](https://clerk.com/privacy)

**We are not responsible for the privacy practices of third-party services.**

## Children's Privacy

Ads MCP is not intended for users under 18 years of age. We do not knowingly collect data from children. If you believe we have collected data from a child under 18, please contact us immediately at abhi@adspirer.com.

## Changes to This Policy

We may update this Privacy Policy to reflect changes in our practices or legal requirements. We will notify you of material changes via:

- **Email:** To registered users (if we have your email)
- **Service Notice:** Via Ads MCP server metadata or documentation
- **Updated Date:** The "Last Updated" date at the top of this policy

**Your continued use after changes constitutes acceptance of the updated policy.**

## Contact Information

For questions, concerns, or requests regarding this Privacy Policy:

**Email:** abhi@adspirer.com
**Subject Line:** "Ads MCP Privacy"
**Response Time:** Within 2 business days

**Company Information:**
Adspirer Inc.
San Francisco, CA
https://www.adspirer.com

**Main Privacy Policy:** https://www.adspirer.com/privacy
**Terms of Service:** See TERMS.md or https://www.adspirer.com/terms

---

**For Anthropic Reviewers:** This privacy policy is specific to the Ads MCP service and supplements Adspirer's main privacy policy at https://www.adspirer.com/privacy.
