# Commands Summary - Spring Boot Setup

This document summarizes all commands executed to set up and run the Spring Boot + Next.js application.

## Initial Setup Phase

### 1. Repository Creation
```bash
# Created new directory for Spring Boot version
cd "/Users/ablir/Documents/Claude Testing/Copy Repo"
mkdir -p brownbag-springboot

# Copied frontend and nginx from original repo
cp -r brownbag-nextjs/frontend brownbag-springboot/
cp -r brownbag-nextjs/nginx brownbag-springboot/

# Created Spring Boot directory structure
mkdir -p brownbag-springboot/backend/src/main/java/com/brownbag/api
mkdir -p brownbag-springboot/backend/src/main/resources
mkdir -p brownbag-springboot/backend/src/test/java/com/brownbag/api

# Created all Spring Boot source files (via Write tool)
# - pom.xml
# - application.yml
# - Java classes (controllers, services, models, config)
```

### 2. Git Initialization
```bash
cd brownbag-springboot

# Initialize git repository
git init

# Stage all files
git add .

# Create initial commit
git commit -m "Initial commit: Next.js + Spring Boot 3.4

Complete full-stack application with Next.js frontend and Spring Boot 3.4 backend.

## Stack
- Next.js 15 with App Router
- Spring Boot 3.4.1 with Java 21
- NextAuth.js v5 for authentication
- Maven for Java dependency management
- Tailwind CSS for styling

## Backend Features
- Spring Boot 3.4.1 with Java 21
- Constructor-based dependency injection
- Lombok for clean code
- Jakarta Bean Validation
- Spring Actuator for monitoring
- Spring DevTools for hot reload
- JavaFaker for fake data generation
- RESTful API endpoints

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>"

# Create GitHub repository and push
gh repo create brownbag-springboot --public --source=. --remote=origin --push
```

**Repository Created:** https://github.com/ablir/brownbag-springboot

## Application Startup Phase

### 3. Clean Up Existing Processes
```bash
# Check for processes on required ports
lsof -i :3001 -i :3000 -i :9898

# Kill existing processes
kill 13971 13972 14553 66996

# Verify ports are free
sleep 2 && lsof -i :3001 -i :3000 -i :9898
```

### 4. Install Prerequisites

#### Install Maven
```bash
brew install maven

# Verify installation
mvn --version
# Output: Apache Maven 3.9.11
```

**Maven Installation Output:**
- Installed: maven 3.9.11
- Dependencies installed: icu4c@78, openjdk (25.0.1)
- Location: /opt/homebrew/Cellar/maven/3.9.11

#### Install Java 21 (LTS)
```bash
# First attempt used Java 25 which came with Maven
# But we need Java 21 for Spring Boot compatibility

brew install openjdk@21

# Set environment variables
export JAVA_HOME=/opt/homebrew/opt/openjdk@21/libexec/openjdk.jdk/Contents/Home
export PATH="$JAVA_HOME/bin:$PATH"

# Verify installation
java -version
# Output: openjdk version "21.0.9"
```

**Java Installation Output:**
- Installed: openjdk@21 version 21.0.9
- Location: /opt/homebrew/Cellar/openjdk@21/21.0.9
- Files: 600 files, 347.5MB

### 5. Fix Lombok Configuration

**Problem:** Build failed with Lombok annotation errors

**Solution:** Updated `pom.xml` to configure Lombok annotation processing:

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

### 6. Build and Start Backend

```bash
cd brownbag-springboot

# Set Java 21 environment
export JAVA_HOME=/opt/homebrew/opt/openjdk@21/libexec/openjdk.jdk/Contents/Home
export PATH="$JAVA_HOME/bin:$PATH"

# Run startup script (which builds and starts backend)
./start.sh
```

**Build Process:**
```bash
# The start.sh script executed:
mvn clean package -DskipTests

# Then started the application:
mvn spring-boot:run
```

**Backend Startup Output:**
```
  .   ____          _            __ _ _
 /\\ / ___'_ __ _ _(_)_ __  __ _ \ \ \ \
( ( )\___ | '_ | '_| | '_ \/ _` | \ \ \ \
 \\/  ___)| |_)| | | | | || (_| |  ) ) ) )
  '  |____| .__|_| |_|_| |_\__, | / / / /
 =========|_|==============|___/=/_/_/_/

 :: Spring Boot ::                (v3.4.1)

2025-11-29 06:54:41 - Starting BrownBagApiApplication using Java 21.0.9
2025-11-29 06:54:49 - Tomcat initialized with port 3001 (http)
2025-11-29 06:54:51 - Tomcat started on port 3001 (http)
2025-11-29 06:54:51 - Started BrownBagApiApplication in 11.586 seconds
```

**Process ID:** 72958

### 7. Fix and Start Frontend

**Problem:** Frontend dependencies were corrupted

```bash
cd frontend

# Remove corrupted node_modules
rm -rf node_modules

# Reinstall dependencies
npm install
# Output: added 365 packages in 11s

# Start frontend
npm run dev > ../frontend.log 2>&1 &
FRONTEND_PID=$!
echo $FRONTEND_PID > ../.frontend.pid
```

**Process ID:** 73768

### 8. Start Nginx

```bash
cd brownbag-springboot

# Start nginx reverse proxy
nginx -c "$PWD/nginx/nginx.conf" -p "$PWD/nginx/" > nginx.log 2>&1 &
NGINX_PID=$!
echo $NGINX_PID > .nginx.pid
```

**Process IDs:** 73238, 73239

### 9. Verification

```bash
# Verify all services running
lsof -i :3001 -i :3000 -i :9898

# Output:
# java    72958  ... TCP *:redwood-broker (LISTEN)   # Port 3001
# nginx   73238  ... TCP *:monkeycom (LISTEN)        # Port 9898
# nginx   73239  ... TCP *:monkeycom (LISTEN)        # Port 9898
# node    73768  ... TCP *:hbci (LISTEN)             # Port 3000
```

**Test endpoints:**
```bash
# Test backend health
curl -s http://localhost:3001/health
# Output: {"status":"UP","components":{"diskSpace":{"status":"UP"...

# Test frontend
curl -s http://localhost:3000
# Output: <!DOCTYPE html><html...

# Test nginx
curl -s http://localhost:9898
# Output: <!DOCTYPE html><html...
```

## Summary of Installed Software

| Software | Version | Location |
|----------|---------|----------|
| Java (OpenJDK) | 21.0.9 | /opt/homebrew/Cellar/openjdk@21/21.0.9 |
| Maven | 3.9.11 | /opt/homebrew/Cellar/maven/3.9.11 |
| Node.js | 20.19.5 | (already installed) |
| npm | (with Node) | (already installed) |
| Nginx | (with brew) | /opt/homebrew |

## Key Environment Variables

```bash
export JAVA_HOME=/opt/homebrew/opt/openjdk@21/libexec/openjdk.jdk/Contents/Home
export PATH="$JAVA_HOME/bin:$PATH"
```

**Add to shell profile for persistence:**
```bash
echo 'export JAVA_HOME=/opt/homebrew/opt/openjdk@21/libexec/openjdk.jdk/Contents/Home' >> ~/.zshrc
echo 'export PATH="$JAVA_HOME/bin:$PATH"' >> ~/.zshrc
```

## Application Status

| Service | Port | Status | URL |
|---------|------|--------|-----|
| Spring Boot Backend | 3001 | ✅ Running | http://localhost:3001 |
| Next.js Frontend | 3000 | ✅ Running | http://localhost:3000 |
| Nginx Reverse Proxy | 9898 | ✅ Running | http://localhost:9898 |

## API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | /api/login | Login with any credentials |
| GET | /api/user/infos?username=X | Get fake user data |
| GET | /health | Health check (Actuator) |

## Files Created/Modified

### New Files
- `backend/pom.xml` - Maven configuration
- `backend/src/main/resources/application.yml` - Spring Boot config
- `backend/src/main/java/com/brownbag/api/` - Java source files
- `SETUP.md` - This documentation
- `COMMANDS_SUMMARY.md` - Command reference
- `MIGRATION.md` - Migration guide
- `README.md` - Project documentation

### Modified Files
- `nginx/nginx.conf` - Updated comment (Express → Spring Boot)
- `start.sh` - Enhanced with Java/Maven checks
- `backend/pom.xml` - Added Lombok annotation processing

## Troubleshooting Applied

1. **Lombok not processing annotations**
   - Added maven-compiler-plugin with annotationProcessorPaths

2. **Java version mismatch**
   - Installed Java 21 LTS
   - Set JAVA_HOME environment variable

3. **Frontend dependencies corrupted**
   - Removed and reinstalled node_modules

4. **Ports already in use**
   - Identified and killed existing processes

## Next Steps (Optional Enhancements)

1. **Add Database Integration**
   ```bash
   # Add to pom.xml
   <dependency>
       <groupId>org.springframework.boot</groupId>
       <artifactId>spring-boot-starter-data-jpa</artifactId>
   </dependency>
   ```

2. **Add Spring Security**
   ```bash
   # Add to pom.xml
   <dependency>
       <groupId>org.springframework.boot</groupId>
       <artifactId>spring-boot-starter-security</artifactId>
   </dependency>
   ```

3. **Add API Documentation (Swagger)**
   ```bash
   # Add to pom.xml
   <dependency>
       <groupId>org.springdoc</groupId>
       <artifactId>springdoc-openapi-starter-webmvc-ui</artifactId>
       <version>2.3.0</version>
   </dependency>
   ```

   Then access at: http://localhost:3001/swagger-ui.html

## References

- Original Repository: https://github.com/ablir/brownbag-nextjs
- New Repository: https://github.com/ablir/brownbag-springboot
- Spring Boot Docs: https://spring.io/projects/spring-boot
- Maven Docs: https://maven.apache.org/guides/
- Java 21 Release Notes: https://openjdk.org/projects/jdk/21/

---

**Setup Completed:** 2025-11-29
**Total Setup Time:** ~15 minutes
**Services Status:** All Running ✅
