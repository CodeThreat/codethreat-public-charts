# CodeThreat Helm Chart

![CodeThreat Helm Chart](https://framerusercontent.com/images/4H176e5lLcdrzAKQuhNAEkZQxYY.png)

Kubernetes deployment chart for CodeThreat AppSec Platform.

> **Public Beta**: This Helm chart is in public beta. Report issues or suggestions via GitHub.

## Prerequisites

- Kubernetes 1.19+
- Helm 3.0+
- Access to CodeThreat container registry (`registry.codethreat.com`)
- `CODETHREAT_TOKEN` for registry authentication

## Deployment Scope

**Default Configuration**: Optimized for POC and demo use. Suitable for evaluation and testing.

**Production**: Customize with enterprise configurations including high availability, security hardening, monitoring, and cloud optimizations. Contact your forward deployed engineer for production support.

## LLM Configuration

Configure AI model settings before installation:

- `config.defaultModel` - Default AI model (default: `gemini/gemini-2.5-flash-lite`)
- `config.hiveModelName` - Primary Hive AI worker model (default: `gemini/gemini-2.5-flash-lite`)
- `secrets.geminiApiKey` - Google Gemini API key (required for default models)

**Model Format**: Use `provider/model-name`:
- `gemini/gemini-2.5-flash-lite` (default)
- `openai/gpt-4`
- `anthropic/claude-3-opus`
- `groq/llama-3-70b`

Uncomment and configure AI provider API keys in `values.yaml` as needed. Set values using `--set` flags or `values.yaml`.

## Quick Start

### 1. Configure Registry Authentication

Set your CodeThreat registry token:

```bash
export CODETHREAT_TOKEN="your-token-here"
```

**Note**: Do not commit tokens to version control. Use `--set` flags or environment variables.

### 2. Generate Required Secrets

Generate secure random values:

```bash
export NEXTAUTH_SECRET=$(openssl rand -base64 32)
export ENCRYPTION_KEY=$(openssl rand -base64 32 | cut -c1-32)
export CREDENTIAL_ENCRYPTION_KEY=$(openssl rand -base64 32 | cut -c1-32)
export SHIFTQL_API_SECRET=$(openssl rand -base64 32)
export GITHUB_APP_WEBHOOK_SECRET=$(openssl rand -base64 32)
export BITBUCKET_SERVER_WEBHOOK_SECRET=$(openssl rand -base64 32)
```

### 3. Configure LLM API Key

Set your Gemini API key (or other AI provider key):

```bash
export GEMINI_API_KEY="your-gemini-api-key-here"
```

### 4. Install the Chart

You can configure secrets in two ways:

**Option A: Using `--set` flags (recommended for secrets)**

```bash
helm install codethreat ./helm/codethreat \
  --namespace codethreat \
  --create-namespace \
  --set imagePullSecrets.token="$CODETHREAT_TOKEN" \
  --set secrets.nextauthSecret="$NEXTAUTH_SECRET" \
  --set secrets.encryptionKey="$ENCRYPTION_KEY" \
  --set secrets.credentialEncryptionKey="$CREDENTIAL_ENCRYPTION_KEY" \
  --set secrets.shiftqlApiSecret="$SHIFTQL_API_SECRET" \
  --set secrets.githubAppWebhookSecret="$GITHUB_APP_WEBHOOK_SECRET" \
  --set secrets.geminiApiKey="$GEMINI_API_KEY" \
  --set config.bitbucketServerWebhookSecret="$BITBUCKET_SERVER_WEBHOOK_SECRET" \
  --set config.appUrl="https://codethreat.yourdomain.com" \
  --set config.nextauthUrl="https://codethreat.yourdomain.com" \
  --set config.nextPublicAppUrl="https://codethreat.yourdomain.com" \
  --set config.nextPublicApiUrl="https://codethreat.yourdomain.com" \
  --set ingress.enabled=true \
  --set ingress.host="codethreat.yourdomain.com"
```

**Option B: Using `values.yaml` file**

Create or edit `values.yaml` and set your secrets there, then install:

```bash
# Edit values.yaml with your secrets
helm install codethreat ./helm/codethreat \
  --namespace codethreat \
  --create-namespace \
  --values values.yaml \
  --set imagePullSecrets.token="$CODETHREAT_TOKEN"
```

**Security**: If using `values.yaml`:
- Do not commit to version control (add to `.gitignore`)
- Restrict file permissions (`chmod 600 values.yaml`)
- Store securely

**Best practice**: Use `--set` flags for secrets, `values.yaml` for non-sensitive configuration.

### 5. Verify Installation

```bash
kubectl get pods -n codethreat
kubectl get ingress -n codethreat
```

## Configuration

### Required Values

| Value | Description | Generation |
|-------|-------------|------------|
| `imagePullSecrets.token` | CodeThreat registry authentication token | Provided by CodeThreat |
| `secrets.nextauthSecret` | NextAuth.js session encryption secret | `openssl rand -base64 32` |
| `secrets.encryptionKey` | Data encryption key (32 characters) | `openssl rand -base64 32 \| cut -c1-32` |
| `secrets.credentialEncryptionKey` | Credential encryption key (32 characters) | `openssl rand -base64 32 \| cut -c1-32` |
| `secrets.shiftqlApiSecret` | Shift-QL API authentication secret | `openssl rand -base64 32` |
| `secrets.githubAppWebhookSecret` | GitHub App webhook secret | `openssl rand -base64 32` |
| `config.bitbucketServerWebhookSecret` | Bitbucket Server webhook secret | `openssl rand -base64 32` |
| `config.appUrl` | Full application URL | Your domain |
| `config.nextauthUrl` | NextAuth.js callback URL | Should match `appUrl` |
| `config.nextPublicAppUrl` | Public application URL | Your domain |
| `config.nextPublicApiUrl` | Public API URL | Your domain |

### Optional Configuration

See `values.yaml` for complete configuration options including:

- **Resource Management**: CPU and memory limits/requests for all components
- **Storage**: Persistent volume sizes and storage classes
- **Scaling**: Replica counts for horizontally scalable workers (shift-ql, hive)
- **Image Pull Policy**: `IfNotPresent` (production) or `Always` (testing)
- **AI Providers**: OpenAI, Azure OpenAI, Ollama, Groq, Anthropic, Gemini, LiteLLM
- **Email**: SMTP, SendGrid, or Mailchimp configuration
- **GitHub Integration**: OAuth App and GitHub App credentials

## Image Pull Authentication

The chart creates a Kubernetes Secret (`codethreat-registry`) for registry authentication. Provide the token during installation or upgrade:

```bash
# During installation
helm install codethreat ./helm/codethreat \
  --set imagePullSecrets.token="$CODETHREAT_TOKEN"

# During upgrade
helm upgrade codethreat ./helm/codethreat \
  --reuse-values \
  --set imagePullSecrets.token="$CODETHREAT_TOKEN"
```

**Security**: Do not set `imagePullSecrets.token` in `values.yaml`. Use `--set` flags with environment variables.

## Accessing the Application

### Port Forward (Testing)

```bash
kubectl port-forward -n codethreat svc/codethreat-appsec 3000:3000
# Access at: http://localhost:3000
```

### Ingress (Production)

Enable ingress during installation or upgrade:

```bash
helm upgrade codethreat ./helm/codethreat \
  --namespace codethreat \
  --reuse-values \
  --set ingress.enabled=true \
  --set ingress.host=your-domain.com \
  --set ingress.tls.enabled=true
```

### LoadBalancer Service

```bash
helm upgrade codethreat ./helm/codethreat \
  --namespace codethreat \
  --reuse-values \
  --set appsec.service.type=LoadBalancer
```

## Security

### Current Implementation

- Network policies restrict PostgreSQL access to chart components
- Secrets stored in Kubernetes Secrets
- Image pull authentication via Kubernetes Secrets
- Resource limits configured for all components

### Production Recommendations

Default configuration is suitable for POC/demo. For production:

- Change default PostgreSQL password
- Enable TLS for ingress (`ingress.tls.enabled=true`)
- Use non-root containers (`securityContext.runAsNonRoot: true`)
- Enable Pod Security Standards
- Implement secret rotation
- Use external secret management (HashiCorp Vault, AWS Secrets Manager, GCP Secret Manager)

Contact your forward deployed engineer for production configuration guidance.

### Secret Management

Do not commit secrets to version control. Use:
- `--set` flags during installation/upgrade
- External secret management systems
- Kubernetes Secrets

## Architecture

Components:
- **PostgreSQL** - Embedded database (can be disabled for external DB)
- **AppSec** - Main Next.js web application
- **Shift-QL** - Security scanner workers (horizontally scalable)
- **Hive** - AI analysis workers (horizontally scalable)

### Network Policies

- PostgreSQL access restricted to chart components
- Worker services (shift-ql, hive) can access external services

### Storage

**Persistent** (survives pod restarts):
- PostgreSQL: Always persistent
- AppSec uploads: Persistent by default (set `storageClass: "-"` for ephemeral)
- Shift-QL cache/temp: Persistent by default (set `storageClass: "-"` for ephemeral)
- Hive cache: Persistent by default (set `storageClass: "-"` for ephemeral)

**Ephemeral**: Set `storageClass: "-"` in `values.yaml` to use `emptyDir` volumes

## Scaling

Workers can be scaled horizontally:

```bash
helm upgrade codethreat ./helm/codethreat \
  --namespace codethreat \
  --reuse-values \
  --set shiftql.replicas=5 \
  --set hive.replicas=5
```

## Database Migrations

Migrations run automatically via Helm pre-install/pre-upgrade hook:
1. Waits for PostgreSQL readiness
2. Ensures database exists
3. Runs Prisma migrations
4. Seeds database

## Upgrading

```bash
helm upgrade codethreat ./helm/codethreat \
  --namespace codethreat \
  --reuse-values \
  --set imagePullSecrets.token="$CODETHREAT_TOKEN"
```

## Uninstallation

```bash
helm uninstall codethreat --namespace codethreat
```

**Warning**: Uninstallation deletes all data unless PVCs are retained. Back up PostgreSQL first.

## Troubleshooting

### Check Pod Status

```bash
kubectl get pods -n codethreat
kubectl describe pod <pod-name> -n codethreat
kubectl logs <pod-name> -n codethreat
```

### Check Image Pull Issues

```bash
kubectl describe pod <pod-name> -n codethreat | grep -A 5 "Events"
kubectl get secret codethreat-registry -n codethreat -o yaml
```

### Check Migrations Job

```bash
kubectl get jobs -n codethreat
kubectl logs job/<release-name>-migrations -n codethreat
```

### Database Access

```bash
kubectl exec -it <postgres-pod> -n codethreat -- psql -U codethreat -d codethreat
```

## Support

For issues and questions:
- Email: info@codethreat.com
- Documentation: https://docs.codethreat.com
