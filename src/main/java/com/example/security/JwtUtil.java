
package com.example.security;

import io.jsonwebtoken.*;
import io.jsonwebtoken.security.Keys;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import javax.annotation.PostConstruct;
import java.security.Key;
import java.util.Date;

/**
 * JWT utilities for HIMS.
 * Configure secret & expiration in properties: hims.jwt.secret, hims.jwt.expirationMs
 */
@Component
public class JwtUtil {

    @Value("${hims.jwt.secret:my-secret-key-must-be-at-least-32-characters-long-for-hs256-algorithm}")
    private String jwtSecret;

    @Value("${hims.jwt.expirationMs:86400000}") // 24 hours default
    private long expirationMs;

    private Key signingKey;

    @PostConstruct
    public void init() {
        // Create a signing key from secret (HS256). Secret must be at least 32 chars.
        signingKey = Keys.hmacShaKeyFor(jwtSecret.getBytes());
    }

    /**
     * Generate JWT token for the given username/email
     */
    public String generateToken(String subject) {
        Date now = new Date();
        Date expiry = new Date(now.getTime() + expirationMs);
        return Jwts.builder()
                .setSubject(subject)
                .setIssuedAt(now)
                .setExpiration(expiry)
                .signWith(signingKey, SignatureAlgorithm.HS256)
                .compact();
    }

    /**
     * Extract username from JWT token
     */
    public String getUsernameFromToken(String token) {
        try {
            Claims claims = Jwts.parserBuilder()
                    .setSigningKey(signingKey)
                    .build()
                    .parseClaimsJws(token)
                    .getBody();
            return claims.getSubject();
        } catch (JwtException | IllegalArgumentException ex) {
            return null; // invalid or expired
        }
    }

    /**
     * Validate JWT token (check signature and expiration)
     */
    public boolean validateToken(String token) {
        try {
            Jwts.parserBuilder()
                .setSigningKey(signingKey)
                .build()
                .parseClaimsJws(token);
            return true;
        } catch (JwtException | IllegalArgumentException ex) {
            return false;
        }
    }
}
