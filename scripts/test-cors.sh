#!/bin/bash

# Test CORS configuration for Azure deployment

BACKEND_URL="https://krabbel-ezb4d0gffwhtepa0.westeurope-01.azurewebsites.net"
FRONTEND_URL="https://ashy-smoke-03b3efb03.2.azurestaticapps.net"

echo "Testing Azure Backend CORS Configuration"
echo "========================================"
echo ""

echo "1. Testing root endpoint..."
curl -s -X GET "$BACKEND_URL/" | jq '.' 2>/dev/null || curl -s -X GET "$BACKEND_URL/"
echo ""

echo "2. Testing CORS configuration endpoint..."
curl -s -X GET "$BACKEND_URL/cors-config" | jq '.' 2>/dev/null || curl -s -X GET "$BACKEND_URL/cors-config"
echo ""

echo "3. Testing OPTIONS preflight request to login endpoint..."
curl -v -X OPTIONS "$BACKEND_URL/api/auth/login" \
  -H "Origin: $FRONTEND_URL" \
  -H "Access-Control-Request-Method: POST" \
  -H "Access-Control-Request-Headers: Content-Type,Authorization" \
  2>&1 | grep -E "(HTTP|Access-Control|Origin)"
echo ""

echo "4. Testing actual login request with CORS headers..."
curl -v -X POST "$BACKEND_URL/api/auth/login" \
  -H "Origin: $FRONTEND_URL" \
  -H "Content-Type: application/json" \
  -d '{"username":"user","password":"S@cur3Us3rP@s5w0rd!"}' \
  2>&1 | grep -E "(HTTP|Access-Control|Origin|401|405)"
echo ""

echo "Test completed. Check the responses above for CORS headers and HTTP status codes."
