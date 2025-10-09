<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
    .alert {
      padding: 15px;
      margin-bottom: 20px;
      border-radius: 8px;
      display: none;
    }
    .alert.success { background: #d4edda; border: 1px solid #c3e6cb; color: #155724; }
    .alert.error { background: #f8d7da; border: 1px solid #f5c6cb; color: #721c24; }
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
      padding: 20px;
      border-radius: 12px;
      box-shadow: 0 2px 10px rgba(0,0,0,.08);
      margin-bottom: 30px;
    }
    .search-form {
      display: grid;
      grid-template-columns: 1fr 1fr auto;
      gap: 15px;
      align-items: end;
    }
    .form-group {
      display: flex;
      flex-direction: column;
      position: relative;
    }
    .form-group label {
      margin-bottom: 5px;
      font-weight: 500;
      color: #555;
    }
    .form-control {
      padding: 10px;
      border: 1px solid #ddd;
      border-radius: 6px;
      font-size: 14px;
      transition: border-color 0.3s;
    }
    .form-control:focus {
      outline: none;
      border-color: #667eea;
    }
    
    /* ✅ Validation States */
    .form-control.valid {
      border-color: #27ae60;
      background-color: #f0fff4;
    }
    .form-control.invalid {
      border-color: #e74c3c;
      background-color: #fff5f5;
    }
    
    /* ✅ Validation Error Messages */
    .field-error {
      color: #e74c3c;
      font-size: 12px;
      margin-top: 4px;
      display: none;
      animation: fadeIn 0.3s ease;
    }
    @keyframes fadeIn {
      from { opacity: 0; transform: translateY(-5px); }
      to { opacity: 1; transform: translateY(0); }
    }
    
    /* ✅ Required Indicator */
    .required {
      color: #e74c3c;
    }
    
    .policies-grid {
      display: grid;
      grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
      gap: 20px;
    }
    .policy-card {
      background: white;
      border-radius: 12px;
      padding: 20px;
      box-shadow: 0 2px 10px rgba(0,0,0,.08);
      transition: transform 0.3s ease, box-shadow 0.3s ease;
    }
    .policy-card:hover {
      transform: translateY(-5px);
      box-shadow: 0 8px 25px rgba(0,0,0,.15);
    }
    .policy-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 15px;
      padding-bottom: 10px;
      border-bottom: 2px solid #f0f0f0;
    }
    .policy-number {
      font-weight: 600;
      color: #667eea;
      font-size: 16px;
    }
    .policy-status {
      padding: 4px 12px;
      border-radius: 20px;
      font-size: 12px;
      font-weight: 500;
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
      margin-bottom: 15px;
    }
    .detail-row {
      display: flex;
      justify-content: space-between;
      padding: 8px 0;
      border-bottom: 1px solid #f5f5f5;
    }
    .detail-row:last-child {
      border-bottom: none;
    }
    .detail-label {
      font-weight: 500;
      color: #666;
      font-size: 14px;
    }
    .detail-value {
      color: #333;
      font-size: 14px;
      text-align: right;
    }
    .loading-message {
      text-align: center;
      padding: 40px;
      color: #666;
      font-size: 16px;
    }
    .no-policies {
      text-align: center;
      padding: 40px;
      color: #999;
      font-size: 16px;
    }
    @media (max-width: 768px) {
      .search-form {
        grid-template-columns: 1fr;
      }
      .policies-grid {
        grid-template-columns: 1fr;
      }
      .page-header {
        flex-direction: column;
        gap: 15px;
        align-items: flex-start;
      }
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

    <!-- ✅ Enhanced Create Policy Modal with Validation -->
    <div id="createPolicyModal" style="display:none; position:fixed; inset:0; background:rgba(0,0,0,.5); align-items:center; justify-content:center; z-index:1000;">
      <div style="background:#fff; padding:25px; border-radius:12px; width:95%; max-width:640px; box-shadow:0 10px 30px rgba(0,0,0,.2); max-height:90vh; overflow-y:auto;">
        <h3 style="margin-bottom:15px; color:#333;">Create New Policy</h3>
        <form id="createPolicyForm" novalidate>
          <div class="form-row" style="display:grid; grid-template-columns:1fr 1fr; gap:16px;">
            
            <!-- ✅ Policy Title with Validation -->
            <div class="form-group">
              <label for="policyTitle">Title <span class="required">*</span></label>
              <input type="text" 
                     id="policyTitle" 
                     class="form-control" 
                     required 
                     minlength="3"
                     maxlength="200"
                     placeholder="Enter policy title" />
              <div class="field-error" id="policyTitleError">Title must be 3-200 characters</div>
            </div>
            
            <!-- ✅ Premium with Validation -->
            <div class="form-group">
              <label for="policyPremium">Premium <span class="required">*</span></label>
              <input type="number" 
                     step="0.01" 
                     id="policyPremium" 
                     class="form-control" 
                     required 
                     min="100"
                     max="10000000"
                     placeholder="Enter premium amount" />
              <div class="field-error" id="policyPremiumError">Premium must be between 100 and 10,000,000</div>
            </div>
            
            <!-- ✅ Coverage Amount with Validation -->
            <div class="form-group">
              <label for="coverageAmount">Coverage Amount <span class="required">*</span></label>
              <input type="number" 
                     step="0.01" 
                     id="coverageAmount" 
                     class="form-control" 
                     required 
                     min="1000"
                     max="100000000"
                     placeholder="Enter coverage amount" />
              <div class="field-error" id="coverageAmountError">Coverage must be between 1,000 and 100,000,000</div>
            </div>
            
            <!-- ✅ Term Months with Validation -->
            <div class="form-group">
              <label for="termMonths">Term (months) <span class="required">*</span></label>
              <input type="number" 
                     id="termMonths" 
                     class="form-control" 
                     required 
                     min="1"
                     max="360"
                     placeholder="Enter term in months" />
              <div class="field-error" id="termMonthsError">Term must be between 1 and 360 months</div>
            </div>
          </div>
          
          <!-- ✅ Eligibility Criteria (Optional) -->
          <div class="form-group" style="margin-top:12px;">
            <label for="eligibility">Eligibility Criteria</label>
            <input type="text" 
                   id="eligibility" 
                   class="form-control" 
                   maxlength="500"
                   placeholder="e.g., Age 18-65, No pre-existing conditions" />
            <div class="field-error" id="eligibilityError">Maximum 500 characters allowed</div>
          </div>
          
          <!-- ✅ Description with Validation -->
          <div class="form-group" style="margin-top:12px;">
            <label for="policyDescription">Description <span class="required">*</span></label>
            <textarea id="policyDescription" 
                      class="form-control" 
                      rows="3" 
                      required
                      minlength="10"
                      maxlength="1000"
                      placeholder="Enter policy description..."></textarea>
            <div class="field-error" id="policyDescriptionError">Description must be 10-1000 characters</div>
            <small style="color:#999; font-size:11px;"><span id="descCount">0</span>/1000 characters</small>
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
      <div class="loading-message">Loading policies...</div>
    </div>
  </div>

  <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
  <script>
    const API_BASE_URL = window.APP_CONTEXT || '${pageContext.request.contextPath}';
    let authToken = localStorage.getItem('token');

    // ✅ Validation Rules
    const POLICY_VALIDATION_RULES = {
      policyTitle: {
        required: true,
        minLength: 3,
        maxLength: 200,
        message: 'Title must be 3-200 characters'
      },
      policyDescription: {
        required: true,
        minLength: 10,
        maxLength: 1000,
        message: 'Description must be 10-1000 characters'
      },
      coverageAmount: {
        required: true,
        min: 1000,
        max: 100000000,
        message: 'Coverage must be between 1,000 and 100,000,000'
      },
      policyPremium: {
        required: true,
        min: 100,
        max: 10000000,
        message: 'Premium must be between 100 and 10,000,000'
      },
      termMonths: {
        required: true,
        min: 1,
        max: 360,
        message: 'Term must be between 1 and 360 months'
      },
      eligibility: {
        required: false,
        maxLength: 500,
        message: 'Maximum 500 characters allowed'
      }
    };

    // Check authentication
    if (!authToken) {
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

    function showCreatePolicyModal() {
      if (!authToken) { 
        window.location.href = API_BASE_URL + '/login'; 
        return; 
      }
      $('#createPolicyModal').css('display','flex');
    }

    function closeCreatePolicyModal() { 
      $('#createPolicyModal').hide(); 
      $('#createPolicyForm')[0].reset();
      // Clear validation states
      $('.form-control').removeClass('valid invalid');
      $('.field-error').hide();
      $('#descCount').text('0');
    }

    // ✅ Enhanced Field Validation
    function validateField(fieldId, rules) {
      const field = document.getElementById(fieldId);
      const value = field.value.trim();
      const errorDiv = document.getElementById(fieldId + 'Error');
      
      // Reset state
      field.classList.remove('valid', 'invalid');
      errorDiv.style.display = 'none';
      
      // Required check
      if (rules.required && !value) {
        field.classList.add('invalid');
        errorDiv.textContent = rules.message || 'This field is required';
        errorDiv.style.display = 'block';
        return false;
      }
      
      // For numeric fields
      if (field.type === 'number' && value) {
        const num = parseFloat(value);
        
        if (isNaN(num)) {
          field.classList.add('invalid');
          errorDiv.textContent = 'Please enter a valid number';
          errorDiv.style.display = 'block';
          return false;
        }
        
        if (rules.min !== undefined && num < rules.min) {
          field.classList.add('invalid');
          errorDiv.textContent = rules.message;
          errorDiv.style.display = 'block';
          return false;
        }
        
        if (rules.max !== undefined && num > rules.max) {
          field.classList.add('invalid');
          errorDiv.textContent = rules.message;
          errorDiv.style.display = 'block';
          return false;
        }
      }
      
      // For text fields
      if ((field.type === 'text' || field.tagName === 'TEXTAREA') && value) {
        if (rules.minLength && value.length < rules.minLength) {
          field.classList.add('invalid');
          errorDiv.textContent = rules.message;
          errorDiv.style.display = 'block';
          return false;
        }
        
        if (rules.maxLength && value.length > rules.maxLength) {
          field.classList.add('invalid');
          errorDiv.textContent = rules.message;
          errorDiv.style.display = 'block';
          return false;
        }
      }
      
      // Valid state
      if (value || !rules.required) {
        field.classList.add('valid');
      }
      
      return true;
    }

    // ✅ Validate Entire Form
    function validatePolicyForm() {
      let isValid = true;
      
      // Validate all required fields
      if (!validateField('policyTitle', POLICY_VALIDATION_RULES.policyTitle)) isValid = false;
      if (!validateField('policyDescription', POLICY_VALIDATION_RULES.policyDescription)) isValid = false;
      if (!validateField('coverageAmount', POLICY_VALIDATION_RULES.coverageAmount)) isValid = false;
      if (!validateField('policyPremium', POLICY_VALIDATION_RULES.policyPremium)) isValid = false;
      if (!validateField('termMonths', POLICY_VALIDATION_RULES.termMonths)) isValid = false;
      
      // Validate optional eligibility field
      const eligibility = $('#eligibility').val().trim();
      if (eligibility && eligibility.length > 500) {
        validateField('eligibility', POLICY_VALIDATION_RULES.eligibility);
        isValid = false;
      }
      
      return isValid;
    }

    // ✅ Character Counter for Description
    $('#policyDescription').on('input', function() {
      const count = $(this).val().length;
      $('#descCount').text(count);
      
      if (count >= 10 && count <= 1000) {
        validateField('policyDescription', POLICY_VALIDATION_RULES.policyDescription);
      }
    });

    // ✅ Real-time Validation on Blur
    $('#policyTitle').on('blur', function() {
      if ($(this).val().trim()) {
        validateField('policyTitle', POLICY_VALIDATION_RULES.policyTitle);
      }
    });

    $('#coverageAmount, #policyPremium, #termMonths').on('blur', function() {
      if ($(this).val()) {
        const fieldId = $(this).attr('id');
        validateField(fieldId, POLICY_VALIDATION_RULES[fieldId]);
      }
    });

    // ✅ Enhanced Form Submission
    $('#createPolicyForm').on('submit', function(e) {
      e.preventDefault();
      
      // Validate form
      if (!validatePolicyForm()) {
        showAlert('Please fix all validation errors before submitting', 'error');
        return;
      }
      
      const dto = {
        title: $('#policyTitle').val().trim(),
        description: $('#policyDescription').val().trim(),
        coverageAmount: parseFloat($('#coverageAmount').val()),
        premium: parseFloat($('#policyPremium').val()),
        termMonths: parseInt($('#termMonths').val(), 10),
        eligibilityCriteria: $('#eligibility').val().trim() || null
      };

      $.ajax({
        url: API_BASE_URL + '/policies',
        method: 'POST',
        contentType: 'application/json',
        headers: { 'Authorization': 'Bearer ' + authToken },
        data: JSON.stringify(dto),
        success: function(response) {
          closeCreatePolicyModal();
          showAlert('Policy created successfully!', 'success');
          loadPolicies();
        },
        error: function(xhr) {
          const errorMsg = xhr.responseText || 'Failed to create policy. Please try again.';
          showAlert(errorMsg, 'error');
        }
      });
    });

    function renderPolicies(policies) {
      const grid = document.getElementById('policiesGrid');
      grid.innerHTML = '';
      
      if (!policies || policies.length === 0) {
        grid.innerHTML = '<div class="no-policies">No policies found. Create your first policy to get started!</div>';
        return;
      }

      policies.forEach(p => {
        const activeClass = p.active ? 'status-active' : 'status-inactive';
        const activeText = p.active ? 'Active' : 'Inactive';
        const card = document.createElement('div');
        card.className = 'policy-card';
        
        let detailsHTML = '<div class="policy-header">' +
          '<div class="policy-number">' + (p.policyNumber || 'N/A') + '</div>' +
          '<div class="policy-status ' + activeClass + '">' + activeText + '</div>' +
          '</div>' +
          '<div class="policy-details">' +
          '<div class="detail-row">' +
          '<span class="detail-label">Title:</span>' +
          '<span class="detail-value">' + (p.title || 'N/A') + '</span>' +
          '</div>' +
          '<div class="detail-row">' +
          '<span class="detail-label">Coverage:</span>' +
          '<span class="detail-value">$' + (p.coverageAmount ? p.coverageAmount.toFixed(2) : '0.00') + '</span>' +
          '</div>' +
          '<div class="detail-row">' +
          '<span class="detail-label">Premium:</span>' +
          '<span class="detail-value">$' + (p.premium ? p.premium.toFixed(2) : '0.00') + '/month</span>' +
          '</div>' +
          '<div class="detail-row">' +
          '<span class="detail-label">Term:</span>' +
          '<span class="detail-value">' + (p.termMonths || '0') + ' months</span>' +
          '</div>';
        
        if (p.eligibilityCriteria) {
          detailsHTML += '<div class="detail-row">' +
            '<span class="detail-label">Eligibility:</span>' +
            '<span class="detail-value">' + p.eligibilityCriteria + '</span>' +
            '</div>';
        }
        
        if (p.createdBy) {
          detailsHTML += '<div class="detail-row">' +
            '<span class="detail-label">Created By:</span>' +
            '<span class="detail-value">' + p.createdBy + '</span>' +
            '</div>';
        }
        
        detailsHTML += '</div>';
        card.innerHTML = detailsHTML;
        grid.appendChild(card);
      });
    }

    function loadPolicies() {
      if (!authToken) { 
        window.location.href = API_BASE_URL + '/login'; 
        return; 
      }

      $.ajax({
        url: API_BASE_URL + '/policies',
        method: 'GET',
        headers: { 'Authorization': 'Bearer ' + authToken },
        success: function(data) {
          console.log('Policies loaded:', data);
          renderPolicies(data);
        },
        error: function(xhr) {
          console.error('Failed to load policies:', xhr);
          showAlert('Failed to load policies. Please refresh the page.', 'error');
          document.getElementById('policiesGrid').innerHTML = 
            '<div class="no-policies">Error loading policies. Please try again.</div>';
        }
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
        success: function(data) {
          renderPolicies(data);
        },
        error: function() {
          showAlert('Search failed. Please try again.', 'error');
        }
      });
    }

    // Event handlers
    $('#searchForm').on('submit', function(e) {
      e.preventDefault();
      searchPolicies();
    });

    // Load policies on page load
    $(document).ready(function() {
      loadPolicies();
    });
  </script>
</body>
</html>
