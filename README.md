# BrownBag Next.js + Spring Boot Monorepo

A modern full-stack application combining **Next.js 15** (App Router) with **Spring Boot 3.4** backend, featuring NextAuth.js v5 authentication and fake data generation.

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    Nginx Reverse Proxy                      │
│                    (Port 9898)                              │
└──────────────┬───────────────────────┬─────────────────────┘
               │                       │
    ┌──────────▼──────────┐  ┌────────▼────────────┐
    │   Next.js Frontend  │  │  Spring Boot API    │
    │   (Port 3000)       │  │  (Port 3001)        │
    │                     │  │                     │
    │  • App Router       │  │  • REST API         │
    │  • NextAuth.js v5   │  │  • JavaFaker        │
    │  • Tailwind CSS     │  │  • Spring Web       │
    │  • React 19         │  │  • Lombok           │
    └─────────────────────┘  └─────────────────────┘
```

## 📋 Table of Contents

- [Technology Stack](#-technology-stack)
- [Prerequisites](#-prerequisites)
- [Quick Start](#-quick-start)
- [Project Structure](#-project-structure)
- [API Endpoints](#-api-endpoints)
- [Spring Boot Modern Practices](#-spring-boot-modern-practices)
- [Development](#-development)

## 🚀 Technology Stack

### Frontend
- **Next.js 15** - React framework with App Router
- **React 19** - Latest React with concurrent features
- **NextAuth.js v5** - Authentication for Next.js
- **Tailwind CSS** - Utility-first CSS framework
- **TypeScript** - Type-safe JavaScript

### Backend
- **Spring Boot 3.4.1** - Modern Java framework
- **Java 21** - Latest LTS Java version with virtual threads
- **Spring Web** - RESTful API development
- **Spring Validation** - Jakarta Bean Validation
- **Spring Actuator** - Production-ready monitoring
- **Spring DevTools** - Development-time features
- **Lombok** - Reduce boilerplate code
- **JavaFaker** - Generate realistic fake data
- **Maven** - Dependency management

### Infrastructure
- **Nginx** - Reverse proxy (optional)
- **Git** - Version control

## 📦 Prerequisites

### Required

- **Java 21** or higher
  ```bash
  # macOS
  brew install openjdk@21

  # Ubuntu/Debian
  sudo apt install openjdk-21-jdk

  # Verify installation
  java -version
  ```

- **Maven 3.9+**
  ```bash
  # macOS
  brew install maven

  # Ubuntu/Debian
  sudo apt install maven

  # Verify installation
  mvn -version
  ```

- **Node.js 20+** and **npm**
  ```bash
  # macOS
  brew install node

  # Ubuntu/Debian (using NodeSource)
  curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
  sudo apt install nodejs

  # Verify installation
  node --version
  npm --version
  ```

### Optional

- **Nginx** (for reverse proxy)
  ```bash
  # macOS
  brew install nginx

  # Ubuntu/Debian
  sudo apt install nginx
  ```

## 🎯 Quick Start

### 1. Clone the Repository

```bash
git clone https://github.com/ablir/brownbag-springboot.git
cd brownbag-springboot
```

### 2. Start All Services

```bash
chmod +x start.sh
./start.sh
```

The script will:
- ✅ Check for Java 21+ and Maven
- ✅ Install frontend dependencies (if needed)
- ✅ Build Spring Boot backend
- ✅ Start backend on port 3001
- ✅ Wait for backend health check
- ✅ Start Next.js frontend on port 3000
- ✅ Start nginx on port 9898 (if available)

### 3. Access the Application

- **Main Application:** http://localhost:9898 (via nginx)
- **Frontend Direct:** http://localhost:3000
- **Backend API:** http://localhost:3001
- **Health Check:** http://localhost:3001/health

### 4. Login

Navigate to the login page and enter any credentials:
- **Username:** any value
- **Password:** any value

The app accepts any credentials for demo purposes.

### 5. Stop Services

```bash
./stop.sh
```

## 📁 Project Structure

```
brownbag-springboot/
├── backend/                          # Spring Boot Backend
│   ├── src/
│   │   ├── main/
│   │   │   ├── java/com/brownbag/api/
│   │   │   │   ├── BrownBagApiApplication.java    # Main app entry
│   │   │   │   ├── config/
│   │   │   │   │   └── CorsConfig.java            # CORS configuration
│   │   │   │   ├── controller/
│   │   │   │   │   ├── AuthController.java        # /api/login
│   │   │   │   │   ├── UserController.java        # /api/user/infos
│   │   │   │   │   └── HealthController.java      # /health
│   │   │   │   ├── model/
│   │   │   │   │   ├── LoginRequest.java          # Login DTO
│   │   │   │   │   ├── LoginResponse.java         # Login response
│   │   │   │   │   ├── UserInfo.java              # User data DTO
│   │   │   │   │   └── Address.java               # Address model
│   │   │   │   └── service/
│   │   │   │       └── UserService.java           # Business logic
│   │   │   └── resources/
│   │   │       └── application.yml                # Spring configuration
│   │   └── test/                                  # Test directory
│   ├── pom.xml                                    # Maven dependencies
│   └── .gitignore
│
├── frontend/                         # Next.js Frontend
│   ├── app/
│   │   ├── api/auth/[...nextauth]/
│   │   │   └── route.ts                          # NextAuth.js routes
│   │   ├── dashboard/
│   │   │   ├── page.tsx                          # Dashboard page
│   │   │   └── user-profile.tsx                  # User profile component
│   │   ├── login/
│   │   │   ├── page.tsx                          # Login page
│   │   │   └── login-form.tsx                    # Login form
│   │   ├── layout.tsx                            # Root layout
│   │   └── page.tsx                              # Home page
│   ├── auth.ts                                   # NextAuth.js config
│   ├── middleware.ts                             # Route protection
│   ├── next.config.ts                            # Next.js config
│   ├── tailwind.config.ts                        # Tailwind config
│   └── package.json
│
├── nginx/
│   └── nginx.conf                                # Nginx configuration
│
├── start.sh                                       # Start all services
├── stop.sh                                        # Stop all services
├── README.md                                      # This file
└── MIGRATION.md                                   # Migration guide
```

## 🔌 API Endpoints

### POST /api/login
Authenticates user and returns token.

**Request:**
```json
{
  "username": "john",
  "password": "password123"
}
```

**Response:**
```json
{
  "success": true,
  "message": "Login successful",
  "token": "abc123...",
  "username": "john"
}
```

### GET /api/user/infos
Returns fake user information.

**Query Parameters:**
- `username` (optional) - Defaults to "user"

**Example:** `GET /api/user/infos?username=john`

**Response:**
```json
{
  "id": "550e8400-e29b-41d4-a716-446655440000",
  "username": "john",
  "email": "john.doe@example.com",
  "firstName": "John",
  "lastName": "Doe",
  "avatar": "https://cdn.example.com/avatar.png",
  "phone": "+1-555-123-4567",
  "address": {
    "street": "123 Main St",
    "city": "Springfield",
    "state": "IL",
    "zipCode": "62701",
    "country": "USA"
  },
  "company": "Acme Corp",
  "jobTitle": "Software Engineer",
  "bio": "Passionate developer...",
  "joinedDate": "2023-05-15T10:30:00Z",
  "lastLogin": "2025-11-29T12:00:00Z"
}
```

### GET /health
Health check endpoint.

**Response:**
```json
{
  "status": "ok",
  "timestamp": "2025-11-29T12:00:00Z"
}
```

## 🎨 Spring Boot Modern Practices

This project follows Spring Boot 3.x best practices and modern Java development:

### 1. **Java 21 Features**
- Virtual threads (Project Loom) support
- Pattern matching
- Record classes (can be used for DTOs)
- Latest performance improvements

### 2. **Constructor-Based Dependency Injection**
```java
@RestController
@RequiredArgsConstructor  // Lombok generates constructor
public class AuthController {
    private final UserService userService;  // Injected via constructor
}
```

**Why?** More testable, immutable, and safer than field injection.

### 3. **Lombok for Clean Code**
```java
@Data                    // Getters, setters, toString, equals, hashCode
@Builder                 // Builder pattern
@NoArgsConstructor       // Default constructor
@AllArgsConstructor      // All-args constructor
public class UserInfo {
    private String id;
    private String username;
    // ...
}
```

**Why?** Reduces boilerplate by 70%, improves readability.

### 4. **Jakarta Validation**
```java
public class LoginRequest {
    @NotBlank(message = "Username is required")
    private String username;

    @NotBlank(message = "Password is required")
    private String password;
}
```

**Why?** Declarative validation, automatic error responses.

### 5. **ResponseEntity for HTTP Control**
```java
@PostMapping("/login")
public ResponseEntity<LoginResponse> login(@Valid @RequestBody LoginRequest request) {
    LoginResponse response = // ...
    return ResponseEntity.ok(response);
}
```

**Why?** Explicit control over status codes and headers.

### 6. **Layered Architecture**
- **Controller Layer** - Handle HTTP requests/responses
- **Service Layer** - Business logic
- **Model Layer** - Data structures

**Why?** Separation of concerns, testability, maintainability.

### 7. **Configuration Classes**
```java
@Configuration
public class CorsConfig {
    @Bean
    public CorsFilter corsFilter() {
        // Configuration
    }
}
```

**Why?** Type-safe configuration, IDE support, easy testing.

### 8. **Actuator for Production**
- `/health` - Application health status
- Can be extended with custom metrics

**Why?** Production monitoring, Kubernetes readiness/liveness probes.

### 9. **DevTools for Development**
- Automatic restart on code changes
- LiveReload support
- Disabled in production automatically

**Why?** Faster development cycle.

### 10. **YAML Configuration**
```yaml
server:
  port: ${PORT:3001}
spring:
  application:
    name: brownbag-api
```

**Why?** More readable than properties files, supports nested structures.

## 🛠️ Development

### Backend Development

#### Run in Development Mode
```bash
cd backend
mvn spring-boot:run
```

Changes to Java files will trigger automatic restart (via DevTools).

#### Build JAR
```bash
cd backend
mvn clean package
```

JAR file will be in `target/brownbag-api-1.0.0.jar`

#### Run Tests
```bash
cd backend
mvn test
```

### Frontend Development

#### Run Dev Server
```bash
cd frontend
npm run dev
```

#### Build for Production
```bash
cd frontend
npm run build
npm start
```

### Environment Variables

#### Backend (application.yml)
```yaml
server:
  port: 3001

spring:
  profiles:
    active: dev
```

#### Frontend (.env.local)
```bash
NEXTAUTH_URL=http://localhost:3000
NEXTAUTH_SECRET=your-secret-key-here
NEXT_PUBLIC_API_URL=http://localhost:3001
```

## 🔐 Security Notes

Current implementation is for **development/demo only**:

- CORS configured for all origins
- Authentication accepts any credentials
- No database persistence
- No JWT validation

**For Production:**
1. Configure specific CORS origins
2. Implement real authentication (Spring Security)
3. Add database (Spring Data JPA)
4. Enable HTTPS
5. Use environment variables for secrets
6. Add rate limiting
7. Implement proper session management

## 📊 Performance

Spring Boot 3.4 with Java 21 benefits:
- **Virtual Threads** - Handle 10,000+ concurrent connections
- **AOT Compilation** - Faster startup with GraalVM
- **Optimized Memory** - Better garbage collection
- **DevTools** - Sub-second restart times

## 🤝 Contributing

1. Fork the repository
2. Create feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open Pull Request

## 📄 License

This project is licensed under the MIT License.

## 🙏 Acknowledgments

- Spring Boot team for excellent documentation
- Next.js team for the App Router
- NextAuth.js for authentication
- JavaFaker for realistic test data

---

**Built with ❤️ using Spring Boot 3.4 and Next.js 15**
