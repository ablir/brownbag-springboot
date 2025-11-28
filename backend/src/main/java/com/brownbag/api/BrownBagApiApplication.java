package com.brownbag.api;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

/**
 * Main Spring Boot Application
 *
 * @SpringBootApplication enables:
 * - @Configuration: Tags the class as a source of bean definitions
 * - @EnableAutoConfiguration: Enables Spring Boot's auto-configuration
 * - @ComponentScan: Enables component scanning in the current package
 */
@SpringBootApplication
public class BrownBagApiApplication {

    public static void main(String[] args) {
        SpringApplication.run(BrownBagApiApplication.class, args);
    }
}
