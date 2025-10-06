package com.example.hims.dao;

import com.example.hims.entity.Claim;
import com.example.hims.entity.Policy;
import com.example.hims.entity.User;
import java.util.List;
import java.util.Optional;

public interface ClaimDao {
    Claim save(Claim claim);
    Optional<Claim> findById(Long id);
    List<Claim> findByCustomer(User customer);
    List<Claim> findByPolicy(Policy policy);
    List<Claim> search(String searchTerm, String status);
    boolean existsByPolicyAndCustomer(Policy policy, User customer);
    void update(Claim claim);
    void delete(Claim claim);
}
