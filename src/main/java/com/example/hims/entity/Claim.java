package com.example.hims.entity;

import javax.persistence.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "claims")
public class Claim {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "claim_number", unique = true, nullable = false)
    private String claimNumber;

    @ManyToOne
    @JoinColumn(name = "policy_id", nullable = false)
    private Policy policy;

    @ManyToOne
    @JoinColumn(name = "customer_id", nullable = false)
    private User customer;

    // ✅ FIX: Map to snake_case column name
    @Column(name = "amount_claimed", nullable = false, precision = 12, scale = 2)
    private BigDecimal amountClaimed;

    // ✅ FIX: Map to snake_case column name
    @Column(name = "amount_approved", precision = 12, scale = 2)
    private BigDecimal amountApproved;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private ClaimStatus status = ClaimStatus.FILED;

    @Column(name = "claim_date", columnDefinition = "TIMESTAMP DEFAULT CURRENT_TIMESTAMP")
    private LocalDateTime claimDate = LocalDateTime.now();

    @Column(columnDefinition = "TEXT")
    private String remarks;

    @Column(name = "supporting_document_url")
    private String supportingDocumentUrl;

    @ManyToOne
    @JoinColumn(name = "decision_by")
    private User decisionBy;

    @Column(name = "decision_date")
    private LocalDateTime decisionDate;

    // Constructors
    public Claim() {}

    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getClaimNumber() { return claimNumber; }
    public void setClaimNumber(String claimNumber) { this.claimNumber = claimNumber; }

    public Policy getPolicy() { return policy; }
    public void setPolicy(Policy policy) { this.policy = policy; }

    public User getCustomer() { return customer; }
    public void setCustomer(User customer) { this.customer = customer; }

    public BigDecimal getAmountClaimed() { return amountClaimed; }
    public void setAmountClaimed(BigDecimal amountClaimed) { this.amountClaimed = amountClaimed; }

    public BigDecimal getAmountApproved() { return amountApproved; }
    public void setAmountApproved(BigDecimal amountApproved) { this.amountApproved = amountApproved; }

    public ClaimStatus getStatus() { return status; }
    public void setStatus(ClaimStatus status) { this.status = status; }

    public LocalDateTime getClaimDate() { return claimDate; }
    public void setClaimDate(LocalDateTime claimDate) { this.claimDate = claimDate; }

    public String getRemarks() { return remarks; }
    public void setRemarks(String remarks) { this.remarks = remarks; }

    public String getSupportingDocumentUrl() { return supportingDocumentUrl; }
    public void setSupportingDocumentUrl(String supportingDocumentUrl) { 
        this.supportingDocumentUrl = supportingDocumentUrl; 
    }

    public User getDecisionBy() { return decisionBy; }
    public void setDecisionBy(User decisionBy) { this.decisionBy = decisionBy; }

    public LocalDateTime getDecisionDate() { return decisionDate; }
    public void setDecisionDate(LocalDateTime decisionDate) { this.decisionDate = decisionDate; }
}
