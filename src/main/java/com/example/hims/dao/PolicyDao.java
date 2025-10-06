package com.example.hims.dao;

import com.example.hims.entity.Policy;
import com.example.hims.entity.User;
import java.util.List;
import java.util.Optional;

public interface PolicyDao {
    Policy save(Policy policy);
    Optional<Policy> findById(Long id);
    Optional<Policy> findByPolicyNumber(String policyNumber);
    List<Policy> findAll();
    List<Policy> findByCreator(User creator);
    List<Policy> search(String searchTerm, Boolean active);
    void update(Policy policy);
    void delete(Policy policy);
}
