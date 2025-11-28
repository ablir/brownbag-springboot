#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}Starting Brownbag Next.js + Spring Boot Monorepo...${NC}"

# Get the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Check for Java
if ! command -v java &> /dev/null; then
    echo -e "${RED}Error: Java is not installed${NC}"
    echo -e "${YELLOW}Please install Java 21 or higher:${NC}"
    echo -e "${YELLOW}  macOS: brew install openjdk@21${NC}"
    echo -e "${YELLOW}  Ubuntu: sudo apt install openjdk-21-jdk${NC}"
    exit 1
fi

# Check Java version
JAVA_VERSION=$(java -version 2>&1 | awk -F '"' '/version/ {print $2}' | cut -d. -f1)
if [ "$JAVA_VERSION" -lt 21 ]; then
    echo -e "${YELLOW}Warning: Java 21 or higher is recommended (found Java $JAVA_VERSION)${NC}"
fi

# Check for Maven
if ! command -v mvn &> /dev/null; then
    echo -e "${RED}Error: Maven is not installed${NC}"
    echo -e "${YELLOW}Please install Maven:${NC}"
    echo -e "${YELLOW}  macOS: brew install maven${NC}"
    echo -e "${YELLOW}  Ubuntu: sudo apt install maven${NC}"
    exit 1
fi

# Check if frontend node_modules exist
if [ ! -d "$SCRIPT_DIR/frontend/node_modules" ]; then
    echo -e "${YELLOW}Installing frontend dependencies...${NC}"
    cd "$SCRIPT_DIR/frontend" && npm install
fi

# Build Spring Boot backend (first time or if needed)
echo -e "${GREEN}Building Spring Boot backend...${NC}"
cd "$SCRIPT_DIR/backend"
mvn clean package -DskipTests > "$SCRIPT_DIR/backend-build.log" 2>&1
if [ $? -ne 0 ]; then
    echo -e "${RED}Backend build failed. Check backend-build.log for details${NC}"
    exit 1
fi

# Start Spring Boot backend
echo -e "${GREEN}Starting Spring Boot backend on port 3001...${NC}"
cd "$SCRIPT_DIR/backend"
mvn spring-boot:run > "$SCRIPT_DIR/backend.log" 2>&1 &
BACKEND_PID=$!
echo $BACKEND_PID > "$SCRIPT_DIR/.backend.pid"

# Wait for backend to start (check health endpoint)
echo -e "${YELLOW}Waiting for backend to start...${NC}"
sleep 5
for i in {1..30}; do
    if curl -s http://localhost:3001/health > /dev/null 2>&1; then
        echo -e "${GREEN}Backend is ready!${NC}"
        break
    fi
    if [ $i -eq 30 ]; then
        echo -e "${RED}Backend failed to start. Check backend.log for details${NC}"
        exit 1
    fi
    sleep 1
done

# Start frontend (Next.js)
echo -e "${GREEN}Starting Next.js frontend on port 3000...${NC}"
cd "$SCRIPT_DIR/frontend"
npm run dev > "$SCRIPT_DIR/frontend.log" 2>&1 &
FRONTEND_PID=$!
echo $FRONTEND_PID > "$SCRIPT_DIR/.frontend.pid"

# Wait a moment for frontend to start
sleep 3

# Start nginx if available
if command -v nginx &> /dev/null; then
    echo -e "${GREEN}Starting nginx on port 9898...${NC}"
    nginx -c "$SCRIPT_DIR/nginx/nginx.conf" -p "$SCRIPT_DIR/nginx/" > "$SCRIPT_DIR/nginx.log" 2>&1 &
    NGINX_PID=$!
    echo $NGINX_PID > "$SCRIPT_DIR/.nginx.pid"
    NGINX_STATUS="http://localhost:9898 (PID: $NGINX_PID)"
else
    echo -e "${YELLOW}⚠ Nginx not installed - skipping reverse proxy${NC}"
    echo -e "${YELLOW}  Install with: brew install nginx${NC}"
    NGINX_STATUS="Not running (nginx not installed)"
fi

echo -e "${GREEN}✓ Services started!${NC}"
echo ""
echo "Services running:"
echo "  - Backend (Spring Boot): http://localhost:3001 (PID: $BACKEND_PID)"
echo "  - Frontend (Next.js):    http://localhost:3000 (PID: $FRONTEND_PID)"
echo "  - Nginx:                 $NGINX_STATUS"
echo ""
echo "Access your application:"
if command -v nginx &> /dev/null; then
    echo "  - Main:     http://localhost:9898 (via nginx)"
fi
echo "  - Frontend: http://localhost:3000 (direct)"
echo "  - Backend:  http://localhost:3001 (API)"
echo ""
echo "API Endpoints:"
echo "  - Health:   http://localhost:3001/health"
echo "  - Login:    POST http://localhost:3001/api/login"
echo "  - UserInfo: GET http://localhost:3001/api/user/infos?username=john"
echo ""
echo "Logs:"
echo "  - Backend:  tail -f $SCRIPT_DIR/backend.log"
echo "  - Frontend: tail -f $SCRIPT_DIR/frontend.log"
if command -v nginx &> /dev/null; then
    echo "  - Nginx:    tail -f $SCRIPT_DIR/nginx.log"
fi
echo ""
echo "To stop all services, run: ./stop.sh"
