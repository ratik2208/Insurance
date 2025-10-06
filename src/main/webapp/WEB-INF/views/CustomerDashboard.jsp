<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>HIMS - Customer Dashboard</title>
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
      <h1>Customer Dashboard</h1>
      <div class="user-info">
        <span id="userName">Loading...</span>
        <a href="${pageContext.request.contextPath}/login" class="logout-btn" onclick="logout()">Logout</a>
      </div>
    </div>
  </div>

  <div class="container">
    <div id="alertMessage" class="alert">
      <div id="alertText"></div>
    </div>

    <!-- File Claim Modal -->
    <div id="fileClaimModal" style="display:none; position:fixed; inset:0; background:rgba(0,0,0,.4); align-items:center; justify-content:center;">
      <div style="background:#fff; padding:25px; border-radius:12px; width:95%; max-width:520px; box-shadow:0 10px 30px rgba(0,0,0,.2);">
        <h3 style="margin-bottom:15px;">File New Claim</h3>
        <form id="fileClaimForm">
          <div class="form-group" style="margin-bottom:15px;">
            <label for="policySelect">Policy</label>
            <select id="policySelect" class="form-control" required></select>
          </div>
          <div class="form-group" style="margin-bottom:15px;">
            <label for="claimAmount">Amount Claimed</label>
            <input type="number" step="0.01" id="claimAmount" class="form-control" required />
          </div>
          <div class="form-group" style="margin-bottom:15px;">
            <label for="docUrl">Supporting Document URL (optional)</label>
            <input type="url" id="docUrl" class="form-control" />
          </div>
          <div class="form-group" style="margin-bottom:15px;">
            <label for="remarks">Remarks (optional)</label>
            <textarea id="remarks" class="form-control" rows="3"></textarea>
          </div>
          <div style="display:flex; gap:10px; justify-content:flex-end;">
            <button type="button" class="btn btn-secondary" onclick="closeFileClaimModal()">Cancel</button>
            <button type="submit" class="btn btn-primary">Submit Claim</button>
          </div>
        </form>
      </div>
    </div>

    <!-- Browse Policies Modal -->
    <div id="browsePoliciesModal" style="display:none; position:fixed; inset:0; background:rgba(0,0,0,.4); align-items:center; justify-content:center;">
      <div style="background:#fff; padding:25px; border-radius:12px; width:95%; max-width:800px; box-shadow:0 10px 30px rgba(0,0,0,.2);">
        <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:12px;">
          <h3 style="margin:0;">Available Policies</h3>
          <button class="btn btn-secondary" onclick="closeBrowsePoliciesModal()">Close</button>
        </div>
        <div style="margin-bottom:12px; display:flex; gap:8px;">
          <input id="browseSearch" class="form-control" placeholder="Search policies..."/>
          <button class="btn btn-primary" onclick="searchAvailablePolicies()">Search</button>
        </div>
        <div id="browsePoliciesList"></div>
      </div>
    </div>

    <div class="stats-grid">
      <div class="stat-card">
        <div class="stat-number" id="myPolicies">-</div>
        <div class="stat-label">My Policies</div>
      </div>
      <div class="stat-card">
        <div class="stat-number" id="myClaims">-</div>
        <div class="stat-label">My Claims</div>
      </div>
      <div class="stat-card">
        <div class="stat-number" id="pendingClaims">-</div>
        <div class="stat-label">Pending Claims</div>
      </div>
      <div class="stat-card">
        <div class="stat-number" id="approvedClaims">-</div>
        <div class="stat-label">Approved Claims</div>
      </div>
    </div>

    <div class="dashboard-grid">
      <div class="dashboard-card">
        <div class="card-header">
          <div class="card-icon">📋</div>
          <div class="card-title">File New Claim</div>
        </div>
        <div class="card-content">
          Submit a new insurance claim with supporting documentation. Track your claim status in real-time.
        </div>
        <div class="card-actions">
          <a href="#" class="btn btn-primary" onclick="showFileClaimModal()">File Claim</a>
          <a href="#" class="btn btn-secondary" onclick="showClaimGuidelines()">Claim Guidelines</a>
        </div>
      </div>

      <div class="dashboard-card">
        <div class="card-header">
          <div class="card-icon">📊</div>
          <div class="card-title">My Claims</div>
        </div>
        <div class="card-content">
          View all your submitted claims, check their status, and download claim documents.
        </div>
        <div class="card-actions">
          <a href="#" class="btn btn-primary" onclick="loadMyClaims()">View My Claims</a>
          <a href="#" class="btn btn-secondary" onclick="showClaimHistory()">Claim History</a>
        </div>
      </div>

      <div class="dashboard-card">
        <div class="card-header">
          <div class="card-icon">📄</div>
          <div class="card-title">My Policies</div>
        </div>
        <div class="card-content">
          Access your insurance policies, view coverage details, and download policy documents.
        </div>
        <div class="card-actions">
          <a href="#" class="btn btn-primary" onclick="loadMyPolicies()">View Policies</a>
          <a href="#" class="btn btn-secondary" onclick="downloadPolicyDocs()">Download Documents</a>
        </div>
      </div>

      <div class="dashboard-card">
        <div class="card-header">
          <div class="card-icon">💬</div>
          <div class="card-title">Support & Help</div>
        </div>
        <div class="card-content">
          Get assistance with your insurance needs, policy questions, and claim-related inquiries.
        </div>
        <div class="card-actions">
          <a href="#" class="btn btn-primary" onclick="showSupport()">Contact Support</a>
          <a href="#" class="btn btn-secondary" onclick="showFAQ()">FAQ</a>
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
    if (!authToken || userRole !== 'CUSTOMER') {
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
      window.location.href = API_BASE_URL + '/login';
    }

    function loadDashboardData() {
      // Load user info
      document.getElementById('userName').textContent = 'Customer';

      // Load statistics
      loadStats();
    }

    function loadStats() {
      if (!authToken) { window.location.href = API_BASE_URL + '/login'; return; }
      // Get policies
      $.ajax({
        url: API_BASE_URL + '/policies/my',
        method: 'GET',
        headers: { 'Authorization': 'Bearer ' + authToken },
        success: function(policies){
          document.getElementById('myPolicies').textContent = (policies || []).length;
        }
      });
      // Get claims and compute stats
      $.ajax({
        url: API_BASE_URL + '/claims/my',
        method: 'GET',
        headers: { 'Authorization': 'Bearer ' + authToken },
        success: function(claims){
          const list = claims || [];
          document.getElementById('myClaims').textContent = list.length;
          const pending = list.filter(c => c.status === 'FILED' || c.status === 'UNDER_REVIEW').length;
          const approved = list.filter(c => c.status === 'APPROVED').length;
          document.getElementById('pendingClaims').textContent = pending;
          document.getElementById('approvedClaims').textContent = approved;
        }
      });
    }

    function showFileClaimModal() {
      if (!authToken) { window.location.href = API_BASE_URL + '/login'; return; }
      // Load user's policies for selection
      $('#policySelect').empty().append('<option value="">Select a policy...</option>');
      $.ajax({
        url: API_BASE_URL + '/policies/my',
        method: 'GET',
        headers: { 'Authorization': 'Bearer ' + authToken },
        success: function(data){
          const list = data || [];
          if (list.length === 0) {
            showAlert('No policies found on your account. Please purchase a policy first.', 'error');
            return;
          }
          const opts = list.map(p => `<option value="${p.id}">${p.policyNumber} - ${p.title || ''}</option>`).join('');
          $('#policySelect').append(opts);
          $('#fileClaimModal').css('display','flex');
        },
        error: function(){ showAlert('Failed to load policies', 'error'); }
      });
    }
    function closeFileClaimModal(){ $('#fileClaimModal').hide(); }
    $('#fileClaimForm').on('submit', function(e){
      e.preventDefault();
      const payload = {
        policyId: Number($('#policySelect').val()),
        amountClaimed: parseFloat($('#claimAmount').val()),
        supportingDocumentUrl: $('#docUrl').val() || null,
        remarks: $('#remarks').val() || null
      };
      $.ajax({
        url: API_BASE_URL + '/claims',
        method: 'POST',
        contentType: 'application/json',
        headers: { 'Authorization': 'Bearer ' + authToken },
        data: JSON.stringify(payload),
        success: function(){
          closeFileClaimModal();
          showAlert('Claim filed successfully', 'success');
          loadStats();
          loadMyClaims();
        },
        error: function(xhr){
          showAlert(xhr.responseText || 'Failed to file claim', 'error');
        }
      });
    });

    function showClaimGuidelines() {
      showAlert('Claim guidelines feature will be implemented', 'success');
    }

    function loadMyClaims() {
      if (!authToken) { window.location.href = API_BASE_URL + '/login'; return; }
      $.ajax({
        url: API_BASE_URL + '/claims/my',
        method: 'GET',
        headers: { 'Authorization': 'Bearer ' + authToken },
        success: function(claims){
          const list = claims || [];
          showAlert('Loaded ' + list.length + ' claims', 'success');
        },
        error: function(){ showAlert('Failed to load your claims', 'error'); }
      });
    }

    function showClaimHistory() {
      showAlert('Claim history feature will be implemented', 'success');
    }

    function loadMyPolicies() {
      if (!authToken) { window.location.href = API_BASE_URL + '/login'; return; }
      openBrowsePolicies();
    }

    function openBrowsePolicies(){
      $('#browsePoliciesList').html('Loading...');
      $('#browsePoliciesModal').css('display','flex');
      $.ajax({
        url: API_BASE_URL + '/policies',
        method: 'GET',
        headers: { 'Authorization': 'Bearer ' + authToken },
        success: function(data){ renderAvailablePolicies(data || []); },
        error: function(){ $('#browsePoliciesList').html('<div>Failed to load policies</div>'); }
      });
    }
    function closeBrowsePoliciesModal(){ $('#browsePoliciesModal').hide(); }
    function renderAvailablePolicies(policies){
      const container = document.getElementById('browsePoliciesList');
      if (!policies.length){ container.innerHTML = '<div>No policies found.</div>'; return; }
      const html = policies.map(p => `
        <div style="border:1px solid #e9ecef; border-radius:8px; padding:16px; margin-bottom:10px;">
          <div style="display:flex; justify-content:space-between; align-items:center;">
            <div>
              <div style="font-weight:600;">${p.policyNumber} - ${p.title || ''}</div>
              <div style="color:#666; font-size:14px;">Coverage: ${p.coverageAmount || ''} | Premium: ${p.premium || ''} | Term: ${p.termMonths || ''} months</div>
            </div>
            <div>
              <button class="btn btn-primary" onclick="selectPolicyForClaim(${p.id})">Select</button>
            </div>
          </div>
        </div>`).join('');
      container.innerHTML = html;
    }
    function searchAvailablePolicies(){
      const q = $('#browseSearch').val().trim();
      const query = q ? ('?q=' + encodeURIComponent(q)) : '';
      $('#browsePoliciesList').html('Loading...');
      $.ajax({
        url: API_BASE_URL + '/policies/search' + query,
        method: 'GET',
        headers: { 'Authorization': 'Bearer ' + authToken },
        success: function(data){ renderAvailablePolicies(data || []); },
        error: function(){ $('#browsePoliciesList').html('<div>Search failed</div>'); }
      });
    }
    function selectPolicyForClaim(policyId){
      // Preload File Claim modal and set selected policy
      $('#browsePoliciesModal').hide();
      showFileClaimModal();
      setTimeout(function(){ $('#policySelect').val(String(policyId)); }, 150);
    }

    function downloadPolicyDocs() {
      showAlert('Download documents feature will be implemented', 'success');
    }

    function showSupport() {
      showAlert('Support feature will be implemented', 'success');
    }

    function showFAQ() {
      showAlert('FAQ feature will be implemented', 'success');
    }

    $(document).ready(function() {
      loadDashboardData();
    });
  </script>
</body>
</html>
