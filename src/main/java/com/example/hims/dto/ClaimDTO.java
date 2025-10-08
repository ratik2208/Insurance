package com.example.hims.dto;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class ClaimDTO {
    private Long id;
    private String claimNumber;
    
    // Policy info
    private Long policyId;
    private String policyNumber;
    
    // Customer info
    private Long customerId;
    private String customerName;
    private String customerEmail;
    
    // Claim details
    private BigDecimal amountClaimed;
    private BigDecimal amountApproved;
    private String status;
    private LocalDateTime claimDate;
    private String remarks;
    private String supportingDocumentUrl;
    
    // Decision info
    private String decisionByName;
    private LocalDateTime decisionDate;

    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    
    public String getClaimNumber() { return claimNumber; }
    public void setClaimNumber(String claimNumber) { this.claimNumber = claimNumber; }
    
    public Long getPolicyId() { return policyId; }
    public void setPolicyId(Long policyId) { this.policyId = policyId; }
    
    public String getPolicyNumber() { return policyNumber; }
    public void setPolicyNumber(String policyNumber) { this.policyNumber = policyNumber; }
    
    public Long getCustomerId() { return customerId; }
    public void setCustomerId(Long customerId) { this.customerId = customerId; }
    
    public String getCustomerName() { return customerName; }
    public void setCustomerName(String customerName) { this.customerName = customerName; }
    
    public String getCustomerEmail() { return customerEmail; }
    public void setCustomerEmail(String customerEmail) { this.customerEmail = customerEmail; }
    
    public BigDecimal getAmountClaimed() { return amountClaimed; }
    public void setAmountClaimed(BigDecimal amountClaimed) { this.amountClaimed = amountClaimed; }
    
    public BigDecimal getAmountApproved() { return amountApproved; }
    public void setAmountApproved(BigDecimal amountApproved) { this.amountApproved = amountApproved; }
    
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    
    public LocalDateTime getClaimDate() { return claimDate; }
    public void setClaimDate(LocalDateTime claimDate) { this.claimDate = claimDate; }
    
    public String getRemarks() { return remarks; }
    public void setRemarks(String remarks) { this.remarks = remarks; }
    
    public String getSupportingDocumentUrl() { return supportingDocumentUrl; }
    public void setSupportingDocumentUrl(String supportingDocumentUrl) { 
        this.supportingDocumentUrl = supportingDocumentUrl; 
    }
    
    public String getDecisionByName() { return decisionByName; }
    public void setDecisionByName(String decisionByName) { this.decisionByName = decisionByName; }
    
    public LocalDateTime getDecisionDate() { return decisionDate; }
    public void setDecisionDate(LocalDateTime decisionDate) { this.decisionDate = decisionDate; }
}
