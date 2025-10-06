package com.example.hims.controller;

import com.example.hims.dto.PolicyCreateDTO;
import com.example.hims.dto.PolicyDTO;
import com.example.hims.service.PolicyService;
import com.example.hims.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.security.Principal;
import java.util.List;

@RestController
@RequestMapping("/policies")
public class PolicyController {

    private final PolicyService policyService;
    private final UserService userService;

    @Autowired
    public PolicyController(PolicyService policyService, UserService userService) {
        this.policyService = policyService;
        this.userService = userService;
    }

    @PostMapping
    public ResponseEntity<?> createPolicy(@RequestBody PolicyCreateDTO dto, Principal principal) {
        Long creatorId = userService.findIdByEmail(principal.getName());
        PolicyDTO created = policyService.createPolicy(dto, creatorId);
        return ResponseEntity.ok(created);
    }

    @GetMapping
    public List<PolicyDTO> listPolicies() {
        return policyService.listPolicies();
    }

    @GetMapping("/search")
    public List<PolicyDTO> searchPolicies(@RequestParam(required=false) String q,
                                          @RequestParam(required=false) Boolean active) {
        return policyService.search(q, active);
    }

    @GetMapping("/{id}")
    public ResponseEntity<?> getPolicy(@PathVariable Long id) {
        return ResponseEntity.ok(policyService.getPolicy(id));
    }

    @GetMapping("/my")
    public List<PolicyDTO> myPolicies(Principal principal) {
        Long id = userService.findIdByEmail(principal.getName());
        return policyService.findByCreator(id);
    }
}
