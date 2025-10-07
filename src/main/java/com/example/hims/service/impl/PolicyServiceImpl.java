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
        p.setCreatedBy(creator);

        policyDao.save(p);
        return toDto(p);
    }

    @Override
    @Transactional(readOnly = true)
    public List<PolicyDTO> listPolicies() {
        return policyDao.findAll().stream()
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
        dto.setCreatedBy(p.getCreatedBy() != null ? p.getCreatedBy().getName() : null);
        return dto;
    }
}
