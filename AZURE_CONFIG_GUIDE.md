# Azure Environment Configuration Guide

## Current Issue: HTTP 503 Service Unavailable

The backend is showing 503 Service Unavailable, which typically means:
1. Azure deployment is still in progress
2. Application failed to start due to configuration issues
3. Environment variables are not set correctly

## Required Azure Environment Variables

You need to set the following environment variable in your Azure App Service:

### CORS_ALLOWED_ORIGINS
**Value:** `https://ashy-smoke-03b3efb03.2.azurestaticapps.net`

### How to Set Environment Variables in Azure:

1. **Via Azure Portal:**
   - Go to your App Service: krabbel-ezb4d0gffwhtepa0
   - Navigate to Configuration → Application settings
   - Click "New application setting"
   - Name: `CORS_ALLOWED_ORIGINS`
   - Value: `https://ashy-smoke-03b3efb03.2.azurestaticapps.net`
   - Click Save

2. **Via Azure CLI:**
   ```bash
   az webapp config appsettings set \
     --resource-group <your-resource-group> \
     --name krabbel-ezb4d0gffwhtepa0 \
     --settings CORS_ALLOWED_ORIGINS="https://ashy-smoke-03b3efb03.2.azurestaticapps.net"
   ```

## Testing After Configuration

Once the environment variable is set and the deployment completes:

1. Test the root endpoint: https://krabbel-ezb4d0gffwhtepa0.westeurope-01.azurewebsites.net/
2. Check CORS config: https://krabbel-ezb4d0gffwhtepa0.westeurope-01.azurewebsites.net/cors-config
3. Test login from frontend: https://ashy-smoke-03b3efb03.2.azurestaticapps.net

## Database Connection

Also ensure these environment variables are set for database connectivity:
- `DATABASE_URL` (MySQL connection string)
- `DATABASE_USERNAME`
- `DATABASE_PASSWORD`

## Monitoring Deployment

Check Azure App Service logs to see if there are any startup errors:
- Go to Azure Portal → App Service → Monitoring → Log stream
- Look for any error messages during application startup
