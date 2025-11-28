package com.brownbag.api.service;

import com.brownbag.api.model.Address;
import com.brownbag.api.model.UserInfo;
import com.github.javafaker.Faker;
import org.springframework.stereotype.Service;

import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.UUID;
import java.util.concurrent.TimeUnit;

/**
 * User Service
 *
 * @Service: Marks this as a Spring service component for business logic
 * Service layer follows Single Responsibility Principle - handles user-related operations
 */
@Service
public class UserService {

    private final Faker faker;

    /**
     * Constructor injection (preferred over field injection)
     * Spring will automatically create and inject the Faker bean
     */
    public UserService() {
        this.faker = new Faker();
    }

    /**
     * Generates fake user information
     *
     * @param username The username to associate with the generated data
     * @return UserInfo object with fake data
     */
    public UserInfo generateUserInfo(String username) {
        // Generate random past date for joinedDate (within last 2 years)
        Instant joinedDate = Instant.now()
                .minus(faker.number().numberBetween(1, 730), ChronoUnit.DAYS);

        return UserInfo.builder()
                .id(UUID.randomUUID().toString())
                .username(username)
                .email(faker.internet().emailAddress())
                .firstName(faker.name().firstName())
                .lastName(faker.name().lastName())
                .avatar(faker.internet().avatar())
                .phone(faker.phoneNumber().phoneNumber())
                .address(Address.builder()
                        .street(faker.address().streetAddress())
                        .city(faker.address().city())
                        .state(faker.address().state())
                        .zipCode(faker.address().zipCode())
                        .country(faker.address().country())
                        .build())
                .company(faker.company().name())
                .jobTitle(faker.job().title())
                .bio(faker.lorem().sentence(20))
                .joinedDate(joinedDate.toString())
                .lastLogin(Instant.now().toString())
                .build();
    }

    /**
     * Generates a random token for authentication
     *
     * @return Random alphanumeric token
     */
    public String generateToken() {
        return faker.regexify("[a-zA-Z0-9]{32}");
    }
}
