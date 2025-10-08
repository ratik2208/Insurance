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
        <a href="#" class="logout-btn" onclick="event.preventDefault(); logout();">Logout</a>
      </div>
    </div>
  </div>

  <div class="container">
    <div id="alertMessage" class="alert">
      <div id="alertText"></div>
    </div>

    <!-- File Claim Modal -->
    <div id="fileClaimModal" style="display:none; position:fixed; inset:0; background:rgba(0,0,0,.5); align-items:center; justify-content:center; z-index:1000;">
      <div style="background:#fff; padding:25px; border-radius:12px; width:95%; max-width:520px; box-shadow:0 10px 30px rgba(0,0,0,.3);">
        <h3 style="margin-bottom:15px; color:#333;">File New Claim</h3>
        <form id="fileClaimForm">
          <div class="form-group">
            <label for="policySelect">Policy <span style="color:#e74c3c;">*</span></label>
            <select id="policySelect" class="form-control" required></select>
          </div>
          <div class="form-group">
            <label for="claimAmount">Amount Claimed <span style="color:#e74c3c;">*</span></label>
            <input type="number" step="0.01" min="1" id="claimAmount" class="form-control" required placeholder="Enter amount" />
          </div>
          <div class="form-group">
            <label for="docUrl">Supporting Document URL (optional)</label>
            <input type="url" id="docUrl" class="form-control" placeholder="https://..." />
          </div>
          <div class="form-group">
            <label for="remarks">Remarks (optional)</label>
            <textarea id="remarks" class="form-control" rows="3" placeholder="Additional notes..."></textarea>
          </div>
          <div style="display:flex; gap:10px; justify-content:flex-end; margin-top:20px;">
            <button type="button" class="btn btn-secondary" onclick="closeFileClaimModal()">Cancel</button>
            <button type="submit" class="btn btn-primary">Submit Claim</button>
          </div>
        </form>
      </div>
    </div>

    <!-- Browse Policies Modal -->
    <div id="browsePoliciesModal" style="display:none; position:fixed; inset:0; background:rgba(0,0,0,.5); align-items:center; justify-content:center; z-index:1000;">
      <div style="background:#fff; padding:25px; border-radius:12px; width:95%; max-width:900px; max-height:85vh; overflow-y:auto; box-shadow:0 10px 30px rgba(0,0,0,.3);">
        <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:15px;">
          <h3 style="margin:0; color:#333;">Available Policies</h3>
          <button class="btn btn-secondary" onclick="closeBrowsePoliciesModal()">Close</button>
        </div>
        <div style="margin-bottom:15px; display:flex; gap:10px;">
          <input id="browseSearch" class="form-control" placeholder="Search policies..." style="flex:1;"/>
          <button class="btn btn-primary" onclick="searchAvailablePolicies()">Search</button>
        </div>
        <div id="browsePoliciesList"></div>
      </div>
    </div>

    <div class="stats-grid">
      <div class="stat-card">
        <div class="stat-number" id="availablePolicies">-</div>
        <div class="stat-label">Available Policies</div>
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
          <a href="#" class="btn btn-primary" onclick="event.preventDefault(); showFileClaimModal();">File Claim</a>
          <a href="#" class="btn btn-secondary" onclick="event.preventDefault(); showClaimGuidelines();">Claim Guidelines</a>
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
          <a href="#" class="btn btn-primary" onclick="event.preventDefault(); showMyClaimsModal();">View My Claims</a>
          <a href="#" class="btn btn-secondary" onclick="event.preventDefault(); showClaimHistory();">Claim History</a>
        </div>
      </div>

      <div class="dashboard-card">
        <div class="card-header">
          <div class="card-icon">📄</div>
          <div class="card-title">Browse Policies</div>
        </div>
        <div class="card-content">
          View available insurance policies, coverage details, and premium information.
        </div>
        <div class="card-actions">
          <a href="#" class="btn btn-primary" onclick="event.preventDefault(); openBrowsePolicies();">View Policies</a>
          <a href="#" class="btn btn-secondary" onclick="event.preventDefault(); downloadPolicyDocs();">Download Documents</a>
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
          <a href="#" class="btn btn-primary" onclick="event.preventDefault(); showSupport();">Contact Support</a>
          <a href="#" class="btn btn-secondary" onclick="event.preventDefault(); showFAQ();">FAQ</a>
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
      $.ajax({
        url: API_BASE_URL + '/auth/logout',
        type: 'POST',
        complete: function() {
          window.location.href = API_BASE_URL + '/login';
        }
      });
    }

    function loadDashboardData() {
      document.getElementById('userName').textContent = 'Customer';
      loadStats();
    }

    function loadStats() {
      if (!authToken) { window.location.href = API_BASE_URL + '/login'; return; }
      
      // Get available policies count
      $.ajax({
        url: API_BASE_URL + '/policies',
        method: 'GET',
        headers: { 'Authorization': 'Bearer ' + authToken },
        success: function(policies){
          const activeCount = (policies || []).filter(p => p.active).length;
          document.getElementById('availablePolicies').textContent = activeCount;
        },
        error: function(){ document.getElementById('availablePolicies').textContent = '0'; }
      });
      
      // Get customer's claims stats
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
        },
        error: function(){
          document.getElementById('myClaims').textContent = '0';
          document.getElementById('pendingClaims').textContent = '0';
          document.getElementById('approvedClaims').textContent = '0';
        }
      });
    }

    // ✅ File Claim - Show ALL active policies
   function showFileClaimModal() {
    if (!authToken) { 
        window.location.href = API_BASE_URL + '/login'; 
        return; 
    }
    
    // Clear dropdown and show loading
    $('#policySelect').empty().append('<option value="">Loading policies...</option>');
    
    // Show modal immediately
    $('#fileClaimModal').css('display','flex');
    
    $.ajax({
        url: API_BASE_URL + '/policies',
        method: 'GET',
        headers: { 'Authorization': 'Bearer ' + authToken },
        success: function(data){
            // ✅ DEBUG: Log the response
            console.log('=== POLICIES FOR CLAIM FILING ===');
            console.log('Response type:', typeof data);
            console.log('Is array:', Array.isArray(data));
            console.log('Total policies:', data ? data.length : 0);
            console.log('Full data:', data);
            
            const list = data || [];
            
            if (list.length > 0) {
                console.log('First policy:', list[0]);
                console.log('  - ID:', list[0].id);
                console.log('  - policyNumber:', list[0].policyNumber);
                console.log('  - title:', list[0].title);
                console.log('  - coverageAmount:', list[0].coverageAmount);
            }
            
            // Clear dropdown completely
            $('#policySelect').empty();
            
            // Add default option
            $('#policySelect').append('<option value="">Select a policy...</option>');
            
            if (list.length === 0) {
                $('#policySelect').append('<option value="" disabled>No policies available</option>');
                showAlert('No policies available. Please contact admin.', 'error');
                return;
            }
            
            // Filter active policies
            const activePolicies = list.filter(p => p.active === true || p.active === undefined);
            
            console.log('Active policies count:', activePolicies.length);
            
            if (activePolicies.length === 0) {
                $('#policySelect').append('<option value="" disabled>No active policies</option>');
                showAlert('No active policies available. Please contact admin.', 'error');
                return;
            }
            
            // ✅ Build options with safe property access
            activePolicies.forEach(function(p, index) {
                // Try multiple property name variations
                const id = p.id || '';
                const policyNum = p.policyNumber || p.policy_number || p.policynumber || ('POL-' + id);
                const title = p.title || p.policyName || p.policy_name || 'Untitled Policy';
                const coverage = p.coverageAmount || p.coverage_amount || p.coverage || 0;
                
                // Format coverage
                let optionText = policyNum + ' - ' + title;
                if (coverage > 0) {
                    optionText += ' (₹' + Number(coverage).toLocaleString('en-IN') + ')';
                }
                
                console.log('Creating option ' + (index + 1) + ':', optionText);
                
                // Create and append option
                const option = $('<option></option>')
                    .attr('value', id)
                    .text(optionText);
                
                $('#policySelect').append(option);
            });
            
            // Verify options were added
            const optionCount = $('#policySelect option').length;
            console.log('✅ Policy dropdown populated with', optionCount, 'options');
            
            if (optionCount <= 1) {
                console.error('⚠️ Warning: Only default option exists!');
            }
        },
        error: function(xhr){ 
            console.error('❌ Failed to load policies');
            console.error('Status:', xhr.status);
            console.error('Response:', xhr.responseText);
            
            // Clear and show error
            $('#policySelect').empty().append('<option value="">Error loading policies</option>');
            showAlert('Failed to load policies. Please try again.', 'error'); 
        }
    });
}

    function closeFileClaimModal(){ 
      $('#fileClaimModal').hide(); 
      $('#fileClaimForm')[0].reset();
    }
    
    $('#fileClaimForm').on('submit', function(e){
      e.preventDefault();
      const policyId = $('#policySelect').val();
      if (!policyId) {
        showAlert('Please select a policy', 'error');
        return;
      }
      
      const payload = {
        policyId: Number(policyId),
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
          showAlert('Claim filed successfully!', 'success');
          loadStats();
        },
        error: function(xhr){
          const msg = xhr.responseText || 'Failed to file claim';
          showAlert(msg, 'error');
        }
      });
    });

    // ✅ View My Claims
    // ✅ View My Claims - Modal Version
// ✅ View My Claims - JSP-Safe Version
// ✅ View My Claims - With Proper Date Formatting
function showMyClaimsModal() {
    if (!authToken) { 
        window.location.href = API_BASE_URL + '/login'; 
        return; 
    }
    
    // Create claims modal if it doesn't exist
    if ($('#myClaimsModal').length === 0) {
        var modalHtml = 
        '<div id="myClaimsModal" style="display:none; position:fixed; inset:0; background:rgba(0,0,0,.5); align-items:center; justify-content:center; z-index:1000;">' +
          '<div style="background:#fff; padding:25px; border-radius:12px; width:95%; max-width:900px; max-height:85vh; overflow-y:auto; box-shadow:0 10px 30px rgba(0,0,0,.3);">' +
            '<div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:15px;">' +
              '<h3 style="margin:0; color:#333;">My Claims</h3>' +
              '<button class="btn btn-secondary" onclick="closeMyClaimsModal()">Close</button>' +
            '</div>' +
            '<div id="myClaimsList"></div>' +
          '</div>' +
        '</div>';
        $('body').append(modalHtml);
    }
    
    $('#myClaimsList').html('<div style="padding:20px; text-align:center; color:#999;">Loading claims...</div>');
    $('#myClaimsModal').css('display','flex');
    
    $.ajax({
        url: API_BASE_URL + '/claims/my',
        method: 'GET',
        headers: { 'Authorization': 'Bearer ' + authToken },
        success: function(claims){
            console.log('=== MY CLAIMS ===');
            console.log('Total claims:', claims ? claims.length : 0);
            console.log('Claims data:', claims);
            
            var list = claims || [];
            
            if (list.length === 0) {
                $('#myClaimsList').html('<div style="padding:40px; text-align:center; color:#999;"><div style="font-size:48px; margin-bottom:10px;">📋</div><div style="font-size:18px; font-weight:500; margin-bottom:5px;">No Claims Yet</div><div style="color:#999;">You have not filed any claims yet.</div></div>');
                return;
            }
            
            // Build claims HTML
            var html = '';
            for (var i = 0; i < list.length; i++) {
                var c = list[i];
                
                // Safe property access
                var claimNumber = c.claimNumber || c.claim_number || ('CLM-' + (c.id || i));
                var amount = c.amountClaimed || c.amount_claimed || 0;
                var amountApproved = c.amountApproved || c.amount_approved || 0;
                var status = c.status || 'FILED';
                var policyNum = c.policyNumber || c.policy_number || 'N/A';
                var remarks = c.remarks || '';
                
                // ✅ FIX: Format claim date properly
                var claimDate = 'N/A';
                var rawDate = c.claimDate || c.claim_date;
                
                if (rawDate) {
                    if (Array.isArray(rawDate)) {
                        // Backend returns [2025, 10, 8, 9, 53, 18, 691974000]
                        // Format: [year, month, day, hour, minute, second, nanosecond]
                        var year = rawDate[0];
                        var month = String(rawDate[1]).padStart(2, '0');
                        var day = String(rawDate[2]).padStart(2, '0');
                        var hour = rawDate[3] ? String(rawDate[3]).padStart(2, '0') : '00';
                        var minute = rawDate[4] ? String(rawDate[4]).padStart(2, '0') : '00';
                        
                        claimDate = day + '-' + month + '-' + year + ' ' + hour + ':' + minute;
                    } else if (typeof rawDate === 'string') {
                        // Already a string, just use it
                        claimDate = rawDate.split('T')[0]; // Get date part only
                    } else if (typeof rawDate === 'object' && rawDate.year) {
                        // Object format like {year: 2025, month: 10, day: 8}
                        claimDate = String(rawDate.day).padStart(2, '0') + '-' + 
                                   String(rawDate.month).padStart(2, '0') + '-' + 
                                   rawDate.year;
                    }
                }
                
                console.log('Claim ' + (i+1) + ':', claimNumber, '- Date:', claimDate);
                
                // Status color and label
                var statusColor = '#6c757d';
                var statusLabel = status;
                
                if (status === 'APPROVED') {
                    statusColor = '#28a745';
                    statusLabel = 'Approved';
                } else if (status === 'REJECTED') {
                    statusColor = '#dc3545';
                    statusLabel = 'Rejected';
                } else if (status === 'UNDER_REVIEW') {
                    statusColor = '#ffc107';
                    statusLabel = 'Under Review';
                } else if (status === 'FILED') {
                    statusColor = '#17a2b8';
                    statusLabel = 'Filed';
                }
                
                html += '<div style="border:1px solid #e9ecef; border-radius:10px; padding:20px; margin-bottom:15px; background:#f8f9fa;">';
                html += '  <div style="display:flex; justify-content:space-between; align-items:start; margin-bottom:12px;">';
                html += '    <div style="flex:1;">';
                html += '      <div style="font-weight:600; font-size:18px; color:#333; margin-bottom:5px;">' + claimNumber + '</div>';
                html += '      <div style="color:#666; font-size:14px;"><strong>Policy:</strong> ' + policyNum + '</div>';
                html += '    </div>';
                html += '    <div style="background:' + statusColor + '; color:white; padding:6px 14px; border-radius:6px; font-size:13px; font-weight:600; text-transform:uppercase;">' + statusLabel + '</div>';
                html += '  </div>';
                
                html += '  <div style="display:grid; grid-template-columns:repeat(auto-fit, minmax(180px, 1fr)); gap:15px; margin-top:15px; padding-top:15px; border-top:1px solid #dee2e6;">';
                html += '    <div>';
                html += '      <div style="color:#999; font-size:12px; text-transform:uppercase; margin-bottom:5px; font-weight:500;">Amount Claimed</div>';
                html += '      <div style="font-weight:600; color:#333; font-size:16px;">₹' + Number(amount).toLocaleString('en-IN') + '</div>';
                html += '    </div>';
                
                if (status === 'APPROVED' && amountApproved > 0) {
                    html += '    <div>';
                    html += '      <div style="color:#999; font-size:12px; text-transform:uppercase; margin-bottom:5px; font-weight:500;">Amount Approved</div>';
                    html += '      <div style="font-weight:600; color:#28a745; font-size:16px;">₹' + Number(amountApproved).toLocaleString('en-IN') + '</div>';
                    html += '    </div>';
                }
                
                html += '    <div>';
                html += '      <div style="color:#999; font-size:12px; text-transform:uppercase; margin-bottom:5px; font-weight:500;">Claim Date</div>';
                html += '      <div style="font-weight:600; color:#333; font-size:16px;">' + claimDate + '</div>';
                html += '    </div>';
                html += '  </div>';
                
                if (remarks && remarks !== 'na') {
                    html += '  <div style="margin-top:15px; padding-top:15px; border-top:1px solid #dee2e6;">';
                    html += '    <div style="color:#999; font-size:12px; text-transform:uppercase; margin-bottom:5px; font-weight:500;">Remarks</div>';
                    html += '    <div style="color:#666; font-size:14px; line-height:1.6;">' + remarks + '</div>';
                    html += '    </div>';
                }
                
                html += '</div>';
            }
            
            $('#myClaimsList').html(html);
        },
        error: function(xhr){ 
            console.error('Failed to load claims:', xhr);
            $('#myClaimsList').html('<div style="padding:40px; text-align:center; color:#e74c3c;"><div style="font-size:48px; margin-bottom:10px;">⚠️</div><div style="font-size:18px; font-weight:500; margin-bottom:5px;">Error Loading Claims</div><div>Failed to load your claims. Please try again.</div></div>');
        }
    });
}


function closeMyClaimsModal() {
    $('#myClaimsModal').hide();
}

// ✅ Claim Guidelines - JSP-Safe Version
function showClaimGuidelines() {
    if ($('#claimGuidelinesModal').length === 0) {
        var modalHtml = 
        '<div id="claimGuidelinesModal" style="display:none; position:fixed; inset:0; background:rgba(0,0,0,.5); align-items:center; justify-content:center; z-index:1000;">' +
          '<div style="background:#fff; padding:30px; border-radius:12px; width:95%; max-width:600px; box-shadow:0 10px 30px rgba(0,0,0,.3);">' +
            '<div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:20px;">' +
              '<h3 style="margin:0; color:#333;">📋 Claim Filing Guidelines</h3>' +
              '<button class="btn btn-secondary" onclick="closeClaimGuidelinesModal()">Close</button>' +
            '</div>' +
            '<div style="color:#555; line-height:1.8;">' +
              '<div style="background:#f8f9fa; padding:15px; border-radius:8px; margin-bottom:15px;">' +
                '<h4 style="color:#667eea; margin-bottom:10px; font-size:16px;">📝 Before Filing a Claim</h4>' +
                '<ul style="margin:0; padding-left:20px;">' +
                  '<li style="margin-bottom:8px;">Ensure all required documents are ready for upload</li>' +
                  '<li style="margin-bottom:8px;">Verify that the claim amount is accurate and within policy coverage</li>' +
                  '<li style="margin-bottom:8px;">Check your policy terms and conditions</li>' +
                  '<li style="margin-bottom:8px;">Have your policy number handy</li>' +
                '</ul>' +
              '</div>' +
              '<div style="background:#f8f9fa; padding:15px; border-radius:8px; margin-bottom:15px;">' +
                '<h4 style="color:#667eea; margin-bottom:10px; font-size:16px;">⏱️ Processing Timeline</h4>' +
                '<ul style="margin:0; padding-left:20px;">' +
                  '<li style="margin-bottom:8px;"><strong>Initial Review:</strong> 1-2 business days</li>' +
                  '<li style="margin-bottom:8px;"><strong>Document Verification:</strong> 2-3 business days</li>' +
                  '<li style="margin-bottom:8px;"><strong>Final Decision:</strong> 5-7 business days</li>' +
                  '<li style="margin-bottom:8px;"><strong>Payment (if approved):</strong> 3-5 business days after approval</li>' +
                '</ul>' +
              '</div>' +
              '<div style="background:#fff3cd; border:1px solid #ffc107; padding:15px; border-radius:8px;">' +
                '<h4 style="color:#856404; margin-bottom:10px; font-size:16px;">⚠️ Important Notes</h4>' +
                '<ul style="margin:0; padding-left:20px; color:#856404;">' +
                  '<li style="margin-bottom:8px;">Claims must be filed within 30 days of the incident</li>' +
                  '<li style="margin-bottom:8px;">False claims will result in policy cancellation</li>' +
                  '<li style="margin-bottom:8px;">You can track claim status in real-time</li>' +
                  '<li style="margin-bottom:8px;">For urgent claims, contact customer support</li>' +
                '</ul>' +
              '</div>' +
            '</div>' +
          '</div>' +
        '</div>';
        $('body').append(modalHtml);
    }
    
    $('#claimGuidelinesModal').css('display','flex');
}

function closeClaimGuidelinesModal() {
    $('#claimGuidelinesModal').hide();
}

// ✅ Claim History
function showClaimHistory() {
    showMyClaimsModal();
}


    // ✅ Browse Policies
    function openBrowsePolicies(){
      $('#browsePoliciesList').html('<div style="padding:20px; text-align:center; color:#999;">Loading policies...</div>');
      $('#browsePoliciesModal').css('display','flex');
      $.ajax({
        url: API_BASE_URL + '/policies',
        method: 'GET',
        headers: { 'Authorization': 'Bearer ' + authToken },
        success: function(data){ 
          renderAvailablePolicies(data || []); 
        },
        error: function(xhr){ 
          console.error('Failed to load policies:', xhr);
          $('#browsePoliciesList').html('<div style="padding:20px; text-align:center; color:#e74c3c;">Failed to load policies.</div>'); 
        }
      });
    }
    
    function closeBrowsePoliciesModal(){ $('#browsePoliciesModal').hide(); }
    
    function renderAvailablePolicies(policies){
      const container = document.getElementById('browsePoliciesList');
      
      if (!policies || policies.length === 0) { 
        container.innerHTML = '<div style="padding:40px; text-align:center; color:#999;">No policies available.</div>'; 
        return; 
      }
      
      const html = policies.map(p => {
        const policyNumber = p.policyNumber || 'N/A';
        const title = p.title || 'Untitled Policy';
        const description = p.description || 'No description';
        const coverage = p.coverageAmount ? '₹' + Number(p.coverageAmount).toLocaleString('en-IN') : 'N/A';
        const premium = p.premium ? '₹' + Number(p.premium).toLocaleString('en-IN') : 'N/A';
        const term = p.termMonths || 'N/A';
        
        return `
        <div style="border:1px solid #e9ecef; border-radius:10px; padding:20px; margin-bottom:15px; background:#f8f9fa;">
          <div style="display:flex; justify-content:space-between; align-items:start; gap:15px;">
            <div style="flex:1;">
              <div style="font-weight:600; font-size:17px; color:#333; margin-bottom:8px;">
                ${policyNumber} - ${title}
              </div>
              <div style="color:#666; font-size:14px; margin-bottom:12px; line-height:1.5;">
                ${description}
              </div>
              <div style="color:#555; font-size:13px; display:flex; flex-wrap:wrap; gap:15px;">
                <span><strong>Coverage:</strong> ${coverage}</span>
                <span><strong>Premium:</strong> ${premium}/year</span>
                <span><strong>Term:</strong> ${term} months</span>
              </div>
            </div>
          </div>
        </div>`;
      }).join('');
      
      container.innerHTML = html;
    }
    
    function searchAvailablePolicies(){
      const q = $('#browseSearch').val().trim();
      const query = q ? ('?q=' + encodeURIComponent(q)) : '';
      $('#browsePoliciesList').html('<div style="padding:20px; text-align:center; color:#999;">Searching...</div>');
      $.ajax({
        url: API_BASE_URL + '/policies/search' + query,
        method: 'GET',
        headers: { 'Authorization': 'Bearer ' + authToken },
        success: function(data){ renderAvailablePolicies(data || []); },
        error: function(){ 
          $('#browsePoliciesList').html('<div style="padding:20px; text-align:center; color:#e74c3c;">Search failed.</div>'); 
        }
      });
    }

    function downloadPolicyDocs() {
      showAlert('Download documents feature coming soon', 'success');
    }

    function showSupport() {
      showAlert('Contact: support@hims.com | Phone: 1800-123-4567', 'success');
    }

    function showFAQ() {
      showAlert('FAQ feature coming soon', 'success');
    }

    $(document).ready(function() {
      loadDashboardData();
    });
  </script>
</body>
</html>
