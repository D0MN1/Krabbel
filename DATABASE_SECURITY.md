# Database Security Guidelines for Krabbel Application

This document outlines security best practices for the MySQL/MariaDB database used in the Krabbel application.

## Local Development Security

When developing locally, consider these security measures:

1. **Use Strong Passwords**:
   - Even in development, use strong passwords (minimum 12 characters, mix of uppercase, lowercase, numbers, and special characters)
   - Set your credentials using environment variables:
     ```bash
     export MYSQL_USERNAME=your_username
     export MYSQL_PASSWORD=your_strong_password
     ```

2. **Limit Database User Permissions**:
   - Create a dedicated database user for your application
   - Grant only necessary permissions (SELECT, INSERT, UPDATE, DELETE on required tables)
   - Avoid giving global privileges or DDL privileges in production

3. **Separate Development and Production Databases**:
   - Never connect to production databases from development environments

## Production Database Security

For Azure MySQL deployment, implement these security measures:

1. **Connection Security**:
   - Enforce SSL/TLS encryption for all connections (already configured)
   - Enable Azure Advanced Threat Protection
   - Configure firewall rules to limit access by IP address

2. **Authentication Security**:
   - Use Azure Key Vault to store database credentials
   - Enable Azure AD integration for database authentication when possible
   - Rotate database passwords regularly (at least every 90 days)

3. **Database Hardening**:
   - Enable auditing for all database operations
   - Remove all unused functions, stored procedures, and users
   - Configure automatic patching to keep the database updated

4. **Data Security**:
   - Consider encrypting sensitive data columns (e.g., PII)
   - Implement row-level security if different users need different access levels
   - Set up automated backups with encryption

## Security Monitoring

1. **Enable Logging and Monitoring**:
   - Set up Azure Monitor alerts for suspicious activities
   - Monitor for failed login attempts
   - Track unusual query patterns

2. **Regular Security Reviews**:
   - Perform periodic security audits of database configuration
   - Review user permissions regularly
   - Monitor for security advisories related to MariaDB/MySQL

## Incident Response

1. **Prepare for Security Incidents**:
   - Document procedures for database security incidents
   - Have a backup and restore strategy tested and ready
   - Know how to rotate all credentials in case of compromise

By following these guidelines, you can significantly enhance the security of your database, protecting both the application and your users' data.
