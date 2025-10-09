package com.example.hims.controller;

import com.example.hims.dao.UserDao;
import com.example.hims.dto.AuthRequestDTO;
import com.example.hims.dto.AuthResponseDTO;
import com.example.hims.entity.User;
import com.example.hims.exception.UserEmailExistException;
import com.example.hims.exception.UserNotFoundException;
import com.example.security.JwtUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.*;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.*;
import org.springframework.transaction.annotation.Transactional;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletResponse;
import javax.validation.Valid;
import java.util.HashMap;
import java.util.Map;

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
    public ResponseEntity<?> register(@Valid @RequestBody User user, BindingResult result) {
        // Check for validation errors
        if (result.hasErrors()) {
            Map<String, String> errors = new HashMap<>();
            for (FieldError error : result.getFieldErrors()) {
                errors.put(error.getField(), error.getDefaultMessage());
            }
            return ResponseEntity.badRequest().body(errors);
        }
        
        // Check if email already exists
        if (userRepository.existsByEmail(user.getEmail())) {
            throw new UserEmailExistException("Email " + user.getEmail() + " is already registered");
        }
        
        user.setPassword(passwordEncoder.encode(user.getPassword()));
        userRepository.save(user);
        
        return ResponseEntity.ok("Registered successfully");
    }

    @PostMapping("/login")
    public ResponseEntity<?> login(@Valid @RequestBody AuthRequestDTO req, BindingResult result, HttpServletResponse response) {
        // Check for validation errors
        if (result.hasErrors()) {
            Map<String, String> errors = new HashMap<>();
            for (FieldError error : result.getFieldErrors()) {
                errors.put(error.getField(), error.getDefaultMessage());
            }
            return ResponseEntity.badRequest().body(errors);
        }
        
        // Check if user exists
        User u = userRepository.findByEmail(req.getEmail())
            .orElseThrow(() -> new UserNotFoundException("User not found with email: " + req.getEmail()));

        try {
            // Authenticate user
            authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(req.getEmail(), req.getPassword())
            );

            // Generate JWT token
            String token = jwtUtil.generateToken(req.getEmail());

            // Create HttpOnly cookie (secure, not accessible via JS)
            Cookie cookie = new Cookie("jwt_token", token);
            cookie.setHttpOnly(true);
            cookie.setSecure(false);    // Set to true in production (HTTPS only)
            cookie.setPath("/");
            cookie.setMaxAge(24 * 3600); // 1 day in seconds

            // Add cookie to response
            response.addCookie(cookie);

            // Return token and user info in response body
            return ResponseEntity.ok(new AuthResponseDTO(token, u.getId(), u.getRole().name()));

        } catch (BadCredentialsException ex) {
            throw new UserNotFoundException("Invalid credentials for email: " + req.getEmail());
        }
    }
}
