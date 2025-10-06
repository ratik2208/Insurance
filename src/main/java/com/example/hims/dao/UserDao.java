package com.example.hims.dao;

import com.example.hims.entity.User;

import java.util.List;
import java.util.Optional;

public interface UserDao {
    User save(User user);
    Optional<User> findById(Long id);
    Optional<User> findByEmail(String email);
    boolean existsByEmail(String email);
    void update(User user);
    void delete(User user);
    List<User> findAll();
    long countAll();
    long countByRole(String roleName);
    long countRegisteredBetween(java.time.LocalDateTime from, java.time.LocalDateTime to);
}
