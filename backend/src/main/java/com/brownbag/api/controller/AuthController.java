package com.brownbag.api.controller;

import com.brownbag.api.model.LoginRequest;
import com.brownbag.api.model.LoginResponse;
import com.brownbag.api.service.UserService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * Authentication Controller
 *
 * @RestController: Combines @Controller and @ResponseBody - all methods return JSON
 * @RequestMapping: Base path for all endpoints in this controller
 * @RequiredArgsConstructor: Lombok generates constructor for final fields (dependency injection)
 * @Slf4j: Lombok generates logger field
 *
 * Modern Spring Boot approach:
 * - Constructor injection over field injection
 * - ResponseEntity for explicit HTTP status control
 * - @Valid for automatic request validation
 */
@Slf4j
@RestController
@RequestMapping("/api")
@RequiredArgsConstructor
public class AuthController {

    private final UserService userService;

    /**
     * Login endpoint
     *
     * @param request Login credentials
     * @return Login response with token
     */
    @PostMapping("/login")
    public ResponseEntity<LoginResponse> login(@Valid @RequestBody LoginRequest request) {
        log.info("Login attempt for username: {}", request.getUsername());

        // For demo purposes, accept any valid credentials
        if (request.getUsername() != null && request.getPassword() != null) {
            String token = userService.generateToken();

            LoginResponse response = LoginResponse.builder()
                    .success(true)
                    .message("Login successful")
                    .token(token)
                    .username(request.getUsername())
                    .build();

            return ResponseEntity.ok(response);
        }

        // This branch shouldn't be reached due to @Valid annotation
        LoginResponse errorResponse = LoginResponse.builder()
                .success(false)
                .message("Username and password are required")
                .build();

        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(errorResponse);
    }
}
