# Contributing

## Reporting Issues

Before creating an issue:
1. Check if the issue already exists
2. Search closed issues for similar problems
3. Verify you're using the latest chart version

Include in your issue:
- Chart version
- Kubernetes version
- Helm version
- Steps to reproduce
- Expected vs actual behavior
- Relevant logs or error messages

## Suggesting Enhancements

When proposing enhancements:
- Describe the use case
- Explain the benefit
- Provide examples if possible
- Consider backward compatibility

## Pull Requests

### Before Submitting

1. Fork the repository and create a feature branch
2. Test your changes thoroughly
3. Update documentation if needed
4. Follow code style and conventions
5. Ensure backward compatibility or document breaking changes

### Pull Request Process

1. Create a descriptive title and detailed description
2. Reference related issues (e.g., "Fixes #123")
3. Add tests if applicable
4. Update CHANGELOG.md
5. Ensure all checks pass (if CI is configured)

### Code Style

- Use consistent YAML formatting (2 spaces indentation)
- Follow Helm best practices
- Add comments for complex logic
- Keep templates readable and maintainable
- Use semantic versioning for chart updates

### Testing

Before submitting:
- Test installation with default values
- Test with custom values
- Verify all components deploy correctly
- Test upgrade scenarios if applicable
- Test uninstallation

### Documentation

Update documentation for:
- New configuration options
- Breaking changes
- New features or components
- Changes to default values

### Development Setup

1. Clone the repository:
   ```bash
   git clone https://github.com/CodeThreat/codethreat-public-charts.git
   cd codethreat-public-charts
   ```

2. Make changes in `helm/codethreat/`

3. Validate the chart:
   ```bash
   helm lint ./helm/codethreat
   ```

4. Test template rendering:
   ```bash
   helm template codethreat ./helm/codethreat --debug
   ```

5. Test installation (dry-run):
   ```bash
   helm install codethreat ./helm/codethreat --dry-run --debug
   ```

### Commit Messages

- Start with a verb (Add, Fix, Update, Remove)
- Keep the first line under 72 characters
- Reference issues when applicable

Examples:
- `Add PodDisruptionBudget for high availability`
- `Fix ingress TLS configuration`
- `Update PostgreSQL default resources`

### Review Process

- All pull requests require review
- Maintainers review within 5 business days
- Feedback provided for requested changes
- Maintainers merge once approved

### Questions

- GitHub Discussions
- Email: info@codethreat.com
- Existing issues and pull requests
