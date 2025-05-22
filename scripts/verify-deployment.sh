#!/bin/bash
# Krabbel Deployment Verification Script

# Define your Azure resources
WEBAPP_NAME="krabbel-backend"

# Check if the application is running
echo "Checking if the backend is running..."
curl -s -o /dev/null -w "%{http_code}" "https://${WEBAPP_NAME}.azurewebsites.net/actuator/health"
echo ""

# Test authentication
echo "Testing authentication..."
LOGIN_RESULT=$(curl -s -X POST \
  -H "Content-Type: application/json" \
  -d '{"username":"admin","password":"admin123"}' \
  "https://${WEBAPP_NAME}.azurewebsites.net/api/auth/login")

echo "Login response: $LOGIN_RESULT"
TOKEN=$(echo $LOGIN_RESULT | grep -o '"token":"[^"]*' | sed 's/"token":"//')

if [ -n "$TOKEN" ]; then
  echo "Successfully authenticated!"
  
  # Test a protected endpoint
  echo "Testing protected endpoint (get notes)..."
  curl -s -H "Authorization: Bearer $TOKEN" "https://${WEBAPP_NAME}.azurewebsites.net/api/notes"
else
  echo "Authentication failed. Check the backend logs."
fi

# Security check reminder
echo ""
echo "IMPORTANT SECURITY REMINDER"
echo "============================"
echo "1. Change default admin/user passwords immediately"
echo "2. Verify all environment variables are set correctly"
echo "3. Check that SSL/TLS is properly configured"
echo "4. Review Azure security recommendations"
