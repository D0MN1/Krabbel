# Production Security Checklist for Krabbel

This checklist helps ensure your Krabbel application is secure when deploying to production environments like Azure.

## Database Security

- [ ] **Strong Credentials**
  - [ ] Database username is not a default value (not "root", "admin", "sa", etc.)
  - [ ] Database password is at least 16 characters with a mix of uppercase, lowercase, numbers, and symbols
  - [ ] Database credentials are stored securely (Azure Key Vault or environment variables)

- [ ] **Network Security**
  - [ ] Database firewall rules limit access to only necessary IP addresses/services
  - [ ] SSL/TLS is enforced for all database connections
  - [ ] Database server is not exposed to public internet (if possible)

- [ ] **User Permissions**
  - [ ] Application uses a database user with minimal required permissions
  - [ ] No global administrative privileges for application database user
  - [ ] Database user can only access the specific database it needs

## Authentication & Authorization

- [ ] **JWT Security**
  - [ ] JWT secret is strong (at least 64 characters) and stored securely
  - [ ] JWT expiration is set appropriately (not too long)
  - [ ] JWT tokens are validated properly
  - [ ] JWT issuer and audience claims are verified

- [ ] **Password Security**
  - [ ] Default user passwords have been changed from development values (use `update-prod-passwords.sh`)
  - [ ] Password hashing uses BCrypt with sufficient work factor (at least 10)
  - [ ] Account lockout is implemented after failed login attempts
  - [ ] Password complexity requirements are enforced

- [ ] **API Security**
  - [ ] Sensitive endpoints require authentication
  - [ ] Role-based access control is implemented
  - [ ] API requests are rate-limited
  - [ ] No sensitive data in URL parameters

## Infrastructure Security

- [ ] **HTTPS**
  - [ ] SSL/TLS is configured and enforced
  - [ ] HTTP Strict Transport Security (HSTS) is enabled
  - [ ] Weak SSL/TLS protocols and ciphers are disabled

- [ ] **Headers & CORS**
  - [ ] Secure HTTP headers are configured
  - [ ] CORS is restricted to known domains only
  - [ ] Content Security Policy is implemented
  - [ ] X-Content-Type-Options, X-Frame-Options, and XSS-Protection are enabled

- [ ] **Secure Deployments**
  - [ ] Non-essential ports are closed
  - [ ] Debug endpoints are disabled
  - [ ] Error messages don't reveal sensitive information
  - [ ] Production logs don't contain sensitive data

## Monitoring & Incident Response

- [ ] **Logging & Monitoring**
  - [ ] Application logs security events (login attempts, permission changes, etc.)
  - [ ] Log monitoring and alerts are configured
  - [ ] Failed authentication attempts are logged
  - [ ] Unusual access patterns trigger alerts

- [ ] **Backup & Recovery**
  - [ ] Regular database backups are configured
  - [ ] Backup restoration process is documented and tested
  - [ ] Data retention policy is defined and implemented

- [ ] **Incident Response**
  - [ ] Security incident response plan is documented
  - [ ] Contact information for security team is available
  - [ ] Process for rotating compromised credentials exists

## Regular Maintenance

- [ ] **Updates & Patches**
  - [ ] Regular schedule for applying security patches
  - [ ] Dependency vulnerabilities are monitored (e.g., OWASP Dependency Check)
  - [ ] Software components are kept up-to-date

- [ ] **Security Reviews**
  - [ ] Regular security code reviews
  - [ ] Periodic penetration testing
  - [ ] Security configuration review after major changes

## Azure-Specific Security

- [ ] **Azure Security Center**
  - [ ] Security Center recommendations are reviewed and implemented
  - [ ] Threat detection is enabled

- [ ] **Identity & Access Management**
  - [ ] Azure resources use Managed Identities where possible
  - [ ] Azure AD integration is configured for database access
  - [ ] Role-Based Access Control (RBAC) is implemented for Azure resources

- [ ] **Network Security**
  - [ ] Virtual Network isolation is configured
  - [ ] Network Security Groups restrict traffic appropriately
  - [ ] Private endpoints are used for Azure services where possible

This checklist should be reviewed prior to each production deployment and periodically afterward to ensure ongoing security.
