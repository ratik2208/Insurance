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
      cursor: pointer;
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
    .btn-success {
      background: #28a745;
      color: white;
      padding: 8px 16px;
      font-size: 14px;
    }
    .btn-danger {
      background: #dc3545;
      color: white;
      padding: 8px 16px;
      font-size: 14px;
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
    .form-group {
      margin-bottom: 15px;
    }
    .form-group label {
      display: block;
      margin-bottom: 5px;
      font-weight: 500;
      color: #333;
    }
    .form-control {
      width: 100%;
      padding: 10px 12px;
      border: 1px solid #ddd;
      border-radius: 6px;
      font-size: 14px;
    }
    .form-control:focus {
      outline: none;
      border-color: #667eea;
    }
    .alert {
      padding: 15px;
      margin-bottom: 20px;
      border-radius: 8px;
      display: none;
    }
    .alert.success { background: #d4edda; border: 1px solid #c3e6cb; color: #155724; }
    .alert.error { background: #f8d7da; border: 1px solid #f5c6cb; color: #721c24; }
    .status-badge {
      padding: 4px 10px;
      border-radius: 5px;
      font-size: 12px;
      font-weight: 600;
      text-transform: uppercase;
    }
    .status-filed { background: #17a2b8; color: white; }
    .status-under-review { background: #ffc107; color: #333; }
    .status-approved { background: #28a745; color: white; }
    .status-rejected { background: #dc3545; color: white; }
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
        <a href="#" class="logout-btn" onclick="event.preventDefault(); logout();">Logout</a>
      </div>
    </div>
  </div>

  <div class="container">
    <div id="alertMessage" class="alert">
      <div id="alertText"></div>
    </div>

    <!-- Review Claim Modal -->
    <div id="reviewClaimModal" style="display:none; position:fixed; inset:0; background:rgba(0,0,0,.5); align-items:center; justify-content:center; z-index:1000;">
      <div style="background:#fff; padding:25px; border-radius:12px; width:95%; max-width:700px; max-height:85vh; overflow-y:auto; box-shadow:0 10px 30px rgba(0,0,0,.3);">
        <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:15px;">
          <h3 style="margin:0; color:#333;">Review Claim</h3>
          <button class="btn btn-secondary" onclick="closeReviewClaimModal()">Close</button>
        </div>
        <div id="reviewClaimContent"></div>
      </div>
    </div>

    <!-- All Claims Modal -->
    <div id="allClaimsModal" style="display:none; position:fixed; inset:0; background:rgba(0,0,0,.5); align-items:center; justify-content:center; z-index:1000;">
      <div style="background:#fff; padding:25px; border-radius:12px; width:95%; max-width:1200px; max-height:85vh; overflow-y:auto; box-shadow:0 10px 30px rgba(0,0,0,.3);">
        <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:15px;">
          <h3 style="margin:0; color:#333;">All Claims</h3>
          <button class="btn btn-secondary" onclick="closeAllClaimsModal()">Close</button>
        </div>
        <div style="margin-bottom:15px; display:flex; gap:10px;">
          <select id="claimStatusFilter" class="form-control" style="max-width:200px;">
            <option value="">All Status</option>
            <option value="FILED">Filed</option>
            <option value="UNDER_REVIEW">Under Review</option>
            <option value="APPROVED">Approved</option>
            <option value="REJECTED">Rejected</option>
          </select>
          <input id="claimSearch" class="form-control" placeholder="Search by claim/policy number..." style="flex:1;"/>
          <button class="btn btn-primary" onclick="filterClaims()">Filter</button>
        </div>
        <div id="allClaimsList"></div>
      </div>
    </div>

    <!-- Policies Modal -->
    <div id="policiesModal" style="display:none; position:fixed; inset:0; background:rgba(0,0,0,.5); align-items:center; justify-content:center; z-index:1000;">
      <div style="background:#fff; padding:25px; border-radius:12px; width:95%; max-width:900px; max-height:85vh; overflow-y:auto; box-shadow:0 10px 30px rgba(0,0,0,.3);">
        <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:15px;">
          <h3 style="margin:0; color:#333;">All Policies</h3>
          <button class="btn btn-secondary" onclick="closePoliciesModal()">Close</button>
        </div>
        <div id="policiesList"></div>
      </div>
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
          <a href="#" class="btn btn-primary" onclick="event.preventDefault(); loadPendingClaims();">Review Claims</a>
          <a href="#" class="btn btn-secondary" onclick="event.preventDefault(); showAllClaimsModal(false);">Claim History</a>
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
          <a href="#" class="btn btn-primary" onclick="event.preventDefault(); loadPolicies();">View Policies</a>
          <a href="#" class="btn btn-secondary" onclick="event.preventDefault(); searchPolicies();">Search Policies</a>
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
          <a href="#" class="btn btn-primary" onclick="event.preventDefault(); showCustomerSupport();">Customer Support</a>
          <a href="#" class="btn btn-secondary" onclick="event.preventDefault(); showHelpDesk();">Help Desk</a>
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
          <a href="#" class="btn btn-primary" onclick="event.preventDefault(); showPerformanceReport();">Performance Report</a>
          <a href="#" class="btn btn-secondary" onclick="event.preventDefault(); showMetrics();">View Metrics</a>
        </div>
      </div>
    </div>
  </div>

  <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
  <script>
    var API_BASE_URL = window.APP_CONTEXT || '${pageContext.request.contextPath}';
    var authToken = localStorage.getItem('token');
    var userRole = localStorage.getItem('userRole');
    var allClaimsData = [];

    // Check authentication
    if (!authToken || userRole !== 'AGENT') {
      window.location.href = API_BASE_URL + '/login';
    }

    function showAlert(message, type) {
      var alertDiv = document.getElementById('alertMessage');
      var alertText = document.getElementById('alertText');
      alertText.textContent = message;
      alertDiv.className = 'alert ' + type;
      alertDiv.style.display = 'block';
      setTimeout(function() { alertDiv.style.display = 'none'; }, 5000);
    }

    function logout() {
      localStorage.removeItem('token');
      localStorage.removeItem('userId');
      localStorage.removeItem('userRole');
      $.ajax({
        url: API_BASE_URL + '/auth/logout',
        type: 'POST',
        complete: function() {
          window.location.href = API_BASE_URL + '/login';
        }
      });
    }

    function loadDashboardData() {
      document.getElementById('userName').textContent = 'Insurance Agent';
      loadStats();
    }

    function loadStats() {
      if (!authToken) { window.location.href = API_BASE_URL + '/login'; return; }
      
      $.ajax({
        url: API_BASE_URL + '/claims',
        method: 'GET',
        headers: { 'Authorization': 'Bearer ' + authToken },
        success: function(claims){
          var list = claims || [];
          var pending = list.filter(function(c) { return c.status === 'FILED' || c.status === 'UNDER_REVIEW'; }).length;
          var approved = list.filter(function(c) { return c.status === 'APPROVED'; }).length;
          var rejected = list.filter(function(c) { return c.status === 'REJECTED'; }).length;
          var processed = approved + rejected;
          
          document.getElementById('pendingClaims').textContent = pending;
          document.getElementById('approvedClaims').textContent = approved;
          document.getElementById('rejectedClaims').textContent = rejected;
          document.getElementById('totalProcessed').textContent = processed;
        },
        error: function(){
          document.getElementById('pendingClaims').textContent = '0';
          document.getElementById('approvedClaims').textContent = '0';
          document.getElementById('rejectedClaims').textContent = '0';
          document.getElementById('totalProcessed').textContent = '0';
        }
      });
    }

    function loadPendingClaims() {
      showAllClaimsModal(true);
    }

    function showAllClaimsModal(pendingOnly) {
      if (!authToken) { window.location.href = API_BASE_URL + '/login'; return; }
      
      $('#allClaimsList').html('<div style="padding:20px; text-align:center; color:#999;">Loading claims...</div>');
      $('#allClaimsModal').css('display','flex');
      
      if (pendingOnly) {
        $('#claimStatusFilter').val('FILED');
      }
      
      $.ajax({
        url: API_BASE_URL + '/claims',
        method: 'GET',
        headers: { 'Authorization': 'Bearer ' + authToken },
        success: function(claims){
          console.log('All claims:', claims);
          allClaimsData = claims || [];
          
          if (pendingOnly) {
            allClaimsData = allClaimsData.filter(function(c) {
              return c.status === 'FILED' || c.status === 'UNDER_REVIEW';
            });
          }
          
          renderAllClaims(allClaimsData);
        },
        error: function(xhr){ 
          console.error('Failed to load claims:', xhr);
          $('#allClaimsList').html('<div style="padding:40px; text-align:center; color:#e74c3c;">Failed to load claims.</div>');
        }
      });
    }
    
    function closeAllClaimsModal() { 
      $('#allClaimsModal').hide(); 
    }
    
    function renderAllClaims(claims) {
      if (claims.length === 0) {
        $('#allClaimsList').html('<div style="padding:40px; text-align:center; color:#999;">No claims found.</div>');
        return;
      }
      
      var html = '<div style="overflow-x:auto;"><table style="width:100%; border-collapse:collapse;">';
      html += '<thead><tr style="background:#f8f9fa; border-bottom:2px solid #dee2e6;">';
      html += '<th style="padding:12px; text-align:left;">Claim #</th>';
      html += '<th style="padding:12px; text-align:left;">Customer</th>';
      html += '<th style="padding:12px; text-align:left;">Policy</th>';
      html += '<th style="padding:12px; text-align:right;">Amount</th>';
      html += '<th style="padding:12px; text-align:center;">Status</th>';
      html += '<th style="padding:12px; text-align:left;">Date</th>';
      html += '<th style="padding:12px; text-align:center;">Action</th>';
      html += '</tr></thead><tbody>';
      
      for (var i = 0; i < claims.length; i++) {
        var c = claims[i];
        var claimNumber = c.claimNumber || c.claim_number || ('CLM-' + c.id);
        var customerName = c.customerName || c.customer_name || 'N/A';
        var policyNum = c.policyNumber || c.policy_number || 'N/A';
        var amount = c.amountClaimed || c.amount_claimed || 0;
        var status = c.status || 'FILED';
        
        var claimDate = formatDate(c.claimDate || c.claim_date);
        
        var statusClass = 'status-filed';
        if (status === 'APPROVED') statusClass = 'status-approved';
        else if (status === 'REJECTED') statusClass = 'status-rejected';
        else if (status === 'UNDER_REVIEW') statusClass = 'status-under-review';
        
        html += '<tr style="border-bottom:1px solid #e9ecef;">';
        html += '<td style="padding:12px; font-weight:600;">' + claimNumber + '</td>';
        html += '<td style="padding:12px;">' + customerName + '</td>';
        html += '<td style="padding:12px;">' + policyNum + '</td>';
        html += '<td style="padding:12px; text-align:right;">₹' + Number(amount).toLocaleString('en-IN') + '</td>';
        html += '<td style="padding:12px; text-align:center;"><span class="status-badge ' + statusClass + '">' + status + '</span></td>';
        html += '<td style="padding:12px;">' + claimDate + '</td>';
        html += '<td style="padding:12px; text-align:center;">';
        html += '<button class="btn btn-primary" style="padding:6px 12px; font-size:13px;" onclick="reviewClaim(' + c.id + ')">Review</button>';
        html += '</td>';
        html += '</tr>';
      }
      
      html += '</tbody></table></div>';
      $('#allClaimsList').html(html);
    }
    
    function filterClaims() {
      var statusFilter = $('#claimStatusFilter').val();
      var searchText = $('#claimSearch').val().toLowerCase();
      
      var filtered = allClaimsData.filter(function(c) {
        var matchesStatus = !statusFilter || c.status === statusFilter;
        var matchesSearch = !searchText || 
          (c.claimNumber && c.claimNumber.toLowerCase().includes(searchText)) ||
          (c.policyNumber && c.policyNumber.toLowerCase().includes(searchText)) ||
          (c.customerName && c.customerName.toLowerCase().includes(searchText));
        return matchesStatus && matchesSearch;
      });
      
      renderAllClaims(filtered);
    }
    
    function reviewClaim(claimId) {
      if (!authToken) { window.location.href = API_BASE_URL + '/login'; return; }
      
      $('#reviewClaimContent').html('<div style="padding:20px; text-align:center; color:#999;">Loading claim details...</div>');
      $('#reviewClaimModal').css('display','flex');
      
      $.ajax({
        url: API_BASE_URL + '/claims/' + claimId,
        method: 'GET',
        headers: { 'Authorization': 'Bearer ' + authToken },
        success: function(claim){
          console.log('Claim details:', claim);
          renderClaimReview(claim);
        },
        error: function(xhr){ 
          console.error('Failed to load claim:', xhr);
          $('#reviewClaimContent').html('<div style="padding:20px; text-align:center; color:#e74c3c;">Failed to load claim details.</div>');
        }
      });
    }
    
    function renderClaimReview(claim) {
      var claimNumber = claim.claimNumber || claim.claim_number || ('CLM-' + claim.id);
      var customerName = claim.customerName || claim.customer_name || 'N/A';
      var customerEmail = claim.customerEmail || claim.customer_email || 'N/A';
      var policyNum = claim.policyNumber || claim.policy_number || 'N/A';
      var amount = claim.amountClaimed || claim.amount_claimed || 0;
      var status = claim.status || 'FILED';
      var claimDate = formatDate(claim.claimDate || claim.claim_date);
      var remarks = claim.remarks || 'No remarks';
      var docUrl = claim.supportingDocumentUrl || claim.supporting_document_url || '';
      
      var html = '<div style="padding:20px;">';
      html += '<div style="background:#f8f9fa; padding:20px; border-radius:8px; margin-bottom:20px;">';
      html += '<h4 style="margin:0 0 15px 0; color:#333;">Claim Information</h4>';
      html += '<div style="display:grid; grid-template-columns:repeat(2, 1fr); gap:15px;">';
      html += '<div><strong>Claim Number:</strong><br>' + claimNumber + '</div>';
      html += '<div><strong>Status:</strong><br>' + status + '</div>';
      html += '<div><strong>Customer:</strong><br>' + customerName + '</div>';
      html += '<div><strong>Email:</strong><br>' + customerEmail + '</div>';
      html += '<div><strong>Policy:</strong><br>' + policyNum + '</div>';
      html += '<div><strong>Amount Claimed:</strong><br>₹' + Number(amount).toLocaleString('en-IN') + '</div>';
      html += '<div><strong>Claim Date:</strong><br>' + claimDate + '</div>';
      html += '</div>';
      html += '</div>';
      
      if (remarks && remarks !== 'No remarks' && remarks !== 'na') {
        html += '<div style="margin-bottom:20px;">';
        html += '<strong style="display:block; margin-bottom:8px;">Remarks:</strong>';
        html += '<div style="background:#fff; padding:12px; border:1px solid #e9ecef; border-radius:6px;">' + remarks + '</div>';
        html += '</div>';
      }
      
      if (docUrl) {
        html += '<div style="margin-bottom:20px;">';
        html += '<strong style="display:block; margin-bottom:8px;">Supporting Document:</strong>';
        html += '<a href="' + docUrl + '" target="_blank" class="btn btn-secondary" style="padding:8px 16px;">View Document</a>';
        html += '</div>';
      }
      
      if (status === 'FILED' || status === 'UNDER_REVIEW') {
        html += '<div style="border-top:2px solid #dee2e6; padding-top:20px; margin-top:20px;">';
        html += '<h4 style="margin:0 0 15px 0; color:#333;">Review Decision</h4>';
        html += '<div class="form-group">';
        html += '<label>Decision Remarks</label>';
        html += '<textarea id="decisionRemarks" class="form-control" rows="3" placeholder="Enter remarks for your decision..."></textarea>';
        html += '</div>';
        html += '<div style="display:flex; gap:10px; margin-top:15px;">';
        html += '<button class="btn btn-success" onclick="decideClaim(' + claim.id + ', \'APPROVE\')">✓ Approve Claim</button>';
        html += '<button class="btn btn-danger" onclick="decideClaim(' + claim.id + ', \'REJECT\')">✗ Reject Claim</button>';
        html += '</div>';
        html += '</div>';
      } else {
        html += '<div style="background:#fff3cd; border:1px solid #ffc107; padding:15px; border-radius:6px; margin-top:20px;">';
        html += '<strong>⚠️ This claim has already been ' + status.toLowerCase() + '.</strong>';
        html += '</div>';
      }
      
      html += '</div>';
      $('#reviewClaimContent').html(html);
    }
    
    function decideClaim(claimId, decision) {
      var remarks = $('#decisionRemarks').val();
      
      if (!confirm('Are you sure you want to ' + decision + ' this claim?')) {
        return;
      }
      
      $.ajax({
        url: API_BASE_URL + '/claims/' + claimId + '/decide',
        method: 'PUT',
        contentType: 'application/json',
        headers: { 'Authorization': 'Bearer ' + authToken },
        data: JSON.stringify({
          decision: decision,
          remarks: remarks
        }),
        success: function(){
          closeReviewClaimModal();
          showAlert('Claim ' + decision.toLowerCase() + 'd successfully!', 'success');
          loadStats();
          setTimeout(function() {
            loadPendingClaims();
          }, 1000);
        },
        error: function(xhr){
          var msg = xhr.responseText || 'Failed to ' + decision.toLowerCase() + ' claim';
          showAlert(msg, 'error');
        }
      });
    }
    
    function closeReviewClaimModal() {
      $('#reviewClaimModal').hide();
    }
    
    function formatDate(rawDate) {
      if (!rawDate) return 'N/A';
      
      if (Array.isArray(rawDate)) {
        var year = rawDate[0];
        var month = String(rawDate[1]).padStart(2, '0');
        var day = String(rawDate[2]).padStart(2, '0');
        var hour = rawDate[3] ? String(rawDate[3]).padStart(2, '0') : '00';
        var minute = rawDate[4] ? String(rawDate[4]).padStart(2, '0') : '00';
        return day + '-' + month + '-' + year + ' ' + hour + ':' + minute;
      } else if (typeof rawDate === 'string') {
        return rawDate.split('T')[0];
      }
      return String(rawDate);
    }
    
    function loadPolicies() {
      if (!authToken) { window.location.href = API_BASE_URL + '/login'; return; }
      
      $('#policiesList').html('<div style="padding:20px; text-align:center; color:#999;">Loading policies...</div>');
      $('#policiesModal').css('display','flex');
      
      $.ajax({
        url: API_BASE_URL + '/policies',
        method: 'GET',
        headers: { 'Authorization': 'Bearer ' + authToken },
        success: function(policies){
          renderPolicies(policies || []);
        },
        error: function(){
          $('#policiesList').html('<div style="padding:40px; text-align:center; color:#e74c3c;">Failed to load policies.</div>');
        }
      });
    }
    
    function renderPolicies(policies) {
      if (policies.length === 0) {
        $('#policiesList').html('<div style="padding:40px; text-align:center; color:#999;">No policies found.</div>');
        return;
      }
      
      var html = '';
      for (var i = 0; i < policies.length; i++) {
        var p = policies[i];
        var policyNumber = p.policyNumber || p.policy_number || 'N/A';
        var title = p.title || 'Untitled Policy';
        var description = p.description || 'No description';
        var coverage = p.coverageAmount || p.coverage_amount || 0;
        var premium = p.premium || 0;
        var term = p.termMonths || p.term_months || 0;
        
        html += '<div style="border:1px solid #e9ecef; border-radius:10px; padding:20px; margin-bottom:15px; background:#f8f9fa;">';
        html += '<div style="font-weight:600; font-size:17px; color:#333; margin-bottom:8px;">' + policyNumber + ' - ' + title + '</div>';
        html += '<div style="color:#666; font-size:14px; margin-bottom:12px; line-height:1.5;">' + description + '</div>';
        html += '<div style="color:#555; font-size:13px; display:flex; flex-wrap:wrap; gap:15px;">';
        html += '<span><strong>Coverage:</strong> ₹' + Number(coverage).toLocaleString('en-IN') + '</span>';
        html += '<span><strong>Premium:</strong> ₹' + Number(premium).toLocaleString('en-IN') + '/year</span>';
        html += '<span><strong>Term:</strong> ' + term + ' months</span>';
        html += '</div>';
        html += '</div>';
      }
      
      $('#policiesList').html(html);
    }
    
    function closePoliciesModal() {
      $('#policiesModal').hide();
    }
    
    function searchPolicies() {
      showAlert('Policy search feature coming soon', 'success');
    }
    
    function showCustomerSupport() {
      showAlert('Contact: support@hims.com | Phone: 1800-123-4567', 'success');
    }
    
    function showHelpDesk() {
      showAlert('Help desk feature coming soon', 'success');
    }
    
    function showPerformanceReport() {
      showAlert('Performance report feature coming soon', 'success');
    }
    
    function showMetrics() {
      showAlert('Metrics feature coming soon', 'success');
    }

    $(document).ready(function() {
      loadDashboardData();
    });
  </script>
</body>
</html>
