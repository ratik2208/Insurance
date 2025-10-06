package com.example.hims.dto;

import java.math.BigDecimal;

public class ClaimCreateDTO {
    private Long policyId;
    private BigDecimal amountClaimed;
    private String supportingDocumentUrl;
    private String remarks;
    // getters/setters
    public Long getPolicyId() { return policyId; }
    public void setPolicyId(Long policyId) { this.policyId = policyId; }
    public BigDecimal getAmountClaimed() { return amountClaimed; }
    public void setAmountClaimed(BigDecimal amountClaimed) { this.amountClaimed = amountClaimed; }
    public String getSupportingDocumentUrl() { return supportingDocumentUrl; }
    public void setSupportingDocumentUrl(String supportingDocumentUrl) { this.supportingDocumentUrl = supportingDocumentUrl; }
    public String getRemarks() { return remarks; }
    public void setRemarks(String remarks) { this.remarks = remarks; }
}
