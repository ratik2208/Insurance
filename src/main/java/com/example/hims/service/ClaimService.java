package com.example.hims.service;

import com.example.hims.dto.ClaimCreateDTO;
import com.example.hims.dto.ClaimDTO;
import java.util.List;

public interface ClaimService {
    ClaimDTO fileClaim(Long customerId, ClaimCreateDTO dto);
    
    // ✅ NEW methods
    List<ClaimDTO> listClaims();      // Get all claims
    ClaimDTO getClaim(Long id);        // Get specific claim
    
    List<ClaimDTO> findByCustomer(Long customerId);
    List<ClaimDTO> findByPolicy(Long policyId);
    List<ClaimDTO> search(String query, String status);
    ClaimDTO decideClaim(Long claimId, Long agentId, String decision, String remarks);
}
