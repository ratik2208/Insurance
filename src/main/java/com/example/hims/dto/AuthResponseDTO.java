package com.example.hims.dto;

public class AuthResponseDTO {
    private String token;
    private Long userId;
    private String role;
    // constructor
    public AuthResponseDTO(String token, Long userId, String role) {
        this.token = token; this.userId = userId; this.role = role;
    }
    // getters
    public String getToken() { return token; }
    public Long getUserId() { return userId; }
    public String getRole() { return role; }
}
