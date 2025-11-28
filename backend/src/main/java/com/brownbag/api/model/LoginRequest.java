package com.brownbag.api.model;

import jakarta.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * Login Request DTO (Data Transfer Object)
 *
 * Uses modern Jakarta validation (javax.validation was replaced with jakarta.validation in Spring Boot 3+)
 *
 * @Data: Generates getters, setters, toString, equals, and hashCode
 * @NoArgsConstructor: Generates no-args constructor
 * @AllArgsConstructor: Generates constructor with all fields
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class LoginRequest {

    @NotBlank(message = "Username is required")
    private String username;

    @NotBlank(message = "Password is required")
    private String password;
}
