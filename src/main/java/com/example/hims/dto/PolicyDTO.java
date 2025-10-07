//package com.example.hims.dto;
//
//import java.math.BigDecimal;
//import java.time.LocalDate;
//
//public class PolicyDTO {
//    private Long id;
//    private String policyNumber;
//    private String title;
//    private String description;
//    private BigDecimal coverageAmount;
//    private BigDecimal premium;
//    private Integer termMonths;
//    private boolean active;
//    private LocalDate startDate;
//    private LocalDate endDate;
//    // getters/setters
//    public Long getId() { return id; }
//    public void setId(Long id) { this.id = id; }
//    public String getPolicyNumber() { return policyNumber; }
//    public void setPolicyNumber(String policyNumber) { this.policyNumber = policyNumber; }
//    public String getTitle() { return title; }
//    public void setTitle(String title) { this.title = title; }
//    public String getDescription() { return description; }
//    public void setDescription(String description) { this.description = description; }
//    public BigDecimal getCoverageAmount() { return coverageAmount; }
//    public void setCoverageAmount(BigDecimal coverageAmount) { this.coverageAmount = coverageAmount; }
//    public BigDecimal getPremium() { return premium; }
//    public void setPremium(BigDecimal premium) { this.premium = premium; }
//    public Integer getTermMonths() { return termMonths; }
//    public void setTermMonths(Integer termMonths) { this.termMonths = termMonths; }
//    public boolean isActive() { return active; }
//    public void setActive(boolean active) { this.active = active; }
//    public LocalDate getStartDate() { return startDate; }
//    public void setStartDate(LocalDate startDate) { this.startDate = startDate; }
//    public LocalDate getEndDate() { return endDate; }
//    public void setEndDate(LocalDate endDate) { this.endDate = endDate; }
//}


package com.example.hims.dto;

import java.time.LocalDate;

public class PolicyDTO {
    private Long id;
    private String policyNumber;
    private String title;
    private String description;
    private Double coverageAmount;
    private Double premium;
    private Integer termMonths;
    private Boolean active;
    private LocalDate startDate;
    private LocalDate endDate;
    private String eligibilityCriteria;
    private String createdBy;

    // Constructors
    public PolicyDTO() {
    }

    public PolicyDTO(Long id, String policyNumber, String title, String description, 
                     Double coverageAmount, Double premium, Integer termMonths, 
                     Boolean active, LocalDate startDate, LocalDate endDate, 
                     String eligibilityCriteria, String createdBy) {
        this.id = id;
        this.policyNumber = policyNumber;
        this.title = title;
        this.description = description;
        this.coverageAmount = coverageAmount;
        this.premium = premium;
        this.termMonths = termMonths;
        this.active = active;
        this.startDate = startDate;
        this.endDate = endDate;
        this.eligibilityCriteria = eligibilityCriteria;
        this.createdBy = createdBy;
    }

    // Getters and Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getPolicyNumber() {
        return policyNumber;
    }

    public void setPolicyNumber(String policyNumber) {
        this.policyNumber = policyNumber;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Double getCoverageAmount() {
        return coverageAmount;
    }

    public void setCoverageAmount(Double coverageAmount) {
        this.coverageAmount = coverageAmount;
    }

    public Double getPremium() {
        return premium;
    }

    public void setPremium(Double premium) {
        this.premium = premium;
    }

    public Integer getTermMonths() {
        return termMonths;
    }

    public void setTermMonths(Integer termMonths) {
        this.termMonths = termMonths;
    }

    public Boolean getActive() {
        return active;
    }

    public void setActive(Boolean active) {
        this.active = active;
    }

    public LocalDate getStartDate() {
        return startDate;
    }

    public void setStartDate(LocalDate startDate) {
        this.startDate = startDate;
    }

    public LocalDate getEndDate() {
        return endDate;
    }

    public void setEndDate(LocalDate endDate) {
        this.endDate = endDate;
    }

    public String getEligibilityCriteria() {
        return eligibilityCriteria;
    }

    public void setEligibilityCriteria(String eligibilityCriteria) {
        this.eligibilityCriteria = eligibilityCriteria;
    }

    public String getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(String createdBy) {
        this.createdBy = createdBy;
    }

    @Override
    public String toString() {
        return "PolicyDTO{" +
                "id=" + id +
                ", policyNumber='" + policyNumber + '\'' +
                ", title='" + title + '\'' +
                ", description='" + description + '\'' +
                ", coverageAmount=" + coverageAmount +
                ", premium=" + premium +
                ", termMonths=" + termMonths +
                ", active=" + active +
                ", startDate=" + startDate +
                ", endDate=" + endDate +
                ", eligibilityCriteria='" + eligibilityCriteria + '\'' +
                ", createdBy='" + createdBy + '\'' +
                '}';
    }
}
