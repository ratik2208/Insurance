package com.example.hims.controller;

import com.example.hims.dao.UserDao;
import com.example.hims.dto.AuthRequestDTO;
import com.example.hims.dto.AuthResponseDTO;
import com.example.hims.entity.User;
import com.example.security.JwtUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.*;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;
import org.springframework.transaction.annotation.Transactional;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletResponse;

@RestController
@RequestMapping("/auth")
public class AuthController {

    private final AuthenticationManager authenticationManager;
    private final JwtUtil jwtUtil;
    private final UserDao userRepository;
    private final PasswordEncoder passwordEncoder;

    @Autowired
    public AuthController(AuthenticationManager authenticationManager,
                          JwtUtil jwtUtil,
                          UserDao userRepository,
                          PasswordEncoder passwordEncoder) {
        this.authenticationManager = authenticationManager;
        this.jwtUtil = jwtUtil;
        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
    }

    @PostMapping("/register")
    @Transactional("jpaTransactionManager")
    public ResponseEntity<?> register(@RequestBody User user) {
        if (userRepository.existsByEmail(user.getEmail())) {
            return ResponseEntity.badRequest().body("Email already registered");
        }
        user.setPassword(passwordEncoder.encode(user.getPassword()));
        userRepository.save(user);
        return ResponseEntity.ok("Registered successfully");
    }

    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody AuthRequestDTO req, HttpServletResponse response) {
        try {
            // Authenticate user
            authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(req.getEmail(), req.getPassword())
            );

            // Generate JWT token
            String token = jwtUtil.generateToken(req.getEmail());
            User u = userRepository.findByEmail(req.getEmail()).orElseThrow();

            // Create HttpOnly cookie (secure, not accessible via JS)
            Cookie cookie = new Cookie("jwt_token", token);
            cookie.setHttpOnly(true);   // Prevent XSS access
            cookie.setSecure(false);    // Set to true in production (HTTPS only)
            cookie.setPath("/");        // Available to all paths
            cookie.setMaxAge(24 * 3600); // 1 day in seconds

            // Add cookie to response
            response.addCookie(cookie);

            // Return token and user info in response body (for frontend use)
            return ResponseEntity.ok(new AuthResponseDTO(token, u.getId(), u.getRole().name()));

        } catch (BadCredentialsException ex) {
            return ResponseEntity.status(401).body("Invalid credentials");
        }
    }
}
