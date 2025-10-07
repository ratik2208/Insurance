<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>HIMS - Agent Dashboard</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/app.css" />
  <style>
    * { margin:0; padding:0; box-sizing:border-box; }
    body {
      font-family: 'Arial', sans-serif;
      background: #f5f7fa;
      min-height: 100vh;
    }
    .header {
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      color: white;
      padding: 20px 0;
      box-shadow: 0 2px 10px rgba(0,0,0,.1);
    }
    .header-content {
      max-width: 1200px;
      margin: 0 auto;
      padding: 0 20px;
      display: flex;
      justify-content: space-between;
      align-items: center;
    }
    .header h1 { font-size: 28px; font-weight: 600; }
    .user-info {
      display: flex;
      align-items: center;
      gap: 15px;
    }
    .logout-btn {
      background: rgba(255,255,255,.2);
      color: white;
      border: 1px solid rgba(255,255,255,.3);
      padding: 8px 16px;
      border-radius: 6px;
      text-decoration: none;
      transition: all .3s ease;
    }
    .logout-btn:hover {
      background: rgba(255,255,255,.3);
      transform: translateY(-1px);
    }
    .container {
      max-width: 1200px;
      margin: 0 auto;
      padding: 30px 20px;
    }
    .dashboard-grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
      gap: 30px;
      margin-bottom: 40px;
    }
    .dashboard-card {
      background: white;
      border-radius: 12px;
      padding: 30px;
      box-shadow: 0 4px 15px rgba(0,0,0,.1);
      transition: transform 0.3s ease, box-shadow 0.3s ease;
    }
    .dashboard-card:hover {
      transform: translateY(-5px);
      box-shadow: 0 8px 25px rgba(0,0,0,.15);
    }
    .card-header {
      display: flex;
      align-items: center;
      margin-bottom: 20px;
    }
    .card-icon {
      font-size: 32px;
      margin-right: 15px;
    }
    .card-title {
      font-size: 20px;
      font-weight: 600;
      color: #333;
    }
    .card-content {
      color: #666;
      line-height: 1.6;
      margin-bottom: 20px;
    }
    .card-actions {
      display: flex;
      gap: 10px;
      flex-wrap: wrap;
    }
    .btn {
      padding: 10px 20px;
      border-radius: 8px;
      text-decoration: none;
      font-weight: 500;
      transition: all 0.3s ease;
      border: none;
      cursor: pointer;
      display: inline-flex;
      align-items: center;
      gap: 8px;
    }
    .btn-primary {
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      color: white;
    }
    .btn-primary:hover {
      transform: translateY(-2px);
      box-shadow: 0 5px 15px rgba(102,126,234,.3);
    }
    .btn-secondary {
      background: #f8f9fa;
      color: #667eea;
      border: 1px solid #e9ecef;
    }
    .btn-secondary:hover {
      background: #667eea;
      color: white;
    }
    .stats-grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
      gap: 20px;
      margin-bottom: 40px;
    }
    .stat-card {
      background: white;
      border-radius: 12px;
      padding: 25px;
      text-align: center;
      box-shadow: 0 4px 15px rgba(0,0,0,.1);
    }
    .stat-number {
      font-size: 36px;
      font-weight: 700;
      color: #667eea;
      margin-bottom: 10px;
    }
    .stat-label {
      color: #666;
      font-size: 14px;
      text-transform: uppercase;
      letter-spacing: 1px;
    }
    .alert {
      padding: 15px;
      margin-bottom: 20px;
      border-radius: 8px;
      display: none;
    }
    .alert.success { background: #d4edda; border: 1px solid #c3e6cb; color: #155724; }
    .alert.error { background: #f8d7da; border: 1px solid #f5c6cb; color: #721c24; }
    @media (max-width: 768px) {
      .header-content { flex-direction: column; gap: 15px; text-align: center; }
      .dashboard-grid { grid-template-columns: 1fr; }
      .stats-grid { grid-template-columns: repeat(2, 1fr); }
    }
  </style>
</head>
<body>
  <div class="header app-header">
    <div class="header-content">
      <h1>Agent Dashboard</h1>
      <div class="user-info">
        <span id="userName">Loading...</span>
        <a href="/hims/login" class="logout-btn" onclick="logout()">Logout</a>
      </div>
    </div>
  </div>

  <div class="container">
    <div id="alertMessage" class="alert">
      <div id="alertText"></div>
    </div>

    <div class="stats-grid">
      <div class="stat-card">
        <div class="stat-number" id="pendingClaims">-</div>
        <div class="stat-label">Pending Claims</div>
      </div>
      <div class="stat-card">
        <div class="stat-number" id="approvedClaims">-</div>
        <div class="stat-label">Approved Claims</div>
      </div>
      <div class="stat-card">
        <div class="stat-number" id="rejectedClaims">-</div>
        <div class="stat-label">Rejected Claims</div>
      </div>
      <div class="stat-card">
        <div class="stat-number" id="totalProcessed">-</div>
        <div class="stat-label">Total Processed</div>
      </div>
    </div>

    <div class="dashboard-grid">
      <div class="dashboard-card">
        <div class="card-header">
          <div class="card-icon">📋</div>
          <div class="card-title">Claim Review</div>
        </div>
        <div class="card-content">
          Review and process pending claims. Approve or reject claims based on policy terms and documentation.
        </div>
        <div class="card-actions">
          <a href="${pageContext.request.contextPath}/claims" class="btn btn-primary">Review Claims</a>
          <a href="${pageContext.request.contextPath}/claims" class="btn btn-secondary">Claim History</a>
        </div>
      </div>

      <div class="dashboard-card">
        <div class="card-header">
          <div class="card-icon">📊</div>
          <div class="card-title">Policy Information</div>
        </div>
        <div class="card-content">
          Access policy details, coverage information, and eligibility criteria to make informed decisions.
        </div>
        <div class="card-actions">
          <a href="${pageContext.request.contextPath}/policies-page" class="btn btn-primary">View Policies</a>
          <a href="${pageContext.request.contextPath}/policies-page" class="btn btn-secondary">Search Policies</a>
        </div>
      </div>

      <div class="dashboard-card">
        <div class="card-header">
          <div class="card-icon">👥</div>
          <div class="card-title">Customer Support</div>
        </div>
        <div class="card-content">
          Assist customers with their insurance needs, policy questions, and claim-related inquiries.
        </div>
        <div class="card-actions">
          <a href="#" class="btn btn-primary" onclick="showCustomerSupport()">Customer Support</a>
          <a href="#" class="btn btn-secondary" onclick="showHelpDesk()">Help Desk</a>
        </div>
      </div>

      <div class="dashboard-card">
        <div class="card-header">
          <div class="card-icon">📈</div>
          <div class="card-title">Performance Reports</div>
        </div>
        <div class="card-content">
          View your performance metrics, processing times, and claim approval rates.
        </div>
        <div class="card-actions">
          <a href="#" class="btn btn-primary" onclick="showPerformanceReport()">Performance Report</a>
          <a href="#" class="btn btn-secondary" onclick="showMetrics()">View Metrics</a>
        </div>
      </div>
    </div>
  </div>

  <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
  <script>
    const API_BASE_URL = window.APP_CONTEXT || '${pageContext.request.contextPath}';
    let authToken = localStorage.getItem('token');
    let userRole = localStorage.getItem('userRole');

    // Check authentication
    if (!authToken || userRole !== 'AGENT') {
      window.location.href = API_BASE_URL + '/login';
    }

    function showAlert(message, type) {
      const alertDiv = document.getElementById('alertMessage');
      const alertText = document.getElementById('alertText');
      alertText.textContent = message;
      alertDiv.className = 'alert ' + type;
      alertDiv.style.display = 'block';
      setTimeout(() => { alertDiv.style.display = 'none'; }, 5000);
    }

    function logout() {
      localStorage.removeItem('token');
      localStorage.removeItem('userId');
      localStorage.removeItem('userRole');
      window.location.href = '/hims/login';
    }

    function loadDashboardData() {
      // Load user info
      document.getElementById('userName').textContent = 'Insurance Agent';

      // Load statistics
      loadStats();
    }

    function loadStats() {
      // This would typically make API calls to get real statistics
      // For now, we'll show placeholder data
      document.getElementById('pendingClaims').textContent = '8';
      document.getElementById('approvedClaims').textContent = '25';
      document.getElementById('rejectedClaims').textContent = '3';
      document.getElementById('totalProcessed').textContent = '36';
    }

    function loadPendingClaims() {
      showAlert('Loading pending claims...', 'success');
    }

    function showClaimHistory() {
      showAlert('Claim history feature will be implemented', 'success');
    }

    function loadPolicies() {
      showAlert('Loading policies...', 'success');
    }

    function searchPolicies() {
      showAlert('Policy search feature will be implemented', 'success');
    }

    function showCustomerSupport() {
      showAlert('Customer support feature will be implemented', 'success');
    }

    function showHelpDesk() {
      showAlert('Help desk feature will be implemented', 'success');
    }

    function showPerformanceReport() {
      showAlert('Performance report feature will be implemented', 'success');
    }

    function showMetrics() {
      showAlert('Metrics feature will be implemented', 'success');
    }

    $(document).ready(function() {
      loadDashboardData();
    });
  </script>
</body>
</html>
