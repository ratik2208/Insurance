<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>HIMS - Policy Management</title>
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
    .policies-grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(350px, 1fr));
      gap: 25px;
    }
    .policy-card {
      background: white;
      border-radius: 12px;
      padding: 25px;
      box-shadow: 0 4px 15px rgba(0,0,0,.1);
      transition: transform 0.3s ease, box-shadow 0.3s ease;
    }
    .policy-card:hover {
      transform: translateY(-5px);
      box-shadow: 0 8px 25px rgba(0,0,0,.15);
    }
    .policy-header {
      display: flex;
      justify-content: space-between;
      align-items: flex-start;
      margin-bottom: 20px;
    }
    .policy-number {
      font-size: 18px;
      font-weight: 600;
      color: #333;
    }
    .policy-status {
      padding: 4px 12px;
      border-radius: 20px;
      font-size: 12px;
      font-weight: 500;
      text-transform: uppercase;
    }
    .status-active {
      background: #d4edda;
      color: #155724;
    }
    .status-inactive {
      background: #f8d7da;
      color: #721c24;
    }
    .policy-details {
      margin-bottom: 20px;
    }
    .detail-row {
      display: flex;
      justify-content: space-between;
      margin-bottom: 8px;
    }
    .detail-label {
      color: #666;
      font-size: 14px;
    }
    .detail-value {
      color: #333;
      font-weight: 500;
      font-size: 14px;
    }
    .policy-actions {
      display: flex;
      gap: 10px;
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
      .policies-grid { grid-template-columns: 1fr; }
    }
  </style>
</head>
<body>
  <div class="header app-header">
    <div class="header-content">
      <h1>Policy Management</h1>
      <a href="${pageContext.request.contextPath}/admin-dashboard" class="back-btn">← Back to Dashboard</a>
    </div>
  </div>

  <div class="container">
    <div id="alertMessage" class="alert">
      <div id="alertText"></div>
    </div>

    <!-- Create Policy Modal -->
    <div id="createPolicyModal" style="display:none; position:fixed; inset:0; background:rgba(0,0,0,.4); align-items:center; justify-content:center;">
      <div style="background:#fff; padding:25px; border-radius:12px; width:95%; max-width:640px; box-shadow:0 10px 30px rgba(0,0,0,.2);">
        <h3 style="margin-bottom:15px;">Create New Policy</h3>
        <form id="createPolicyForm">
          <div class="form-row" style="display:grid; grid-template-columns:1fr 1fr; gap:16px;">
            <div class="form-group">
              <label for="policyTitle">Title</label>
              <input type="text" id="policyTitle" class="form-control" required />
            </div>
            <div class="form-group">
              <label for="policyPremium">Premium</label>
              <input type="number" step="0.01" id="policyPremium" class="form-control" required />
            </div>
            <div class="form-group">
              <label for="coverageAmount">Coverage Amount</label>
              <input type="number" step="0.01" id="coverageAmount" class="form-control" required />
            </div>
            <div class="form-group">
              <label for="termMonths">Term (months)</label>
              <input type="number" id="termMonths" class="form-control" required />
            </div>
          </div>
          <div class="form-group" style="margin-top:12px;">
            <label for="eligibility">Eligibility Criteria</label>
            <input type="text" id="eligibility" class="form-control" />
          </div>
          <div class="form-group" style="margin-top:12px;">
            <label for="policyDescription">Description</label>
            <textarea id="policyDescription" class="form-control" rows="3"></textarea>
          </div>
          <div style="display:flex; gap:10px; justify-content:flex-end; margin-top:16px;">
            <button type="button" class="btn btn-secondary" onclick="closeCreatePolicyModal()">Cancel</button>
            <button type="submit" class="btn btn-primary">Create Policy</button>
          </div>
        </form>
      </div>
    </div>

    <div class="page-header">
      <h2 class="page-title">Insurance Policies</h2>
      <button class="btn btn-primary" onclick="showCreatePolicyModal()">+ Create New Policy</button>
    </div>

    <div class="search-section">
      <form id="searchForm" class="search-form">
        <div class="form-group">
          <label for="searchTerm">Search</label>
          <input type="text" id="searchTerm" name="searchTerm" class="form-control" placeholder="Search by policy number, title..." />
        </div>
        <div class="form-group">
          <label for="statusFilter">Status</label>
          <select id="statusFilter" name="statusFilter" class="form-control">
            <option value="">All Status</option>
            <option value="active">Active</option>
            <option value="inactive">Inactive</option>
          </select>
        </div>
        <div class="form-group">
          <button type="submit" class="btn btn-primary">Search</button>
        </div>
      </form>
    </div>

    <div class="policies-grid" id="policiesGrid">
      <!-- Policies will be loaded here -->
      <div class="policy-card">
        <div class="policy-header">
          <div class="policy-number">POL-2025-0001</div>
          <div class="policy-status status-active">Active</div>
        </div>
        <div class="policy-details">
          <div class="detail-row">
            <span class="detail-label">Title:</span>
            <span class="detail-value">Comprehensive Health Insurance</span>
          </div>
          <div class="detail-row">
            <span class="detail-label">Coverage Amount:</span>
            <span class="detail-value">$50,000</span>
          </div>
          <div class="detail-row">
            <span class="detail-label">Premium:</span>
            <span class="detail-value">$200/month</span>
          </div>
          <div class="detail-row">
            <span class="detail-label">Term:</span>
            <span class="detail-value">12 months</span>
          </div>
        </div>
        <div class="policy-actions">
          <button class="btn btn-primary" onclick="viewPolicy('POL-2025-0001')">View Details</button>
          <button class="btn btn-secondary" onclick="editPolicy('POL-2025-0001')">Edit</button>
        </div>
      </div>

      <div class="policy-card">
        <div class="policy-header">
          <div class="policy-number">POL-2025-0002</div>
          <div class="policy-status status-active">Active</div>
        </div>
        <div class="policy-details">
          <div class="detail-row">
            <span class="detail-label">Title:</span>
            <span class="detail-value">Family Health Plan</span>
          </div>
          <div class="detail-row">
            <span class="detail-label">Coverage Amount:</span>
            <span class="detail-value">$100,000</span>
          </div>
          <div class="detail-row">
            <span class="detail-label">Premium:</span>
            <span class="detail-value">$350/month</span>
          </div>
          <div class="detail-row">
            <span class="detail-label">Term:</span>
            <span class="detail-value">24 months</span>
          </div>
        </div>
        <div class="policy-actions">
          <button class="btn btn-primary" onclick="viewPolicy('POL-2025-0002')">View Details</button>
          <button class="btn btn-secondary" onclick="editPolicy('POL-2025-0002')">Edit</button>
        </div>
      </div>
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

    function showCreatePolicyModal() {
      if (!authToken) { window.location.href = API_BASE_URL + '/login'; return; }
      $('#createPolicyModal').css('display','flex');
    }
    function closeCreatePolicyModal(){ $('#createPolicyModal').hide(); }

    $('#createPolicyForm').on('submit', function(e){
      e.preventDefault();
      const dto = {
        title: $('#policyTitle').val().trim(),
        description: $('#policyDescription').val().trim(),
        coverageAmount: parseFloat($('#coverageAmount').val()),
        premium: parseFloat($('#policyPremium').val()),
        termMonths: parseInt($('#termMonths').val(), 10),
        eligibilityCriteria: $('#eligibility').val().trim()
      };
      if (!dto.title || isNaN(dto.coverageAmount) || isNaN(dto.premium) || isNaN(dto.termMonths)) {
        showAlert('Please fill all required fields', 'error');
        return;
      }
      $.ajax({
        url: API_BASE_URL + '/policies',
        method: 'POST',
        contentType: 'application/json',
        headers: { 'Authorization': 'Bearer ' + authToken },
        data: JSON.stringify(dto),
        success: function(){
          closeCreatePolicyModal();
          showAlert('Policy created successfully', 'success');
          loadPolicies();
          $('#createPolicyForm')[0].reset();
        },
        error: function(xhr){
          showAlert(xhr.responseText || 'Failed to create policy', 'error');
        }
      });
    });

    function viewPolicy(policyNumber) {
      showAlert(`Viewing policy: ${policyNumber}`, 'success');
    }

    function editPolicy(policyNumber) {
      showAlert(`Editing policy: ${policyNumber}`, 'success');
    }

    function renderPolicies(policies) {
      const grid = document.getElementById('policiesGrid');
      grid.innerHTML = '';
      if (!policies || policies.length === 0) {
        grid.innerHTML = '<div>No policies found.</div>';
        return;
      }
      policies.forEach(p => {
        const activeClass = p.active ? 'status-active' : 'status-inactive';
        const activeText = p.active ? 'Active' : 'Inactive';
        const card = document.createElement('div');
        card.className = 'policy-card';
        card.innerHTML = `
          <div class="policy-header">
            <div class="policy-number">${p.policyNumber}</div>
            <div class="policy-status ${activeClass}">${activeText}</div>
          </div>
          <div class="policy-details">
            <div class="detail-row"><span class="detail-label">Title:</span><span class="detail-value">${p.title || ''}</span></div>
            <div class="detail-row"><span class="detail-label">Coverage Amount:</span><span class="detail-value">${p.coverageAmount || ''}</span></div>
            <div class="detail-row"><span class="detail-label">Premium:</span><span class="detail-value">${p.premium || ''}</span></div>
            <div class="detail-row"><span class="detail-label">Term:</span><span class="detail-value">${p.termMonths || ''} months</span></div>
          </div>
          <div class="policy-actions">
            <button class="btn btn-primary" onclick="viewPolicy(${p.id})">View Details</button>
          </div>
        `;
        grid.appendChild(card);
      });
    }

    function loadPolicies() {
      if (!authToken) { window.location.href = API_BASE_URL + '/login'; return; }
      $.ajax({
        url: API_BASE_URL + '/policies',
        method: 'GET',
        headers: { 'Authorization': 'Bearer ' + authToken },
        success: function(data){ renderPolicies(data); },
        error: function(){ showAlert('Failed to load policies', 'error'); }
      });
    }

    function searchPolicies() {
      const searchTerm = document.getElementById('searchTerm').value;
      const statusFilter = document.getElementById('statusFilter').value;
      const active = statusFilter ? (statusFilter === 'active') : null;
      const params = [];
      if (searchTerm) params.push('q=' + encodeURIComponent(searchTerm));
      if (active !== null) params.push('active=' + active);
      const query = params.length ? ('?' + params.join('&')) : '';
      $.ajax({
        url: API_BASE_URL + '/policies/search' + query,
        method: 'GET',
        headers: { 'Authorization': 'Bearer ' + authToken },
        success: function(data){ renderPolicies(data); },
        error: function(){ showAlert('Search failed', 'error'); }
      });
    }

    // Event handlers
    $('#searchForm').on('submit', function(e) {
      e.preventDefault();
      searchPolicies();
    });

    $(document).ready(function() {
      loadPolicies();
    });
  </script>
</body>
</html>
