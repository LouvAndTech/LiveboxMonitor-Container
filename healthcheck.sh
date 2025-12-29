#!/bin/bash
# Health check script for LiveboxMonitor container
# Validates that the application is running and accessible

set -e

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo "=== LiveboxMonitor Health Check ==="

# Check 1: Verify the HTTP server is listening on port 3000
echo -n "Checking HTTP server (port 3000)... "
if timeout 5 bash -c "echo > /dev/tcp/localhost/3000" 2>/dev/null; then
    echo -e "${GREEN}✓${NC}"
else
    echo -e "${RED}✗${NC}"
    exit 1
fi

# Check 2: Verify HTTP response from web interface
echo -n "Checking HTTP response (port 3000)... "
if curl -u "$CUSTOM_USER:$PASSWORD" -sf http://localhost:3000/ > /dev/null 2>&1; then
    echo -e "${GREEN}✓${NC}"
else
    echo -e "${RED}✗${NC}"
    exit 1
fi

# Check 3: Verify Python process is running
echo -n "Checking LiveboxMonitor process... "
if pgrep -f "python.*LiveboxMonitor" > /dev/null; then
    echo -e "${GREEN}✓${NC}"
else
    echo -e "${RED}✗${NC}"
    exit 1
fi

# Check 4: Verify config and key files were created
echo -n "Checking configuration files... "
if [ -f "/config/LiveboxMonitor/Config.txt" ] && [ -f "/config/LiveboxMonitor/Key.txt" ]; then
    echo -e "${GREEN}✓${NC}"
else
    echo -e "${RED}✗${NC}"
    exit 1
fi

echo ""
echo -e "${GREEN}All health checks passed!${NC}"
exit 0
