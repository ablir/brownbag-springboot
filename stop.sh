#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

echo -e "${RED}Stopping Brownbag Next.js Monorepo...${NC}"

# Get the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Stop backend
if [ -f "$SCRIPT_DIR/.backend.pid" ]; then
    BACKEND_PID=$(cat "$SCRIPT_DIR/.backend.pid")
    if kill -0 $BACKEND_PID 2>/dev/null; then
        echo "Stopping backend (PID: $BACKEND_PID)..."
        kill $BACKEND_PID
        rm "$SCRIPT_DIR/.backend.pid"
    else
        echo "Backend not running"
        rm "$SCRIPT_DIR/.backend.pid"
    fi
else
    echo "Backend PID file not found"
fi

# Stop frontend
if [ -f "$SCRIPT_DIR/.frontend.pid" ]; then
    FRONTEND_PID=$(cat "$SCRIPT_DIR/.frontend.pid")
    if kill -0 $FRONTEND_PID 2>/dev/null; then
        echo "Stopping frontend (PID: $FRONTEND_PID)..."
        kill $FRONTEND_PID
        rm "$SCRIPT_DIR/.frontend.pid"
    else
        echo "Frontend not running"
        rm "$SCRIPT_DIR/.frontend.pid"
    fi
else
    echo "Frontend PID file not found"
fi

# Stop nginx
if [ -f "$SCRIPT_DIR/.nginx.pid" ]; then
    NGINX_PID=$(cat "$SCRIPT_DIR/.nginx.pid")
    if kill -0 $NGINX_PID 2>/dev/null; then
        echo "Stopping nginx (PID: $NGINX_PID)..."
        kill $NGINX_PID
        rm "$SCRIPT_DIR/.nginx.pid"
    else
        echo "Nginx not running"
        rm "$SCRIPT_DIR/.nginx.pid"
    fi
else
    echo "Nginx PID file not found"
fi

# Clean up any remaining node processes (optional, commented out for safety)
# pkill -f "next"
# pkill -f "ts-node-dev"

echo -e "${GREEN}✓ All services stopped${NC}"
