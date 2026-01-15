# Security Policy

## Supported Versions

| Version | Supported          |
| ------- | ------------------ |
| 0.68.x  | :white_check_mark: |
| < 0.68  | :x:                |

## Reporting a Vulnerability

Report security vulnerabilities via email: **info@codethreat.com**

### Reporting Process

1. Do not open public GitHub issues for security vulnerabilities
2. Email security details to info@codethreat.com
3. Include:
   - Vulnerability description
   - Steps to reproduce
   - Potential impact
   - Suggested fix (if available)
   - Contact information

### What to Report

- Security vulnerabilities in Helm chart templates
- Misconfigurations leading to security issues
- Exposed secrets or credentials
- Insecure default configurations

### Response Timeline

- Initial response: Within 48 hours
- Status update: Within 7 days
- Resolution: Depends on severity and complexity

### Security Best Practices

1. Do not commit secrets to version control
2. Change default passwords before production
3. Use external secret management for production
4. Enable TLS for all ingress configurations
5. Apply security contexts and pod security standards
6. Regularly update to the latest chart version

### Security Updates

- Released as patch versions (e.g., 0.68.1)
- Documented in CHANGELOG.md
- Announced via GitHub releases
