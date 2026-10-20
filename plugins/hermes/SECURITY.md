# Security policy

Please report suspected vulnerabilities privately to [support@adspirer.com](mailto:support@adspirer.com). Do not open a public issue for a security report.

Include the affected file or behavior, reproduction steps, and any relevant logs with secrets removed. We will acknowledge the report and coordinate remediation and disclosure as appropriate.

The Adspirer MCP service uses browser-based OAuth. Hermes stores its local MCP tokens outside this
plugin repository. Never commit access tokens, advertising-platform credentials, OAuth client
secrets, or customer data here.
