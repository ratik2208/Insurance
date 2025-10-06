package com.example.hims.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class InitialController {

	@RequestMapping("/")
	public String start() {
		return "index";
	}

	@RequestMapping("/login")
	public String login() {
		return "Login";
	}

	@RequestMapping("/register")
	public String register() {
		return "register";
	}

	@RequestMapping("/admin-dashboard")
	public String adminDashboard() {
		return "AdminDashboard";
	}

	@RequestMapping("/agent-dashboard")
	public String agentDashboard() {
		return "AgentDashboard";
	}

	@RequestMapping("/customer-dashboard")
	public String customerDashboard() {
		return "CustomerDashboard";
	}

	@RequestMapping("/policies-page")
	public String policyManagement() {
		return "PolicyManagement";
	}

	@RequestMapping("/claims")
	public String claimManagement() {
		return "ClaimManagement";
	}

	@RequestMapping("/file-claim")
	public String fileClaim() {
		return "FileClaim";
	}

	@RequestMapping("/users-page")
	public String usersPage() {
		return "Users";
	}
}


