package com.example.hims.dto;

import javax.validation.constraints.*;

public class PolicyCreateDTO {
    
    @NotBlank(message = "Policy title is required")
    @Size(min = 3, max = 200, message = "Title must be between 3 and 200 characters")
    private String title;
    
    @NotBlank(message = "Description is required")
    @Size(min = 10, max = 1000, message = "Description must be between 10 and 1000 characters")
    private String description;
    
    @NotNull(message = "Coverage amount is required")
    @Min(value = 1000, message = "Coverage amount must be at least 1000")
    @Max(value = 100000000, message = "Coverage amount cannot exceed 100,000,000")
    private Double coverageAmount;
    
    @NotNull(message = "Premium is required")
    @Min(value = 100, message = "Premium must be at least 100")
    @Max(value = 10000000, message = "Premium cannot exceed 10,000,000")
    private Double premium;
    
    @NotNull(message = "Term months is required")
    @Min(value = 1, message = "Term must be at least 1 month")
    @Max(value = 360, message = "Term cannot exceed 360 months")
    private Integer termMonths;
    
    @Size(max = 500, message = "Eligibility criteria cannot exceed 500 characters")
    private String eligibilityCriteria;

    // Constructors
    public PolicyCreateDTO() {
    }

    public PolicyCreateDTO(String title, String description, Double coverageAmount, 
                          Double premium, Integer termMonths, String eligibilityCriteria) {
        this.title = title;
        this.description = description;
        this.coverageAmount = coverageAmount;
        this.premium = premium;
        this.termMonths = termMonths;
        this.eligibilityCriteria = eligibilityCriteria;
    }

    // Getters and Setters
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

    public String getEligibilityCriteria() {
        return eligibilityCriteria;
    }

    public void setEligibilityCriteria(String eligibilityCriteria) {
        this.eligibilityCriteria = eligibilityCriteria;
    }

    @Override
    public String toString() {
        return "PolicyCreateDTO{" +
                "title='" + title + '\'' +
                ", description='" + description + '\'' +
                ", coverageAmount=" + coverageAmount +
                ", premium=" + premium +
                ", termMonths=" + termMonths +
                ", eligibilityCriteria='" + eligibilityCriteria + '\'' +
                '}';
    }
}
