package com.brownbag.api.model;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * UserInfo DTO
 *
 * Represents complete user information returned to clients
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UserInfo {
    private String id;
    private String username;
    private String email;
    private String firstName;
    private String lastName;
    private String avatar;
    private String phone;
    private Address address;
    private String company;
    private String jobTitle;
    private String bio;
    private String joinedDate;
    private String lastLogin;
}
