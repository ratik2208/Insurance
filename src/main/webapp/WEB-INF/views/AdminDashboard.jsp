<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>HIMS - Admin Dashboard</title>
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
    
    /* Modal Styles */
    .modal {
      display: none;
      position: fixed;
      inset: 0;
      background: rgba(0,0,0,.5);
      align-items: center;
      justify-content: center;
      z-index: 1000;
    }
    .modal-content {
      background: #fff;
      padding: 25px;
      border-radius: 12px;
      width: 95%;
      max-width: 1200px;
      max-height: 85vh;
      overflow-y: auto;
      box-shadow: 0 10px 30px rgba(0,0,0,.3);
    }
    .modal-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 20px;
    }
    .modal-header h3 {
      margin: 0;
      color: #333;
    }
    .close-btn {
      background: #f8f9fa;
      color: #667eea;
      border: 1px solid #e9ecef;
      padding: 8px 16px;
      border-radius: 6px;
      cursor: pointer;
    }
    table {
      width: 100%;
      border-collapse: collapse;
      margin-top: 20px;
    }
    table th {
      background: #f8f9fa;
      padding: 12px;
      text-align: left;
      font-weight: 600;
      border-bottom: 2px solid #dee2e6;
    }
    table td {
      padding: 12px;
      border-bottom: 1px solid #e9ecef;
    }
    .badge {
      padding: 4px 10px;
      border-radius: 5px;
      font-size: 12px;
      font-weight: 600;
      text-transform: uppercase;
    }
    .badge-info { background: #17a2b8; color: white; }
    .badge-success { background: #28a745; color: white; }
    .badge-danger { background: #dc3545; color: white; }
    .badge-warning { background: #ffc107; color: #333; }
    
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
      <h1>Admin Dashboard</h1>
      <div class="user-info">
        <span id="userName">Admin User</span>
        <a href="#" class="logout-btn" onclick="event.preventDefault(); logout();">Logout</a>
      </div>
    </div>
  </div>

  <div class="container">
    <div id="alertMessage" class="alert">
      <div id="alertText"></div>
    </div>

    <div class="stats-grid">
      <div class="stat-card">
        <div class="stat-number" id="totalPolicies">-</div>
        <div class="stat-label">Total Policies</div>
      </div>
      <div class="stat-card">
        <div class="stat-number" id="totalClaims">-</div>
        <div class="stat-label">Total Claims</div>
      </div>
      <div class="stat-card">
        <div class="stat-number" id="totalUsers">-</div>
        <div class="stat-label">Total Users</div>
      </div>
      <div class="stat-card">
        <div class="stat-number" id="pendingClaims">-</div>
        <div class="stat-label">Pending Claims</div>
      </div>
    </div>

    <div class="dashboard-grid">
      <div class="dashboard-card">
        <div class="card-header">
          <div class="card-icon">📋</div>
          <div class="card-title">Policy Management</div>
        </div>
        <div class="card-content">
          Create, update, and manage insurance policies. Set coverage amounts, premiums, and eligibility criteria.
        </div>
        <div class="card-actions">
          <a href="${pageContext.request.contextPath}/policies-page" class="btn btn-primary">Create Policy</a>
          <a href="${pageContext.request.contextPath}/policies-page" class="btn btn-secondary">View All Policies</a>
        </div>
      </div>

      <div class="dashboard-card">
        <div class="card-header">
          <div class="card-icon">👥</div>
          <div class="card-title">User Management</div>
        </div>
        <div class="card-content">
          Manage system users, assign roles, and monitor user activity across the platform.
        </div>
        <div class="card-actions">
          <a href="${pageContext.request.contextPath}/users-page" class="btn btn-primary">View Users</a>
          <button class="btn btn-secondary" onclick="showUserStats()">User Statistics</button>
        </div>
      </div>

      <div class="dashboard-card">
        <div class="card-header">
          <div class="card-icon">📊</div>
          <div class="card-title">Claims Overview</div>
        </div>
        <div class="card-content">
          Monitor and review all claims in the system. Approve or reject claims as needed.
        </div>
        <div class="card-actions">
          <button class="btn btn-primary" onclick="viewAllClaims()">View All Claims</button>
          <button class="btn btn-secondary" onclick="showClaimStats()">Claim Statistics</button>
        </div>
      </div>

      <div class="dashboard-card">
        <div class="card-header">
          <div class="card-icon">⚙️</div>
          <div class="card-title">System Settings</div>
        </div>
        <div class="card-content">
          Configure system parameters, manage roles, and maintain system security.
        </div>
        <div class="card-actions">
          <button class="btn btn-primary" onclick="showSystemSettings()">Settings</button>
          <button class="btn btn-secondary" onclick="showAuditLog()">Audit Log</button>
        </div>
      </div>
    </div>
  </div>

  <!-- Claims Modal -->
  <div id="claimsModal" class="modal">
    <div class="modal-content">
      <div class="modal-header">
        <h3>All Claims</h3>
        <button class="close-btn" onclick="closeClaimsModal()">Close</button>
      </div>
      <div id="claimsTableContainer">
        <p>Loading claims...</p>
      </div>
    </div>
  </div>

  <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
  <script>
    var API_BASE_URL = window.APP_CONTEXT || '${pageContext.request.contextPath}';
    window.APP_CONTEXT = API_BASE_URL;
    var authToken = localStorage.getItem('token');
    var userRole = localStorage.getItem('role'); // ✅ FIXED: Changed from 'userRole' to 'role'

    console.log('=== ADMIN DASHBOARD INITIALIZATION ===');
    console.log('Token:', authToken ? authToken.substring(0, 20) + '...' : 'MISSING');
    console.log('Role:', userRole);

    // Check authentication
    if (!authToken) {
      console.error('❌ No token found - redirecting to login');
      alert('Please login first');
      window.location.href = API_BASE_URL + '/login';
    }

    // ✅ FIXED: Check for ADMIN role (case-insensitive)
    if (userRole && userRole.toUpperCase() !== 'ADMIN') {
      console.error('❌ Not authorized - User role:', userRole);
      alert('Access denied. Admin access only.');
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
      console.log('Logging out...');
      localStorage.removeItem('token');
      localStorage.removeItem('userId');
      localStorage.removeItem('role');
      $.ajax({
        url: API_BASE_URL + '/auth/logout',
        type: 'POST',
        complete: function() {
          window.location.href = API_BASE_URL + '/login';
        }
      });
    }

    function loadDashboardStats() {
      if (!authToken) {
        console.error('Cannot load stats - no token');
        return;
      }
      
      console.log('Loading dashboard statistics...');
      
      // Load total claims
      $.ajax({
        url: API_BASE_URL + '/claims',
        method: 'GET',
        headers: { 'Authorization': 'Bearer ' + authToken },
        success: function(claims) {
          console.log('✅ Claims loaded:', claims.length);
          var total = claims.length;
          var pending = claims.filter(function(c) { 
            return c.status === 'FILED' || c.status === 'UNDER_REVIEW'; 
          }).length;
          document.getElementById('totalClaims').textContent = total;
          document.getElementById('pendingClaims').textContent = pending;
        },
        error: function(xhr) {
          console.error('❌ Failed to load claims:', xhr.status);
          document.getElementById('totalClaims').textContent = '0';
          document.getElementById('pendingClaims').textContent = '0';
          if (xhr.status === 401) {
            alert('Session expired. Please login again.');
            window.location.href = API_BASE_URL + '/login';
          }
        }
      });
      
      // Load total policies
      $.ajax({
        url: API_BASE_URL + '/policies',
        method: 'GET',
        headers: { 'Authorization': 'Bearer ' + authToken },
        success: function(policies) {
          console.log('✅ Policies loaded:', policies.length);
          document.getElementById('totalPolicies').textContent = policies.length;
        },
        error: function(xhr) {
          console.error('❌ Failed to load policies:', xhr.status);
          document.getElementById('totalPolicies').textContent = '0';
          if (xhr.status === 401) {
            alert('Session expired. Please login again.');
            window.location.href = API_BASE_URL + '/login';
          }
        }
      });
      
      // Load user stats
      $.ajax({
        url: API_BASE_URL + '/users/stats',
        method: 'GET',
        headers: { 'Authorization': 'Bearer ' + authToken },
        success: function(data) {
          console.log('✅ User stats loaded:', data);
          document.getElementById('totalUsers').textContent = data.totalUsers || '0';
        },
        error: function(xhr) {
          console.error('❌ Failed to load user stats:', xhr.status);
          document.getElementById('totalUsers').textContent = '-';
          if (xhr.status === 401) {
            alert('Session expired. Please login again.');
            window.location.href = API_BASE_URL + '/login';
          }
        }
      });
    }

    function viewAllClaims() {
      if (!authToken) {
        alert('Authentication required. Please login again.');
        window.location.href = API_BASE_URL + '/login';
        return;
      }
      
      console.log('Fetching all claims...');
      
      $('#claimsTableContainer').html('<p style="text-align:center; padding:20px; color:#999;">Loading claims...</p>');
      $('#claimsModal').css('display', 'flex');
      
      $.ajax({
        url: API_BASE_URL + '/claims',
        method: 'GET',
        headers: { 
          'Authorization': 'Bearer ' + authToken,
          'Content-Type': 'application/json'
        },
        success: function(claims) {
          console.log('✅ Claims loaded successfully:', claims.length);
          displayClaimsTable(claims);
        },
        error: function(xhr, status, error) {
          console.error('❌ Failed to load claims');
          console.error('Status:', xhr.status);
          console.error('Response:', xhr.responseText);
          
          if (xhr.status === 401) {
            alert('Session expired. Please login again.');
            localStorage.clear();
            window.location.href = API_BASE_URL + '/login';
          } else {
            $('#claimsTableContainer').html('<div style="text-align:center; padding:40px; color:#e74c3c;"><h4>Failed to load claims</h4><p>' + (xhr.responseText || 'Unknown error') + '</p></div>');
          }
        }
      });
    }

    function displayClaimsTable(claims) {
      if (!claims || claims.length === 0) {
        $('#claimsTableContainer').html('<div style="text-align:center; padding:40px; color:#999;"><h4>No claims found</h4><p>There are no claims in the system yet.</p></div>');
        return;
      }
      
      var html = '<table>';
      html += '<thead><tr>';
      html += '<th>Claim #</th>';
      html += '<th>Customer</th>';
      html += '<th>Policy</th>';
      html += '<th>Amount</th>';
      html += '<th>Status</th>';
      html += '<th>Date</th>';
      html += '</tr></thead><tbody>';
      
      for (var i = 0; i < claims.length; i++) {
        var c = claims[i];
        html += '<tr>';
        html += '<td>' + (c.claimNumber || 'N/A') + '</td>';
        html += '<td>' + (c.customerName || 'N/A') + '</td>';
        html += '<td>' + (c.policyNumber || 'N/A') + '</td>';
        html += '<td>₹' + Number(c.amountClaimed || 0).toLocaleString('en-IN') + '</td>';
        html += '<td><span class="badge badge-' + getStatusBadgeClass(c.status) + '">' + c.status + '</span></td>';
        html += '<td>' + formatDate(c.claimDate) + '</td>';
        html += '</tr>';
      }
      
      html += '</tbody></table>';
      $('#claimsTableContainer').html(html);
    }

    function getStatusBadgeClass(status) {
      if (status === 'APPROVED') return 'success';
      if (status === 'REJECTED') return 'danger';
      if (status === 'UNDER_REVIEW') return 'warning';
      return 'info';
    }

    function formatDate(dateArray) {
      if (!dateArray) return 'N/A';
      if (Array.isArray(dateArray)) {
        var year = dateArray[0];
        var month = String(dateArray[1]).padStart(2, '0');
        var day = String(dateArray[2]).padStart(2, '0');
        return day + '-' + month + '-' + year;
      }
      return String(dateArray);
    }

    function closeClaimsModal() {
      $('#claimsModal').hide();
    }

    function showUserStats() {
      if (!authToken) { 
        window.location.href = API_BASE_URL + '/login'; 
        return; 
      }
      
      $.ajax({
        url: API_BASE_URL + '/users/stats',
        method: 'GET',
        headers: { 'Authorization': 'Bearer ' + authToken },
        success: function(data){
          var msg = 'Total: ' + data.totalUsers + ' | Admin: ' + data.adminCount + ' | Agent: ' + data.agentCount + ' | Customer: ' + data.customerCount;
          showAlert(msg, 'success');
        },
        error: function(xhr){ 
          if (xhr.status === 401) {
            alert('Session expired. Please login again.');
            window.location.href = API_BASE_URL + '/login';
          } else {
            showAlert('Failed to load user stats', 'error'); 
          }
        }
      });
    }

    function showClaimStats() {
      showAlert('Claim statistics feature will be implemented', 'success');
    }

    function showSystemSettings() {
      showAlert('System settings feature will be implemented', 'success');
    }

    function showAuditLog() {
      showAlert('Audit log feature will be implemented', 'success');
    }

    $(document).ready(function() {
      console.log('=== Admin Dashboard Ready ===');
      console.log('Token present:', !!authToken);
      console.log('User role:', userRole);
      
      if (authToken) {
        loadDashboardStats();
      }
    });
  </script>
</body>
</html>
