package com.example.hims.service;

import com.example.hims.dto.PolicyCreateDTO;
import com.example.hims.dto.PolicyDTO;
import java.util.List;

public interface PolicyService {
    PolicyDTO createPolicy(PolicyCreateDTO dto, Long createdByUserId);
    List<PolicyDTO> listPolicies();
    PolicyDTO getPolicy(Long id);
    List<PolicyDTO> findByCreator(Long userId);
    List<PolicyDTO> search(String searchTerm, Boolean active);
}
