# Azure Deployment Guide for Krabbel

This document provides instructions for deploying the Krabbel application to Microsoft Azure.

## Prerequisites

1. Azure Account with appropriate permissions
2. Azure CLI installed and configured
3. Maven installed locally

## Azure Resources Required

1. **Azure App Service** - For hosting the Spring Boot backend
2. **Azure Database for MySQL** - For the database
3. **Azure Static Web Apps** - For hosting the Vue.js frontend (optional)

## Step 1: Prepare for Production Deployment

### Set Active Profile to Production

Ensure your application is using the 'prod' profile. Set the following environment variable in Azure:

```
SPRING_PROFILES_ACTIVE=prod
```

### Set Environment Variables in Azure

The following environment variables need to be set in Azure App Service:

```
AZURE_MYSQL_URL=jdbc:mysql://<your-azure-mysql-server>.mysql.database.azure.com:3306/krabbel_db?useSSL=true&requireSSL=true
AZURE_MYSQL_USERNAME=<your_mysql_username>@<your-azure-mysql-server>
AZURE_MYSQL_PASSWORD=<your_mysql_password>
JWT_SECRET=<your_secure_jwt_secret_key>
JWT_EXPIRATION=86400000
CORS_ALLOWED_ORIGINS=https://<your-frontend-url>.azurewebsites.net
```

## Step 2: Set Up Azure Database for MySQL

1. Create an Azure Database for MySQL server in the Azure portal
2. Configure firewall rules to allow connections from Azure services
3. Create a database named `krabbel_db`
4. Set up a user with appropriate permissions

## Step 3: Deploy Backend to Azure App Service

1. Package your application with Maven:

```bash
cd backend
./mvnw clean package -DskipTests
```

2. Create an Azure App Service:

```bash
az group create --name krabbel-resource-group --location westeurope
az appservice plan create --name krabbel-service-plan --resource-group krabbel-resource-group --sku B1 --is-linux
az webapp create --name krabbel-backend --resource-group krabbel-resource-group --plan krabbel-service-plan --runtime "JAVA|17"
```

3. Configure the environment variables:

```bash
az webapp config appsettings set --resource-group krabbel-resource-group --name krabbel-backend --settings SPRING_PROFILES_ACTIVE=prod AZURE_MYSQL_URL="jdbc:mysql://<your-azure-mysql-server>.mysql.database.azure.com:3306/krabbel_db?useSSL=true&requireSSL=true" AZURE_MYSQL_USERNAME="<your_username>@<your-azure-mysql-server>" AZURE_MYSQL_PASSWORD="<your_password>" JWT_SECRET="<your_secure_jwt_secret>" CORS_ALLOWED_ORIGINS="https://<your-frontend-url>.azurewebsites.net"
```

4. Deploy the JAR file:

```bash
az webapp deploy --resource-group krabbel-resource-group --name krabbel-backend --src-path target/krabbel-backend-0.0.1-SNAPSHOT.jar
```

## Step 4: Deploy Frontend to Azure Static Web Apps

1. Build the frontend:

```bash
cd frontend
npm run build
```

2. Deploy to Azure Static Web Apps using GitHub Actions or directly from the Azure Portal

## Step 5: Verify Deployment

1. Check the health endpoint: `https://<your-backend-url>.azurewebsites.net/actuator/health`
2. Try logging in with the default admin credentials (admin/admin123)

## Production Security Considerations

1. **Change Default Passwords**: Change the default admin/user passwords immediately after deployment
2. **Set Up SSL**: Enable SSL for all connections 
3. **Configure Azure Monitor**: Set up monitoring and alerts
4. **Implement Backup Strategy**: Configure regular backups for your database

## Troubleshooting

- Check application logs in Azure App Service > Logs > Log Stream
- Verify environment variables are correctly set
- Ensure database connection is working correctly
- Check CORS configuration if the frontend cannot connect to the backend

## Setting Up Monitoring and Alerts

### Azure Application Insights

1. Create an Application Insights resource in Azure Portal
2. Add the Application Insights dependency to your pom.xml:
   ```xml
   <dependency>
       <groupId>com.microsoft.azure</groupId>
       <artifactId>applicationinsights-spring-boot-starter</artifactId>
       <version>2.6.4</version>
   </dependency>
   ```
3. Configure Application Insights in application-prod.properties:
   ```properties
   # Application Insights
   azure.application-insights.instrumentation-key=${APPINSIGHTS_INSTRUMENTATIONKEY}
   ```
4. Set the instrumentation key in Azure App Service environment variables:
   ```
   APPINSIGHTS_INSTRUMENTATIONKEY=your-instrumentation-key
   ```

### Database Backup Strategy

1. Configure Azure Database for MySQL automated backups:
   - Go to Azure Portal > Your MySQL server > Backups
   - Set the backup retention period (recommended: 7-14 days)
   - Enable geo-redundant backups if needed

2. Set up a scheduled backup script for additional security:
   ```bash
   # Example backup script - include in a scheduled task
   mysqldump -h $AZURE_MYSQL_HOST -u $AZURE_MYSQL_USERNAME -p$AZURE_MYSQL_PASSWORD krabbel_db > backup_$(date +%Y%m%d).sql
   ```

### Setting Up Alerts

1. In Azure Portal, go to your App Service > Alerts
2. Create alert rules for:
   - High CPU usage (>80% for 5+ minutes)
   - High memory usage (>80% for 5+ minutes)
   - HTTP 5xx errors (more than 5 in 5 minutes)
   - Response time degradation (>2s for 5+ minutes)

## Additional Resources

- [Azure App Service Documentation](https://docs.microsoft.com/en-us/azure/app-service/)
- [Azure Database for MySQL Documentation](https://docs.microsoft.com/en-us/azure/mysql/)
- [Spring Boot on Azure Documentation](https://docs.microsoft.com/en-us/azure/developer/java/spring-framework/)
- [Azure Application Insights Documentation](https://docs.microsoft.com/en-us/azure/azure-monitor/app/app-insights-overview)
- [Azure MySQL Backup and Restore](https://docs.microsoft.com/en-us/azure/mysql/concepts-backup)
