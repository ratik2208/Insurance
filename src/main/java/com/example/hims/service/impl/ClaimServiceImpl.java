package com.example.hims.service.impl;

import com.example.hims.dao.ClaimDao;
import com.example.hims.dao.PolicyDao;
import com.example.hims.dao.UserDao;
import com.example.hims.dto.ClaimCreateDTO;
import com.example.hims.dto.ClaimDTO;
import com.example.hims.entity.Claim;
import com.example.hims.entity.ClaimStatus;
import com.example.hims.entity.Policy;
import com.example.hims.entity.User;
import com.example.hims.service.ClaimService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.persistence.EntityNotFoundException;
import java.math.BigDecimal;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
public class ClaimServiceImpl implements ClaimService {

    private final ClaimDao claimDao;
    private final PolicyDao policyDao;
    private final UserDao userDao;

    @Autowired
    public ClaimServiceImpl(ClaimDao claimDao, PolicyDao policyDao, UserDao userDao) {
        this.claimDao = claimDao;
        this.policyDao = policyDao;
        this.userDao = userDao;
    }

    @Override
    @Transactional
    public ClaimDTO fileClaim(Long customerId, ClaimCreateDTO dto) {
        User customer = userDao.findById(customerId)
                .orElseThrow(() -> new EntityNotFoundException("Customer not found"));
        Policy policy = policyDao.findById(dto.getPolicyId())
                .orElseThrow(() -> new EntityNotFoundException("Policy not found"));

        if (!policy.isActive()) {
            throw new IllegalStateException("Policy is not active");
        }

        // Convert Policy's Double to BigDecimal for comparison
        BigDecimal policyCoverage = policy.getCoverageAmount() != null 
                ? BigDecimal.valueOf(policy.getCoverageAmount()) 
                : BigDecimal.ZERO;
        
        if (dto.getAmountClaimed().compareTo(policyCoverage) > 0) {
            throw new IllegalArgumentException("Claim amount exceeds coverage");
        }

        // Removed duplicate claim check - allow multiple claims per policy
        // if (claimDao.existsByPolicyAndCustomer(policy, customer)) {
        //     throw new IllegalArgumentException("You have already filed a claim for this policy");
        // }

        Claim c = new Claim();
        c.setClaimNumber("CLM-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase());
        c.setPolicy(policy);
        c.setCustomer(customer);
        c.setAmountClaimed(dto.getAmountClaimed());
        c.setSupportingDocumentUrl(dto.getSupportingDocumentUrl());
        c.setRemarks(dto.getRemarks());
        c.setStatus(ClaimStatus.FILED);

        claimDao.save(c);
        return toDto(c);
    }

    //  NEW: Get all claims (for agents and admins)
    @Override
    @Transactional(readOnly = true)
    public List<ClaimDTO> listClaims() {
        return claimDao.findAll().stream()
                .map(this::toDto)
                .collect(Collectors.toList());
    }

    //  NEW: Get specific claim by ID
    @Override
    @Transactional(readOnly = true)
    public ClaimDTO getClaim(Long id) {
        Claim claim = claimDao.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Claim not found with id: " + id));
        return toDto(claim);
    }

    @Override
    @Transactional(readOnly = true)
    public List<ClaimDTO> findByCustomer(Long customerId) {
        User customer = userDao.findById(customerId)
                .orElseThrow(() -> new EntityNotFoundException("Customer not found"));
        return claimDao.findByCustomer(customer).stream()
                .map(this::toDto)
                .collect(Collectors.toList());
    }

    @Override
    @Transactional(readOnly = true)
    public List<ClaimDTO> findByPolicy(Long policyId) {
        Policy policy = policyDao.findById(policyId)
                .orElseThrow(() -> new EntityNotFoundException("Policy not found"));
        return claimDao.findByPolicy(policy).stream()
                .map(this::toDto)
                .collect(Collectors.toList());
    }

    @Override
    @Transactional
    public ClaimDTO decideClaim(Long claimId, Long agentId, String decision, String remarks) {
        Claim c = claimDao.findById(claimId)
                .orElseThrow(() -> new EntityNotFoundException("Claim not found"));
        User agent = userDao.findById(agentId)
                .orElseThrow(() -> new EntityNotFoundException("Agent not found"));

        // Optional: verify agent role
        if (agent.getRole() != null && 
            !(agent.getRole().name().equalsIgnoreCase("AGENT") || 
              agent.getRole().name().equalsIgnoreCase("ADMIN"))) {
            throw new IllegalArgumentException("Only agents or admins can decide claims");
        }

        if (!(c.getStatus() == ClaimStatus.FILED || c.getStatus() == ClaimStatus.UNDER_REVIEW)) {
            throw new IllegalStateException("Claim cannot be decided in current state: " + c.getStatus());
        }

        if ("APPROVE".equalsIgnoreCase(decision) || "APPROVED".equalsIgnoreCase(decision)) {
            c.setStatus(ClaimStatus.APPROVED);
            // ✅ Set approved amount to claimed amount
            c.setAmountApproved(c.getAmountClaimed());
        } else if ("REJECT".equalsIgnoreCase(decision) || "REJECTED".equalsIgnoreCase(decision)) {
            c.setStatus(ClaimStatus.REJECTED);
            // ✅ Set approved amount to zero for rejected claims
            c.setAmountApproved(BigDecimal.ZERO);
        } else {
            throw new IllegalArgumentException("Unknown decision: " + decision);
        }

        c.setRemarks(remarks);
        c.setDecisionBy(agent);
        c.setDecisionDate(java.time.LocalDateTime.now());
        claimDao.update(c);
        return toDto(c);
    }

    @Override
    @Transactional(readOnly = true)
    public List<ClaimDTO> search(String searchTerm, String status) {
        return claimDao.search(searchTerm, status).stream()
                .map(this::toDto)
                .collect(Collectors.toList());
    }

    //  UPDATED: Enhanced DTO mapping with all fields
    private ClaimDTO toDto(Claim c) {
        ClaimDTO dto = new ClaimDTO();
        dto.setId(c.getId());
        dto.setClaimNumber(c.getClaimNumber());
        
        // Policy information
        if (c.getPolicy() != null) {
            dto.setPolicyId(c.getPolicy().getId());
            dto.setPolicyNumber(c.getPolicy().getPolicyNumber());
        }
        
        // Customer information
        if (c.getCustomer() != null) {
            dto.setCustomerId(c.getCustomer().getId());
            dto.setCustomerName(c.getCustomer().getName());
            dto.setCustomerEmail(c.getCustomer().getEmail());
        }
        
        // Claim details
        dto.setAmountClaimed(c.getAmountClaimed());
        dto.setAmountApproved(c.getAmountApproved());
        dto.setStatus(c.getStatus() != null ? c.getStatus().name() : null);
        dto.setClaimDate(c.getClaimDate());
        dto.setRemarks(c.getRemarks());
        dto.setSupportingDocumentUrl(c.getSupportingDocumentUrl());
        
        // Decision information
        if (c.getDecisionBy() != null) {
            dto.setDecisionByName(c.getDecisionBy().getName());
        }
        dto.setDecisionDate(c.getDecisionDate());
        
        return dto;
    }
}
