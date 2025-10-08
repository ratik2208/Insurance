package com.example.hims.service.impl;

import com.example.hims.dao.PolicyDao;
import com.example.hims.dao.UserDao;
import com.example.hims.dto.PolicyCreateDTO;
import com.example.hims.dto.PolicyDTO;
import com.example.hims.entity.Policy;
import com.example.hims.entity.User;
import com.example.hims.service.PolicyService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.persistence.EntityNotFoundException;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
public class PolicyServiceImpl implements PolicyService {

    private final PolicyDao policyDao;
    private final UserDao userDao;

    @Autowired
    public PolicyServiceImpl(PolicyDao policyDao, UserDao userDao) {
        this.policyDao = policyDao;
        this.userDao = userDao;
    }

    @Override
    @Transactional
    public PolicyDTO createPolicy(PolicyCreateDTO dto, Long createdByUserId) {
        User creator = userDao.findById(createdByUserId)
                .orElseThrow(() -> new EntityNotFoundException("Creator not found"));

        Policy p = new Policy();
        p.setPolicyNumber("POL-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase());
        p.setTitle(dto.getTitle());
        p.setDescription(dto.getDescription());
        p.setCoverageAmount(dto.getCoverageAmount());
        p.setPremium(dto.getPremium());
        p.setTermMonths(dto.getTermMonths());
        p.setEligibilityCriteria(dto.getEligibilityCriteria());
        p.setActive(true); // ✅ Set active by default
        p.setCreatedBy(creator);

        Policy saved = policyDao.save(p);
        
        // ✅ DEBUG: Log saved policy
        System.out.println("=== POLICY CREATED ===");
        System.out.println("ID: " + saved.getId());
        System.out.println("Title: " + saved.getTitle());
        System.out.println("Coverage: " + saved.getCoverageAmount());
        System.out.println("Premium: " + saved.getPremium());
        
        return toDto(saved);
    }

    @Override
    @Transactional(readOnly = true)
    public List<PolicyDTO> listPolicies() {
        List<Policy> policies = policyDao.findAll();
        
        // ✅ DEBUG: Log all policies from database
        System.out.println("=== LIST POLICIES (Service Layer) ===");
        System.out.println("Found " + policies.size() + " policies in database");
        
        for (Policy p : policies) {
            System.out.println("Policy ID: " + p.getId());
            System.out.println("  - Title: " + p.getTitle());
            System.out.println("  - Policy Number: " + p.getPolicyNumber());
            System.out.println("  - Coverage: " + p.getCoverageAmount());
            System.out.println("  - Premium: " + p.getPremium());
            System.out.println("  - Term: " + p.getTermMonths());
            System.out.println("  - Active: " + p.isActive());
            System.out.println("  - Description: " + p.getDescription());
            System.out.println("---");
        }
        
        return policies.stream()
                .map(this::toDto)
                .collect(Collectors.toList());
    }

    @Override
    @Transactional(readOnly = true)
    public PolicyDTO getPolicy(Long id) {
        Policy p = policyDao.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Policy not found"));
        return toDto(p);
    }

    @Override
    @Transactional(readOnly = true)
    public List<PolicyDTO> findByCreator(Long userId) {
        User creator = userDao.findById(userId)
                .orElseThrow(() -> new EntityNotFoundException("User not found"));
        return policyDao.findByCreator(creator).stream()
                .map(this::toDto)
                .collect(Collectors.toList());
    }

    @Override
    @Transactional(readOnly = true)
    public List<PolicyDTO> search(String searchTerm, Boolean active) {
        return policyDao.search(searchTerm, active).stream()
                .map(this::toDto)
                .collect(Collectors.toList());
    }

    private PolicyDTO toDto(Policy p) {
        PolicyDTO dto = new PolicyDTO();
        dto.setId(p.getId());
        dto.setPolicyNumber(p.getPolicyNumber());
        dto.setTitle(p.getTitle());
        dto.setDescription(p.getDescription());
        dto.setCoverageAmount(p.getCoverageAmount());
        dto.setPremium(p.getPremium());
        dto.setTermMonths(p.getTermMonths());
        dto.setActive(p.isActive());
        dto.setStartDate(p.getStartDate());
        dto.setEndDate(p.getEndDate());
        dto.setEligibilityCriteria(p.getEligibilityCriteria());
        
        // ✅ Safe handling of createdBy
        if (p.getCreatedBy() != null) {
            // Try getName() first, fallback to getEmail()
            String creatorName = p.getCreatedBy().getName();
            if (creatorName == null || creatorName.trim().isEmpty()) {
                creatorName = p.getCreatedBy().getEmail();
            }
            dto.setCreatedBy(creatorName);
        }
        
        // ✅ DEBUG: Log conversion
        System.out.println("Converting to DTO:");
        System.out.println("  Entity Title: " + p.getTitle());
        System.out.println("  DTO Title: " + dto.getTitle());
        System.out.println("  Entity Coverage: " + p.getCoverageAmount());
        System.out.println("  DTO Coverage: " + dto.getCoverageAmount());
        
        return dto;
    }
}
