package com.example.hims.service;

import com.example.hims.entity.User;

public interface UserService {
    User register(User user);               // signup (hash password before persist)
    User findByEmail(String email);
    Long findIdByEmail(String email);
    void update(User user);
    long countAll();
    long countByRole(String roleName);
    long countRegisteredToday();
    long countRegisteredLast7Days();
}
