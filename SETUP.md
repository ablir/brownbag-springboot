# Setup Guide: Commands & Troubleshooting

This document contains all the commands used to set up and run the Spring Boot + Next.js application, along with troubleshooting steps.

## Table of Contents
- [Prerequisites Installation](#prerequisites-installation)
- [Initial Setup Commands](#initial-setup-commands)
- [Starting the Application](#starting-the-application)
- [Troubleshooting](#troubleshooting)
- [Manual Service Management](#manual-service-management)

## Prerequisites Installation

### 1. Install Java 21 (LTS)

**macOS:**
```bash
# Install Java 21 via Homebrew
brew install openjdk@21

# Set JAVA_HOME environment variable
export JAVA_HOME=/opt/homebrew/opt/openjdk@21/libexec/openjdk.jdk/Contents/Home
export PATH="$JAVA_HOME/bin:$PATH"

# Add to your shell profile for persistence
echo 'export JAVA_HOME=/opt/homebrew/opt/openjdk@21/libexec/openjdk.jdk/Contents/Home' >> ~/.zshrc
echo 'export PATH="$JAVA_HOME/bin:$PATH"' >> ~/.zshrc

# Verify installation
java -version
# Should output: openjdk version "21.0.9"
```

**Ubuntu/Debian:**
```bash
# Install Java 21
sudo apt update
sudo apt install openjdk-21-jdk

# Verify installation
java -version
```

### 2. Install Maven

**macOS:**
```bash
# Install Maven via Homebrew
brew install maven

# Verify installation
mvn -version
# Should output: Apache Maven 3.9.11
```

**Ubuntu/Debian:**
```bash
# Install Maven
sudo apt update
sudo apt install maven

# Verify installation
mvn -version
```

### 3. Install Node.js & npm

**macOS:**
```bash
# Install Node.js via Homebrew
brew install node

# Verify installation
node --version  # Should be 20+
npm --version
```

**Ubuntu/Debian:**
```bash
# Install Node.js 20.x
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install nodejs

# Verify installation
node --version
npm --version
```

### 4. Install Nginx (Optional)

**macOS:**
```bash
brew install nginx
```

**Ubuntu/Debian:**
```bash
sudo apt install nginx
```

## Initial Setup Commands

### Clone Repository

```bash
# Clone the repository
git clone https://github.com/ablir/brownbag-springboot.git
cd brownbag-springboot
```

### Install Frontend Dependencies

```bash
# Navigate to frontend directory
cd frontend

# Install dependencies
npm install

# Return to root directory
cd ..
```

## Starting the Application

### Option 1: Automated Startup (Recommended)

```bash
# Make start script executable
chmod +x start.sh

# Set Java 21 environment variables
export JAVA_HOME=/opt/homebrew/opt/openjdk@21/libexec/openjdk.jdk/Contents/Home
export PATH="$JAVA_HOME/bin:$PATH"

# Start all services
./start.sh
```

**What the script does:**
1. Checks for Java 21+ and Maven
2. Installs frontend dependencies if needed
3. Builds Spring Boot backend
4. Starts Spring Boot backend on port 3001
5. Waits for backend health check
6. Starts Next.js frontend on port 3000
7. Starts nginx on port 9898 (if available)

### Option 2: Manual Service Startup

See [Manual Service Management](#manual-service-management) section below.

## Troubleshooting

### Problem: Ports Already in Use

**Error:** `Port 3001/3000/9898 already in use`

**Solution:**
```bash
# Check what's running on the ports
lsof -i :3001 -i :3000 -i :9898

# Kill processes by PID
kill <PID>

# Or use the stop script
./stop.sh

# Then restart
./start.sh
```

### Problem: Java Version Mismatch

**Error:** `Warning: Java 21 or higher is recommended (found Java 17)`

**Solution:**
```bash
# Check current Java version
java -version

# Install Java 21
brew install openjdk@21

# Set JAVA_HOME
export JAVA_HOME=/opt/homebrew/opt/openjdk@21/libexec/openjdk.jdk/Contents/Home
export PATH="$JAVA_HOME/bin:$PATH"

# Verify
java -version  # Should show 21.0.9
```

### Problem: Maven Not Found

**Error:** `Error: Maven is not installed`

**Solution:**
```bash
# Install Maven
brew install maven

# Verify installation
mvn -version
```

### Problem: Backend Build Fails with Lombok Errors

**Error:** `cannot find symbol: variable log` or `cannot find symbol: method builder()`

**Solution:** This was fixed by adding Lombok annotation processing configuration to `pom.xml`:

```xml
<plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-compiler-plugin</artifactId>
    <configuration>
        <source>21</source>
        <target>21</target>
        <annotationProcessorPaths>
            <path>
                <groupId>org.projectlombok</groupId>
                <artifactId>lombok</artifactId>
                <version>1.18.36</version>
            </path>
        </annotationProcessorPaths>
    </configuration>
</plugin>
```

### Problem: Frontend Module Not Found

**Error:** `Cannot find module '../server/require-hook'`

**Solution:**
```bash
# Navigate to frontend directory
cd frontend

# Remove corrupted node_modules
rm -rf node_modules

# Reinstall dependencies
npm install

# Verify package.lock exists
ls -la package-lock.json

# Return to root
cd ..
```

### Problem: Backend Starts but Health Check Fails

**Solution:**
```bash
# Check backend logs
tail -f backend.log

# The backend takes 10-15 seconds to fully start
# Wait for the message: "Started BrownBagApiApplication in X seconds"

# Manually test health endpoint
curl http://localhost:3001/health
```

### Problem: CORS Errors in Browser

**Error:** `Access to fetch at 'http://localhost:3001/api/login' from origin 'http://localhost:3000' has been blocked by CORS policy`

**Solution:** This should not happen as CORS is configured in `CorsConfig.java`. If it does:

```bash
# Verify CorsConfig.java has correct configuration
cat backend/src/main/java/com/brownbag/api/config/CorsConfig.java

# Restart backend
./stop.sh
./start.sh
```

## Manual Service Management

### Start Services Individually

#### 1. Start Spring Boot Backend

```bash
# Navigate to backend directory
cd backend

# Set Java 21
export JAVA_HOME=/opt/homebrew/opt/openjdk@21/libexec/openjdk.jdk/Contents/Home
export PATH="$JAVA_HOME/bin:$PATH"

# Build the project (first time or after code changes)
mvn clean package -DskipTests

# Run Spring Boot
mvn spring-boot:run

# Or run the JAR directly
java -jar target/brownbag-api-1.0.0.jar
```

**Backend runs on:** http://localhost:3001

#### 2. Start Next.js Frontend

```bash
# Navigate to frontend directory (in a new terminal)
cd frontend

# Install dependencies (first time only)
npm install

# Start development server
npm run dev
```

**Frontend runs on:** http://localhost:3000

#### 3. Start Nginx (Optional)

```bash
# Navigate to root directory (in a new terminal)
cd brownbag-springboot

# Start nginx
nginx -c "$PWD/nginx/nginx.conf" -p "$PWD/nginx/"
```

**Nginx runs on:** http://localhost:9898

### Stop Services Individually

```bash
# Stop Spring Boot (Ctrl+C in the terminal, or)
lsof -i :3001
kill <PID>

# Stop Next.js (Ctrl+C in the terminal, or)
lsof -i :3000
kill <PID>

# Stop Nginx
lsof -i :9898
kill <PID>

# Or use the automated script
./stop.sh
```

## Verification Commands

### Check All Services Are Running

```bash
# Check ports
lsof -i :3001 -i :3000 -i :9898

# Should show:
# java    <PID>  user   ... TCP *:redwood-broker (LISTEN)   # Port 3001
# node    <PID>  user   ... TCP *:hbci (LISTEN)             # Port 3000
# nginx   <PID>  user   ... TCP *:monkeycom (LISTEN)        # Port 9898
```

### Test API Endpoints

```bash
# Test health endpoint
curl http://localhost:3001/health

# Test login endpoint
curl -X POST http://localhost:3001/api/login \
  -H "Content-Type: application/json" \
  -d '{"username":"john","password":"pass123"}'

# Test user info endpoint
curl http://localhost:3001/api/user/infos?username=john
```

### Test Frontend

```bash
# Test Next.js directly
curl http://localhost:3000

# Test via Nginx
curl http://localhost:9898
```

## Environment Variables

### Backend (Optional)

Create `backend/src/main/resources/application-local.yml`:

```yaml
server:
  port: 3001

spring:
  profiles:
    active: local

logging:
  level:
    com.brownbag: DEBUG
```

Run with custom profile:
```bash
mvn spring-boot:run -Dspring-boot.run.profiles=local
```

### Frontend

Create `frontend/.env.local`:

```env
NEXTAUTH_URL=http://localhost:3000
NEXTAUTH_SECRET=your-secret-key-change-in-production
NEXT_PUBLIC_API_URL=http://localhost:3001
```

## Log Files

All log files are created in the root directory:

```bash
# Backend build log
tail -f backend-build.log

# Backend runtime log
tail -f backend.log

# Frontend log
tail -f frontend.log

# Nginx log
tail -f nginx.log
```

## Quick Reference

### Essential Commands Summary

```bash
# Initial setup (one time)
brew install openjdk@21 maven node
export JAVA_HOME=/opt/homebrew/opt/openjdk@21/libexec/openjdk.jdk/Contents/Home
export PATH="$JAVA_HOME/bin:$PATH"
cd brownbag-springboot
cd frontend && npm install && cd ..

# Start application
./start.sh

# Stop application
./stop.sh

# Check status
lsof -i :3001 -i :3000 -i :9898

# View logs
tail -f backend.log
tail -f frontend.log

# Test endpoints
curl http://localhost:3001/health
curl http://localhost:9898
```

## Production Deployment

### Build for Production

**Backend:**
```bash
cd backend
mvn clean package -DskipTests
java -jar target/brownbag-api-1.0.0.jar
```

**Frontend:**
```bash
cd frontend
npm run build
npm start
```

### Environment Configuration

Set environment variables:
```bash
export JAVA_OPTS="-Xmx512m -Xms256m"
export NODE_ENV=production
export PORT=3001
```

## Docker Deployment (Optional)

### Backend Dockerfile

```dockerfile
FROM eclipse-temurin:21-jdk-alpine
WORKDIR /app
COPY backend/target/brownbag-api-1.0.0.jar app.jar
EXPOSE 3001
ENTRYPOINT ["java", "-jar", "app.jar"]
```

**Build and run:**
```bash
cd backend
mvn clean package -DskipTests
docker build -t brownbag-api .
docker run -p 3001:3001 brownbag-api
```

## Additional Resources

- **Spring Boot Documentation:** https://spring.io/projects/spring-boot
- **Next.js Documentation:** https://nextjs.org/docs
- **Maven Documentation:** https://maven.apache.org/guides/
- **Nginx Documentation:** https://nginx.org/en/docs/

## Support

If you encounter issues not covered in this guide:

1. Check the log files in the root directory
2. Verify all prerequisites are correctly installed
3. Ensure ports 3000, 3001, and 9898 are not in use
4. Open an issue on GitHub with:
   - Error message
   - Relevant log output
   - Output of `java -version` and `mvn -version`

---

**Last Updated:** 2025-11-29
**Application Version:** 1.0.0
**Spring Boot Version:** 3.4.1
**Java Version:** 21.0.9
