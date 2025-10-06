package com.example.hims.service.impl;

import com.example.hims.dao.UserDao;
import com.example.hims.entity.User;
import com.example.hims.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import javax.persistence.EntityNotFoundException;

@Service
public class UserServiceImpl implements UserService {

    private final UserDao userDao;
    private final PasswordEncoder passwordEncoder;

    @Autowired
    public UserServiceImpl(UserDao userDao, PasswordEncoder passwordEncoder) {
        this.userDao = userDao;
        this.passwordEncoder = passwordEncoder;
    }

    @Override
    @Transactional
    public User register(User user) {
        if (userDao.existsByEmail(user.getEmail())) {
            throw new IllegalArgumentException("Email already registered");
        }
        // Hash password before saving
        user.setPassword(passwordEncoder.encode(user.getPassword()));
        return userDao.save(user);
    }

    @Override
    @Transactional(readOnly = true)
    public User findByEmail(String email) {
        return userDao.findByEmail(email).orElseThrow(() -> new EntityNotFoundException("User not found"));
    }

    @Override
    @Transactional(readOnly = true)
    public Long findIdByEmail(String email) {
        return userDao.findByEmail(email).map(User::getId).orElseThrow(() -> new EntityNotFoundException("User not found"));
    }

    @Override
    @Transactional
    public void update(User user) {
        userDao.update(user);
    }

    @Override
    @Transactional(readOnly = true)
    public long countAll() {
        return userDao.findAll().size();
    }

    @Override
    @Transactional(readOnly = true)
    public long countByRole(String roleName) {
        return userDao.findAll().stream()
                .filter(u -> u.getRole() != null && u.getRole().name().equalsIgnoreCase(roleName))
                .count();
    }

    @Override
    @Transactional(readOnly = true)
    public long countRegisteredToday() {
        java.time.LocalDateTime now = java.time.LocalDateTime.now();
        java.time.LocalDateTime start = now.toLocalDate().atStartOfDay();
        return userDao.countRegisteredBetween(start, now);
    }

    @Override
    @Transactional(readOnly = true)
    public long countRegisteredLast7Days() {
        java.time.LocalDateTime now = java.time.LocalDateTime.now();
        java.time.LocalDateTime from = now.minusDays(7);
        return userDao.countRegisteredBetween(from, now);
    }
}
