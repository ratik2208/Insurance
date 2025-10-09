package com.example.hims.controller;

import com.example.hims.dto.PolicyCreateDTO;
import com.example.hims.dto.PolicyDTO;
import com.example.hims.service.PolicyService;
import com.example.hims.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.security.Principal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
    public ResponseEntity<?> createPolicy(@Valid @RequestBody PolicyCreateDTO dto, BindingResult result, Principal principal) {
        // Check for validation errors
        if (result.hasErrors()) {
            Map<String, String> errors = new HashMap<>();
            for (FieldError error : result.getFieldErrors()) {
                errors.put(error.getField(), error.getDefaultMessage());
            }
            return ResponseEntity.badRequest().body(errors);
        }
        
        Long creatorId = userService.findIdByEmail(principal.getName());
        PolicyDTO created = policyService.createPolicy(dto, creatorId);
        return ResponseEntity.ok(created);
    }

    @GetMapping
    public List<PolicyDTO> listPolicies() {
        List<PolicyDTO> policies = policyService.listPolicies();
        
        //  DEBUG: Log what we're returning
        System.out.println("=== POLICY CONTROLLER DEBUG ===");
        System.out.println("Total policies: " + policies.size());
        for (PolicyDTO p : policies) {
            System.out.println("Policy ID: " + p.getId());
            System.out.println("  - Title: " + p.getTitle());
            System.out.println("  - Policy Number: " + p.getPolicyNumber());
            System.out.println("  - Coverage: " + p.getCoverageAmount());
            System.out.println("  - Premium: " + p.getPremium());
            System.out.println("  - Term: " + p.getTermMonths());
            System.out.println("  - Description: " + p.getDescription());
            System.out.println("---");
        }
        
        return policies;
    }

    @GetMapping("/search")
    public List<PolicyDTO> searchPolicies(@RequestParam(required=false) String q,
                                          @RequestParam(required=false) Boolean active) {
        List<PolicyDTO> policies = policyService.search(q, active);
        
        //  DEBUG: Log search results
        System.out.println("=== SEARCH RESULTS ===");
        System.out.println("Query: " + q + ", Active: " + active);
        System.out.println("Found: " + policies.size() + " policies");
        
        return policies;
    }

    @GetMapping("/{id}")
    public ResponseEntity<?> getPolicy(@PathVariable Long id) {
        PolicyDTO policy = policyService.getPolicy(id);
        
        //  DEBUG: Log single policy
        System.out.println("=== GET POLICY " + id + " ===");
        System.out.println(policy.toString());
        
        return ResponseEntity.ok(policy);
    }

    @GetMapping("/my")
    public List<PolicyDTO> myPolicies(Principal principal) {
        Long id = userService.findIdByEmail(principal.getName());
        List<PolicyDTO> policies = policyService.findByCreator(id);
        
        //  DEBUG: Log user's policies
        System.out.println("=== MY POLICIES for user " + id + " ===");
        System.out.println("Found: " + policies.size() + " policies");
        
        return policies;
    }
}
