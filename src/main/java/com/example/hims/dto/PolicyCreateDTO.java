package com.example.hims.dto;

public class PolicyCreateDTO {
    private String title;
    private String description;
    private Double coverageAmount;  // Changed to Double to match Policy entity
    private Double premium;          // Changed to Double to match Policy entity
    private Integer termMonths;
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
