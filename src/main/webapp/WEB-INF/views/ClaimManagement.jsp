<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>HIMS - Claim Management</title>
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
    .back-btn {
      background: rgba(255,255,255,.2);
      color: white;
      border: 1px solid rgba(255,255,255,.3);
      padding: 8px 16px;
      border-radius: 6px;
      text-decoration: none;
      transition: all .3s ease;
    }
    .back-btn:hover {
      background: rgba(255,255,255,.3);
      transform: translateY(-1px);
    }
    .container {
      max-width: 1200px;
      margin: 0 auto;
      padding: 30px 20px;
    }
    .page-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 30px;
    }
    .page-title {
      font-size: 24px;
      font-weight: 600;
      color: #333;
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
    .btn-success {
      background: #28a745;
      color: white;
    }
    .btn-danger {
      background: #dc3545;
      color: white;
    }
    .search-section {
      background: white;
      border-radius: 12px;
      padding: 25px;
      margin-bottom: 30px;
      box-shadow: 0 4px 15px rgba(0,0,0,.1);
    }
    .search-form {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
      gap: 20px;
      align-items: end;
    }
    .form-group {
      display: flex;
      flex-direction: column;
    }
    .form-group label {
      margin-bottom: 8px;
      color: #333;
      font-weight: 500;
      font-size: 14px;
    }
    .form-control {
      padding: 12px 15px;
      border: 2px solid #e1e1e1;
      border-radius: 8px;
      font-size: 14px;
      transition: all .3s ease;
      background-color: #f9f9f9;
    }
    .form-control:focus {
      outline: none;
      border-color: #667eea;
      background: #fff;
      box-shadow: 0 0 0 3px rgba(102,126,234,.1);
    }
    .claims-table {
      background: white;
      border-radius: 12px;
      overflow: hidden;
      box-shadow: 0 4px 15px rgba(0,0,0,.1);
    }
    .table {
      width: 100%;
      border-collapse: collapse;
    }
    .table th {
      background: #f8f9fa;
      padding: 15px;
      text-align: left;
      font-weight: 600;
      color: #333;
      border-bottom: 2px solid #e9ecef;
    }
    .table td {
      padding: 15px;
      border-bottom: 1px solid #e9ecef;
      color: #666;
    }
    .table tr:hover {
      background: #f8f9fa;
    }
    .status-badge {
      padding: 4px 12px;
      border-radius: 20px;
      font-size: 12px;
      font-weight: 500;
      text-transform: uppercase;
    }
    .status-filed {
      background: #fff3cd;
      color: #856404;
    }
    .status-under-review {
      background: #cce5ff;
      color: #004085;
    }
    .status-approved {
      background: #d4edda;
      color: #155724;
    }
    .status-rejected {
      background: #f8d7da;
      color: #721c24;
    }
    .status-paid {
      background: #d1ecf1;
      color: #0c5460;
    }
    .action-buttons {
      display: flex;
      gap: 8px;
      flex-wrap: wrap;
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
      .page-header { flex-direction: column; gap: 15px; align-items: flex-start; }
      .search-form { grid-template-columns: 1fr; }
      .table { font-size: 14px; }
      .action-buttons { flex-direction: column; }
    }
  </style>
</head>
<body>
  <div class="header app-header">
    <div class="header-content">
      <h1>Claim Management</h1>
      <a href="${pageContext.request.contextPath}/agent-dashboard" class="back-btn">← Back to Dashboard</a>
    </div>
  </div>

  <div class="container">
    <div id="alertMessage" class="alert">
      <div id="alertText"></div>
    </div>

    <div class="page-header">
      <h2 class="page-title">Insurance Claims</h2>
      <button class="btn btn-primary" onclick="showFileClaimModal()">+ File New Claim</button>
    </div>

    <div class="search-section">
      <form id="searchForm" class="search-form">
        <div class="form-group">
          <label for="searchTerm">Search</label>
          <input type="text" id="searchTerm" name="searchTerm" class="form-control" placeholder="Search by claim number, customer..." />
        </div>
        <div class="form-group">
          <label for="statusFilter">Status</label>
          <select id="statusFilter" name="statusFilter" class="form-control">
            <option value="">All Status</option>
            <option value="FILED">Filed</option>
            <option value="UNDER_REVIEW">Under Review</option>
            <option value="APPROVED">Approved</option>
            <option value="REJECTED">Rejected</option>
            <option value="PAID">Paid</option>
          </select>
        </div>
        <div class="form-group">
          <button type="submit" class="btn btn-primary">Search</button>
        </div>
      </form>
    </div>

    <div class="claims-table">
      <table class="table">
        <thead>
          <tr>
            <th>Claim Number</th>
            <th>Customer</th>
            <th>Policy</th>
            <th>Amount</th>
            <th>Status</th>
            <th>Date Filed</th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody>
          <tr>
            <td>CLM-2025-0001</td>
            <td>John Doe</td>
            <td>POL-2025-0001</td>
            <td>$2,500</td>
            <td><span class="status-badge status-under-review">Under Review</span></td>
            <td>2025-01-15</td>
            <td>
              <div class="action-buttons">
                <button class="btn btn-primary" onclick="viewClaim('CLM-2025-0001')">View</button>
                <button class="btn btn-success" onclick="approveClaim('CLM-2025-0001')">Approve</button>
                <button class="btn btn-danger" onclick="rejectClaim('CLM-2025-0001')">Reject</button>
              </div>
            </td>
          </tr>
          <tr>
            <td>CLM-2025-0002</td>
            <td>Jane Smith</td>
            <td>POL-2025-0002</td>
            <td>$1,800</td>
            <td><span class="status-badge status-approved">Approved</span></td>
            <td>2025-01-10</td>
            <td>
              <div class="action-buttons">
                <button class="btn btn-primary" onclick="viewClaim('CLM-2025-0002')">View</button>
                <button class="btn btn-secondary" onclick="processPayment('CLM-2025-0002')">Process Payment</button>
              </div>
            </td>
          </tr>
          <tr>
            <td>CLM-2025-0003</td>
            <td>Mike Johnson</td>
            <td>POL-2025-0001</td>
            <td>$3,200</td>
            <td><span class="status-badge status-filed">Filed</span></td>
            <td>2025-01-20</td>
            <td>
              <div class="action-buttons">
                <button class="btn btn-primary" onclick="viewClaim('CLM-2025-0003')">View</button>
                <button class="btn btn-success" onclick="approveClaim('CLM-2025-0003')">Approve</button>
                <button class="btn btn-danger" onclick="rejectClaim('CLM-2025-0003')">Reject</button>
              </div>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>

  <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
  <script>
    const API_BASE_URL = window.APP_CONTEXT || '${pageContext.request.contextPath}';
    let authToken = localStorage.getItem('token');

    function showAlert(message, type) {
      const alertDiv = document.getElementById('alertMessage');
      const alertText = document.getElementById('alertText');
      alertText.textContent = message;
      alertDiv.className = 'alert ' + type;
      alertDiv.style.display = 'block';
      setTimeout(() => { alertDiv.style.display = 'none'; }, 5000);
    }

    function showFileClaimModal() {
      showAlert('File claim feature will be implemented', 'success');
    }

    function viewClaim(id) {
      showAlert('Viewing claim #' + id, 'success');
    }

    function approveClaim(id) {
      if (!authToken) { window.location.href = API_BASE_URL + '/login'; return; }
      if (confirm('Approve claim #' + id + '?')) {
        $.ajax({
          url: API_BASE_URL + '/claims/' + id + '/decision?decision=APPROVE',
          method: 'PUT',
          headers: { 'Authorization': 'Bearer ' + authToken },
          success: function(){ showAlert('Claim approved', 'success'); loadClaims(); },
          error: function(){ showAlert('Failed to approve claim', 'error'); }
        });
      }
    }

    function rejectClaim(id) {
      if (!authToken) { window.location.href = API_BASE_URL + '/login'; return; }
      if (confirm('Reject claim #' + id + '?')) {
        $.ajax({
          url: API_BASE_URL + '/claims/' + id + '/decision?decision=REJECT',
          method: 'PUT',
          headers: { 'Authorization': 'Bearer ' + authToken },
          success: function(){ showAlert('Claim rejected', 'success'); loadClaims(); },
          error: function(){ showAlert('Failed to reject claim', 'error'); }
        });
      }
    }

    function processPayment(claimNumber) {
      showAlert(`Processing payment for claim ${claimNumber}`, 'success');
    }

    function renderClaims(claims) {
      const tbody = document.querySelector('.claims-table tbody');
      tbody.innerHTML = '';
      if (!claims || claims.length === 0) {
        const tr = document.createElement('tr');
        const td = document.createElement('td');
        td.colSpan = 7;
        td.textContent = 'No claims found.';
        tr.appendChild(td);
        tbody.appendChild(tr);
        return;
      }
      claims.forEach(c => {
        const tr = document.createElement('tr');
        tr.innerHTML = `
          <td>${c.claimNumber}</td>
          <td>${c.customerId || ''}</td>
          <td>${c.policyId || ''}</td>
          <td>${c.amountClaimed || ''}</td>
          <td><span class="status-badge status-${(c.status || '').toLowerCase().replace('_','-')}">${c.status}</span></td>
          <td>${c.claimDate || ''}</td>
          <td>
            <div class="action-buttons">
              <button class="btn btn-primary" onclick="viewClaim(${c.id})">View</button>
              <button class="btn btn-success" onclick="approveClaim(${c.id})">Approve</button>
              <button class="btn btn-danger" onclick="rejectClaim(${c.id})">Reject</button>
            </div>
          </td>
        `;
        tbody.appendChild(tr);
      });
    }

    function searchClaims() {
      const searchTerm = document.getElementById('searchTerm').value;
      const statusFilter = document.getElementById('statusFilter').value;
      const params = [];
      if (searchTerm) params.push('q=' + encodeURIComponent(searchTerm));
      if (statusFilter) params.push('status=' + encodeURIComponent(statusFilter));
      const query = params.length ? ('?' + params.join('&')) : '';
      $.ajax({
        url: API_BASE_URL + '/claims/search' + query,
        method: 'GET',
        headers: { 'Authorization': 'Bearer ' + authToken },
        success: function(data){ renderClaims(data); },
        error: function(){ showAlert('Search failed', 'error'); }
      });
    }

    function loadClaims() {
      if (!authToken) { window.location.href = API_BASE_URL + '/login'; return; }
      $.ajax({
        url: API_BASE_URL + '/claims/search',
        method: 'GET',
        headers: { 'Authorization': 'Bearer ' + authToken },
        success: function(data){ renderClaims(data); },
        error: function(){ showAlert('Failed to load claims', 'error'); }
      });
    }

    // Event handlers
    $('#searchForm').on('submit', function(e) {
      e.preventDefault();
      searchClaims();
    });

    $(document).ready(function() {
      loadClaims();
    });
  </script>
</body>
</html>
