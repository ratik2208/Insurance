package com.example.hims.controller;

import com.example.hims.dto.ClaimCreateDTO;
import com.example.hims.dto.ClaimDTO;
import com.example.hims.service.ClaimService;
import com.example.hims.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.security.Principal;
import java.util.List;

@RestController
@RequestMapping("/claims")
public class ClaimController {

    private final ClaimService claimService;
    private final UserService userService;

    @Autowired
    public ClaimController(ClaimService claimService, UserService userService) {
        this.claimService = claimService;
        this.userService = userService;
    }

    @PostMapping
    public ResponseEntity<?> fileClaim(@RequestBody ClaimCreateDTO dto, Principal principal) {
        Long custId = userService.findIdByEmail(principal.getName());
        ClaimDTO created = claimService.fileClaim(custId, dto);
        return ResponseEntity.status(201).body(created);
    }

    // Agents/Admins can file a claim on behalf of a customer
    @PostMapping("/customer/{customerId}")
    public ResponseEntity<?> fileClaimForCustomer(@PathVariable Long customerId,
                                                  @RequestBody ClaimCreateDTO dto,
                                                  Principal principal) {
        // Optional: verify principal has AGENT/ADMIN role; for now rely on security config/UI gating
        ClaimDTO created = claimService.fileClaim(customerId, dto);
        return ResponseEntity.status(201).body(created);
    }

    @GetMapping("/my")
    public List<ClaimDTO> myClaims(Principal principal) {
        Long custId = userService.findIdByEmail(principal.getName());
        return claimService.findByCustomer(custId);
    }

    @GetMapping("/policy/{policyId}")
    public List<ClaimDTO> claimsForPolicy(@PathVariable Long policyId, Principal principal) {
        // additional authorization check could be added here (admins/agents)
        return claimService.findByPolicy(policyId);
    }

    @GetMapping("/{id}")
    public ResponseEntity<?> getClaim(@PathVariable Long id) {
        return ResponseEntity.ok(claimService.getById(id));
    }

    @GetMapping("/search")
    public List<ClaimDTO> searchClaims(@RequestParam(required=false) String q,
                                       @RequestParam(required=false) String status) {
        return claimService.search(q, status);
    }

    @PutMapping("/{claimId}/decision")
    public ResponseEntity<?> decideClaim(@PathVariable Long claimId,
                                        @RequestParam String decision,
                                        @RequestParam(required=false) String remarks,
                                        Principal principal) {
        Long agentId = userService.findIdByEmail(principal.getName());
        ClaimDTO updated = claimService.decideClaim(claimId, agentId, decision, remarks);
        return ResponseEntity.ok(updated);
    }
}
