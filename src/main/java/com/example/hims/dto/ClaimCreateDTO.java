package com.example.hims.dto;

import javax.validation.constraints.*;
import java.math.BigDecimal;

public class ClaimCreateDTO {
    
    @NotNull(message = "Policy ID is required")
    @Min(value = 1, message = "Invalid policy ID")
    private Long policyId;
    
    @NotNull(message = "Claim amount is required")
    @DecimalMin(value = "100.0", message = "Claim amount must be at least 100")
    @DecimalMax(value = "100000000.0", message = "Claim amount cannot exceed 100,000,000")
    private BigDecimal amountClaimed;
    
    @Size(max = 500, message = "Document URL cannot exceed 500 characters")
    private String supportingDocumentUrl;
    
    @Size(max = 1000, message = "Remarks cannot exceed 1000 characters")
    private String remarks;
    
    // getters/setters
    public Long getPolicyId() { return policyId; }
    public void setPolicyId(Long policyId) { this.policyId = policyId; }
    
    public BigDecimal getAmountClaimed() { return amountClaimed; }
    public void setAmountClaimed(BigDecimal amountClaimed) { this.amountClaimed = amountClaimed; }
    
    public String getSupportingDocumentUrl() { return supportingDocumentUrl; }
    public void setSupportingDocumentUrl(String supportingDocumentUrl) { 
        this.supportingDocumentUrl = supportingDocumentUrl; 
    }
    
    public String getRemarks() { return remarks; }
    public void setRemarks(String remarks) { this.remarks = remarks; }
}
