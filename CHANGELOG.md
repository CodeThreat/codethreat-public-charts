# Changelog

All notable changes to the CodeThreat Helm chart are documented in this file.

## [0.68.0] - 2026-01-12

### Added
- Initial public release
- AppSec, Shift-QL, and Hive components
- PostgreSQL deployment with network policies
- Configurable ingress with TLS support
- Persistent volume claims for all components
- Horizontal scaling for worker components
- Database migration job via Helm hooks
- Configuration via values.yaml
- Multiple AI providers (OpenAI, Azure, Anthropic, Groq, Gemini, Ollama, LiteLLM)
- GitHub integration support
- Email provider support (SMTP, SendGrid, Mailchimp)
- Resource limits and requests for all components
- Health checks (liveness, readiness, startup probes)
- Network policies for PostgreSQL isolation

### Security
- Secrets stored in Kubernetes Secrets
- Image pull authentication via Kubernetes Secrets
- Network policies restrict PostgreSQL access
- Production security hardening documentation

### Documentation
- README with quick start guide
- Testing guide (TEST.md)
- Security considerations and best practices
