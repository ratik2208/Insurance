package com.example.security;

import com.example.hims.entity.User;
import com.example.hims.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.*;
import org.springframework.stereotype.Service;

import java.util.Collections;

/**
 * Custom UserDetailsService for HIMS.
 * Loads User by email and maps user's role to Spring authority "ROLE_<ROLE>".
 */
@Service
public class CustomUserDetailsService implements UserDetailsService {

    private final UserService userService;

    @Autowired
    public CustomUserDetailsService(UserService userService) {
        this.userService = userService;
    }

    /**
     * Load user by email (used as username).
     */
    @Override
    public UserDetails loadUserByUsername(String email) throws UsernameNotFoundException {
        if (email != null) {
            email = email.trim();
        }

        User appUser = userService.findByEmail(email);
        if (appUser == null) {
            throw new UsernameNotFoundException("User not found with email: " + email);
        }

        // Build authority: ROLE_ADMIN / ROLE_AGENT / ROLE_CUSTOMER
        String roleName = (appUser.getRole() != null) ? appUser.getRole().name() : "CUSTOMER";
        String authority = "ROLE_" + roleName.toUpperCase();

        return org.springframework.security.core.userdetails.User
                .withUsername(appUser.getEmail())
                .password(appUser.getPassword() == null ? "" : appUser.getPassword())
                .authorities(Collections.singletonList(new SimpleGrantedAuthority(authority)))
                .accountExpired(false)
                .accountLocked(false)
                .credentialsExpired(false)
                .disabled(false)
                .build();
    }
}
