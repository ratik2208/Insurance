package com.example.hims.service;

import com.example.hims.dto.ClaimCreateDTO;
import com.example.hims.dto.ClaimDTO;
import java.util.List;

public interface ClaimService {
    ClaimDTO fileClaim(Long customerId, ClaimCreateDTO dto);
    List<ClaimDTO> findByCustomer(Long customerId);
    List<ClaimDTO> findByPolicy(Long policyId);
    ClaimDTO decideClaim(Long claimId, Long agentId, String decision, String remarks);
    List<ClaimDTO> search(String searchTerm, String status);
}
