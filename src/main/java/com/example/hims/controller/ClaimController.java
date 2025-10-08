package com.example.hims.controller;

import com.example.hims.dto.ClaimCreateDTO;
import com.example.hims.dto.ClaimDTO;
import com.example.hims.entity.ClaimStatus;
import com.example.hims.service.ClaimService;
import com.example.hims.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.security.Principal;
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
    public ResponseEntity<?> fileClaim(@RequestBody ClaimCreateDTO dto, Principal principal) {
        Long custId = userService.findIdByEmail(principal.getName());
        ClaimDTO created = claimService.fileClaim(custId, dto);
        return ResponseEntity.status(201).body(created);
    }

    // ✅ NEW: Get ALL claims (Admin and Agent can see all claims)
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

    // ✅ NEW: Get specific claim by ID (All authenticated users)
    @GetMapping("/{id}")
    @PreAuthorize("hasAnyRole('ADMIN', 'AGENT', 'CUSTOMER')")
    public ResponseEntity<ClaimDTO> getClaim(@PathVariable Long id) {
        ClaimDTO claim = claimService.getClaim(id);
        return ResponseEntity.ok(claim);
    }

    // ✅ Get claims for a specific policy
    @GetMapping("/policy/{policyId}")
    @PreAuthorize("hasAnyRole('ADMIN', 'AGENT')")
    public List<ClaimDTO> claimsForPolicy(@PathVariable Long policyId) {
        return claimService.findByPolicy(policyId);
    }

    // ✅ Search claims
    @GetMapping("/search")
    @PreAuthorize("hasAnyRole('ADMIN', 'AGENT')")
    public List<ClaimDTO> searchClaims(@RequestParam(required=false) String q,
                                       @RequestParam(required=false) String status) {
        return claimService.search(q, status);
    }

    // ✅ UPDATED: Decide on a claim (Admin and Agent only) - Matches frontend call
    @PutMapping("/{claimId}/decide")
    @PreAuthorize("hasAnyRole('ADMIN', 'AGENT')")
    public ResponseEntity<?> decideClaim(@PathVariable Long claimId,
                                        @RequestBody Map<String, String> request,
                                        Principal principal) {
        Long agentId = userService.findIdByEmail(principal.getName());
        String decision = request.get("decision");
        String remarks = request.get("remarks");
        ClaimDTO updated = claimService.decideClaim(claimId, agentId, decision, remarks);
        return ResponseEntity.ok(updated);
    }

    // ✅ LEGACY ENDPOINT: Keep for backward compatibility (using query params)
    @PutMapping("/{claimId}/decision")
    @PreAuthorize("hasAnyRole('ADMIN', 'AGENT')")
    public ResponseEntity<?> decideClaimLegacy(@PathVariable Long claimId,
                                        @RequestParam String decision,
                                        @RequestParam(required=false) String remarks,
                                        Principal principal) {
        Long agentId = userService.findIdByEmail(principal.getName());
        ClaimDTO updated = claimService.decideClaim(claimId, agentId, decision, remarks);
        return ResponseEntity.ok(updated);
    }
}
