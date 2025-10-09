package com.example.hims.controller;

import com.example.hims.dto.ClaimCreateDTO;
import com.example.hims.dto.ClaimDTO;
import com.example.hims.exception.ClaimNotFoundException;
import com.example.hims.service.ClaimService;
import com.example.hims.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.security.Principal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/claims")
@CrossOrigin(origins = "*")
public class ClaimController {

    private final ClaimService claimService;
    private final UserService userService;

    @Autowired
    public ClaimController(ClaimService claimService, UserService userService) {
        this.claimService = claimService;
        this.userService = userService;
    }

    // ✅ File a new claim (Customer only)
    @PostMapping
    @PreAuthorize("hasRole('CUSTOMER')")
    public ResponseEntity<?> fileClaim(@Valid @RequestBody ClaimCreateDTO dto, BindingResult result, Principal principal) {
        // Check for validation errors
        if (result.hasErrors()) {
            Map<String, String> errors = new HashMap<>();
            for (FieldError error : result.getFieldErrors()) {
                errors.put(error.getField(), error.getDefaultMessage());
            }
            return ResponseEntity.badRequest().body(errors);
        }
        
        Long custId = userService.findIdByEmail(principal.getName());
        ClaimDTO created = claimService.fileClaim(custId, dto);
        return ResponseEntity.status(201).body(created);
    }

    // ✅ Get ALL claims (Admin and Agent can see all claims)
    @GetMapping
    @PreAuthorize("hasAnyRole('ADMIN', 'AGENT')")
    public ResponseEntity<List<ClaimDTO>> getAllClaims() {
        List<ClaimDTO> claims = claimService.listClaims();
        return ResponseEntity.ok(claims);
    }

    // ✅ Get customer's own claims (Customer only)
    @GetMapping("/my")
    @PreAuthorize("hasRole('CUSTOMER')")
    public List<ClaimDTO> myClaims(Principal principal) {
        Long custId = userService.findIdByEmail(principal.getName());
        return claimService.findByCustomer(custId);
    }

    // ✅ Get specific claim by ID (All authenticated users)
    @GetMapping("/{id}")
    @PreAuthorize("hasAnyRole('ADMIN', 'AGENT', 'CUSTOMER')")
    public ResponseEntity<ClaimDTO> getClaim(@PathVariable Long id) {
        ClaimDTO claim = claimService.getClaim(id);
        
        if (claim == null) {
            throw new ClaimNotFoundException("Claim not found with ID: " + id);
        }
        
        return ResponseEntity.ok(claim);
    }

    // ✅ Get claims for a specific policy
    @GetMapping("/policy/{policyId}")
    @PreAuthorize("hasAnyRole('ADMIN', 'AGENT')")
    public List<ClaimDTO> claimsForPolicy(@PathVariable Long policyId) {
        List<ClaimDTO> claims = claimService.findByPolicy(policyId);
        return claims;
    }

    // ✅ Search claims
    @GetMapping("/search")
    @PreAuthorize("hasAnyRole('ADMIN', 'AGENT')")
    public List<ClaimDTO> searchClaims(@RequestParam(required=false) String q,
                                       @RequestParam(required=false) String status) {
        return claimService.search(q, status);
    }

    // ✅ Decide on a claim (Admin and Agent only)
    @PutMapping("/{claimId}/decide")
    @PreAuthorize("hasAnyRole('ADMIN', 'AGENT')")
    public ResponseEntity<?> decideClaim(@PathVariable Long claimId,
                                        @RequestBody Map<String, String> request,
                                        Principal principal) {
        Long agentId = userService.findIdByEmail(principal.getName());
        String decision = request.get("decision");
        String remarks = request.get("remarks");
        
        ClaimDTO updated = claimService.decideClaim(claimId, agentId, decision, remarks);
        
        if (updated == null) {
            throw new ClaimNotFoundException("Claim not found with ID: " + claimId);
        }
        
        return ResponseEntity.ok(updated);
    }

    // ✅ LEGACY ENDPOINT: Keep for backward compatibility
    @PutMapping("/{claimId}/decision")
    @PreAuthorize("hasAnyRole('ADMIN', 'AGENT')")
    public ResponseEntity<?> decideClaimLegacy(@PathVariable Long claimId,
                                        @RequestParam String decision,
                                        @RequestParam(required=false) String remarks,
                                        Principal principal) {
        Long agentId = userService.findIdByEmail(principal.getName());
        ClaimDTO updated = claimService.decideClaim(claimId, agentId, decision, remarks);
        
        if (updated == null) {
            throw new ClaimNotFoundException("Claim not found with ID: " + claimId);
        }
        
        return ResponseEntity.ok(updated);
    }
}
