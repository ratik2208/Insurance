package com.example.hims.dto;

public class UserStatsDTO {
    private long totalUsers;
    private long adminCount;
    private long agentCount;
    private long customerCount;
    private long registeredToday;
    private long registeredLast7Days;

    public long getTotalUsers() { return totalUsers; }
    public void setTotalUsers(long totalUsers) { this.totalUsers = totalUsers; }
    public long getAdminCount() { return adminCount; }
    public void setAdminCount(long adminCount) { this.adminCount = adminCount; }
    public long getAgentCount() { return agentCount; }
    public void setAgentCount(long agentCount) { this.agentCount = agentCount; }
    public long getCustomerCount() { return customerCount; }
    public void setCustomerCount(long customerCount) { this.customerCount = customerCount; }
    public long getRegisteredToday() { return registeredToday; }
    public void setRegisteredToday(long registeredToday) { this.registeredToday = registeredToday; }
    public long getRegisteredLast7Days() { return registeredLast7Days; }
    public void setRegisteredLast7Days(long registeredLast7Days) { this.registeredLast7Days = registeredLast7Days; }
}


