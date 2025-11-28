package com.brownbag.api.controller;

import com.brownbag.api.model.UserInfo;
import com.brownbag.api.service.UserService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

/**
 * User Controller
 *
 * Handles user-related endpoints
 */
@Slf4j
@RestController
@RequestMapping("/api/user")
@RequiredArgsConstructor
public class UserController {

    private final UserService userService;

    /**
     * Get user information endpoint
     *
     * @param username Optional username parameter (defaults to "user")
     * @return UserInfo with fake data
     */
    @GetMapping("/infos")
    public ResponseEntity<UserInfo> getUserInfo(
            @RequestParam(defaultValue = "user") String username) {

        log.info("Fetching user info for: {}", username);

        UserInfo userInfo = userService.generateUserInfo(username);
        return ResponseEntity.ok(userInfo);
    }
}
