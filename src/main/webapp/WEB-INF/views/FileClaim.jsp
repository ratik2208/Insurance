<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>HIMS - File New Claim</title>
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
      max-width: 800px;
      margin: 0 auto;
      padding: 30px 20px;
    }
    .form-container {
      background: white;
      border-radius: 15px;
      box-shadow: 0 20px 40px rgba(0,0,0,.1);
      padding: 40px;
    }
    .form-header {
      text-align: center;
      margin-bottom: 30px;
    }
    .form-header h2 {
      color: #333;
      font-size: 24px;
      font-weight: 600;
      margin-bottom: 10px;
    }
    .form-header p {
      color: #666;
      font-size: 16px;
    }
    .form-group {
      margin-bottom: 25px;
      position: relative;
    }
    .form-group label {
      display: block;
      margin-bottom: 8px;
      color: #333;
      font-weight: 500;
      font-size: 14px;
    }
    .form-control {
      width: 100%;
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
    .form-control:hover {
      border-color: #c1c1c1;
    }
    select.form-control {
      cursor: pointer;
    }
    textarea.form-control {
      resize: vertical;
      min-height: 100px;
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
    
    /* ✅ Validation Icon */
    .validation-icon {
      position: absolute;
      right: 15px;
      top: 43px;
      font-size: 18px;
      display: none;
    }
    .validation-icon.valid { color: #27ae60; display: block; }
    .validation-icon.invalid { color: #e74c3c; display: block; }
    
    .form-row {
      display: flex;
      gap: 20px;
    }
    .form-row .form-group {
      flex: 1;
    }
    .submit-btn {
      width: 100%;
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      color: #fff;
      border: none;
      padding: 15px 30px;
      border-radius: 10px;
      font-size: 16px;
      font-weight: 600;
      cursor: pointer;
      transition: all .3s ease;
      margin-top: 20px;
      position: relative;
      display: flex;
      align-items: center;
      justify-content: center;
    }
    .submit-btn:hover:not(:disabled) {
      transform: translateY(-2px);
      box-shadow: 0 10px 25px rgba(102,126,234,.3);
    }
    .submit-btn:active {
      transform: translateY(0);
    }
    .submit-btn:disabled {
      opacity: .7;
      cursor: not-allowed;
      transform: none;
    }
    .loading-spinner {
      display: none;
      width: 20px;
      height: 20px;
      border: 2px solid #fff;
      border-top: 2px solid transparent;
      border-radius: 50%;
      animation: spin 1s linear infinite;
      margin-right: 10px;
    }
    @keyframes spin {
      0% { transform: rotate(0); }
      100% { transform: rotate(360deg); }
    }
    .error {
      color: #e74c3c;
      font-size: 12px;
      margin-top: 5px;
      display: none;
      animation: fadeIn 0.3s ease;
    }
    @keyframes fadeIn {
      from { opacity: 0; transform: translateY(-5px); }
      to { opacity: 1; transform: translateY(0); }
    }
    .required {
      color: #e74c3c;
    }
    .alert {
      padding: 15px;
      margin-bottom: 20px;
      border-radius: 8px;
      display: none;
      animation: slideDown .3s ease-out;
      position: relative;
    }
    .alert.success {
      background: #d4edda;
      border: 1px solid #c3e6cb;
      color: #155724;
    }
    .alert.error {
      background: #f8d7da;
      border: 1px solid #f5c6cb;
      color: #721c24;
    }
    .alert-close {
      position: absolute;
      right: 10px;
      top: 10px;
      cursor: pointer;
      font-size: 18px;
      line-height: 1;
      color: inherit;
      opacity: .7;
    }
    .alert-close:hover {
      opacity: 1;
    }
    @keyframes slideDown {
      from { opacity: 0; transform: translateY(-20px); }
      to { opacity: 1; transform: translateY(0); }
    }
    
    /* ✅ Helper Text */
    .helper-text {
      font-size: 11px;
      color: #999;
      margin-top: 4px;
    }
    
    @media (max-width: 768px) {
      .form-container { padding: 20px; }
      .form-row { flex-direction: column; gap: 0; }
      .form-header h2 { font-size: 20px; }
    }
  </style>
</head>
<body>
  <div class="header app-header">
    <div class="header-content">
      <h1>File New Claim</h1>
      <a href="${pageContext.request.contextPath}/customer-dashboard" class="back-btn">← Back to Dashboard</a>
    </div>
  </div>

  <div class="container">
    <div class="form-container">
      <div class="form-header">
        <h2>Submit Insurance Claim</h2>
        <p>Please provide all required information to process your claim</p>
      </div>

      <div id="alertMessage" class="alert">
        <span class="alert-close" onclick="closeAlert()">&times;</span>
        <div id="alertText"></div>
      </div>

      <form id="claimForm" novalidate>
        <div class="form-row">
          
          <!-- ✅ Policy Selection with Validation -->
          <div class="form-group">
            <label for="policyId">Select Policy <span class="required">*</span></label>
            <select id="policyId" 
                    name="policyId" 
                    class="form-control" 
                    required>
              <option value="">Choose your policy...</option>
            </select>
            <span class="validation-icon" id="policyIdIcon">✓</span>
            <div class="error" id="policyIdError">Please select a policy</div>
          </div>
          
          <!-- ✅ Claim Amount with Validation -->
          <div class="form-group">
            <label for="amountClaimed">Claim Amount <span class="required">*</span></label>
            <input type="number" 
                   id="amountClaimed" 
                   name="amountClaimed" 
                   class="form-control" 
                   placeholder="0.00" 
                   step="0.01" 
                   min="100" 
                   max="100000000"
                   required />
            <span class="validation-icon" id="amountClaimedIcon">✓</span>
            <div class="error" id="amountClaimedError">Amount must be between 100 and 100,000,000</div>
          </div>
        </div>

        <!-- ✅ Supporting Document URL with Validation -->
        <div class="form-group">
          <label for="supportingDocumentUrl">Supporting Document URL</label>
          <input type="url" 
                 id="supportingDocumentUrl" 
                 name="supportingDocumentUrl" 
                 class="form-control" 
                 maxlength="500"
                 placeholder="https://example.com/document.pdf" />
          <span class="validation-icon" id="supportingDocumentUrlIcon">✓</span>
          <div class="error" id="supportingDocumentUrlError">Please enter a valid URL (max 500 characters)</div>
          <div class="helper-text">Optional: Link to medical bills, receipts, or other supporting documents</div>
        </div>

        <!-- ✅ Remarks with Validation -->
        <div class="form-group">
          <label for="remarks">Claim Description <span class="required">*</span></label>
          <textarea id="remarks" 
                    name="remarks" 
                    class="form-control" 
                    placeholder="Please describe the incident, medical treatment, or reason for the claim..." 
                    rows="4" 
                    required
                    minlength="10"
                    maxlength="1000"></textarea>
          <span class="validation-icon" id="remarksIcon" style="top:53px;">✓</span>
          <div class="error" id="remarksError">Description must be 10-1000 characters</div>
          <small class="helper-text"><span id="remarksCount">0</span>/1000 characters</small>
        </div>

        <button type="submit" class="submit-btn" id="submitBtn">
          <div class="loading-spinner" id="loadingSpinner"></div>
          <span id="submitText">Submit Claim</span>
        </button>
      </form>
    </div>
  </div>

  <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
  <script>
    const API_BASE_URL = window.APP_CONTEXT || '${pageContext.request.contextPath}';
    let authToken = localStorage.getItem('token');

    // ✅ Validation Rules
    const CLAIM_VALIDATION_RULES = {
      policyId: {
        required: true,
        message: 'Please select a policy'
      },
      amountClaimed: {
        required: true,
        min: 100,
        max: 100000000,
        message: 'Amount must be between 100 and 100,000,000'
      },
      supportingDocumentUrl: {
        required: false,
        maxLength: 500,
        pattern: /^https?:\/\/.+/,
        message: 'Please enter a valid URL (max 500 characters)'
      },
      remarks: {
        required: true,
        minLength: 10,
        maxLength: 1000,
        message: 'Description must be 10-1000 characters'
      }
    };

    function showAlert(message, type, autoClose = true) {
      const alertDiv = document.getElementById('alertMessage');
      const alertText = document.getElementById('alertText');
      alertText.textContent = message;
      alertDiv.className = 'alert ' + type;
      alertDiv.style.display = 'block';
      alertDiv.scrollIntoView({ behavior: 'smooth', block: 'center' });
      if (autoClose && type !== 'error') {
        setTimeout(() => { alertDiv.style.display = 'none'; }, 5000);
      }
    }

    function closeAlert() {
      document.getElementById('alertMessage').style.display = 'none';
    }

    function setLoadingState(loading) {
      const btn = document.getElementById('submitBtn');
      const spinner = document.getElementById('loadingSpinner');
      const text = document.getElementById('submitText');
      if (loading) {
        btn.disabled = true;
        spinner.style.display = 'inline-block';
        text.textContent = 'Submitting Claim...';
      } else {
        btn.disabled = false;
        spinner.style.display = 'none';
        text.textContent = 'Submit Claim';
      }
    }

    // ✅ Enhanced Field Validation
    function validateField(fieldId, rules) {
      const field = document.getElementById(fieldId);
      const value = field.value.trim();
      const errorDiv = document.getElementById(fieldId + 'Error');
      const icon = document.getElementById(fieldId + 'Icon');
      
      // Reset state
      field.classList.remove('valid', 'invalid');
      if (icon) {
        icon.classList.remove('valid', 'invalid');
      }
      errorDiv.style.display = 'none';
      
      // Required check
      if (rules.required && !value) {
        field.classList.add('invalid');
        if (icon) {
          icon.classList.add('invalid');
          icon.textContent = '✗';
        }
        errorDiv.textContent = rules.message || 'This field is required';
        errorDiv.style.display = 'block';
        return false;
      }
      
      // Numeric validation
      if (field.type === 'number' && value) {
        const num = parseFloat(value);
        
        if (isNaN(num)) {
          field.classList.add('invalid');
          if (icon) {
            icon.classList.add('invalid');
            icon.textContent = '✗';
          }
          errorDiv.textContent = 'Please enter a valid number';
          errorDiv.style.display = 'block';
          return false;
        }
        
        if (rules.min !== undefined && num < rules.min) {
          field.classList.add('invalid');
          if (icon) {
            icon.classList.add('invalid');
            icon.textContent = '✗';
          }
          errorDiv.textContent = rules.message;
          errorDiv.style.display = 'block';
          return false;
        }
        
        if (rules.max !== undefined && num > rules.max) {
          field.classList.add('invalid');
          if (icon) {
            icon.classList.add('invalid');
            icon.textContent = '✗';
          }
          errorDiv.textContent = rules.message;
          errorDiv.style.display = 'block';
          return false;
        }
      }
      
      // Text length validation
      if ((field.type === 'text' || field.type === 'url' || field.tagName === 'TEXTAREA') && value) {
        if (rules.minLength && value.length < rules.minLength) {
          field.classList.add('invalid');
          if (icon) {
            icon.classList.add('invalid');
            icon.textContent = '✗';
          }
          errorDiv.textContent = rules.message;
          errorDiv.style.display = 'block';
          return false;
        }
        
        if (rules.maxLength && value.length > rules.maxLength) {
          field.classList.add('invalid');
          if (icon) {
            icon.classList.add('invalid');
            icon.textContent = '✗';
          }
          errorDiv.textContent = rules.message;
          errorDiv.style.display = 'block';
          return false;
        }
      }
      
      // URL pattern validation
      if (field.type === 'url' && value && rules.pattern) {
        if (!rules.pattern.test(value)) {
          field.classList.add('invalid');
          if (icon) {
            icon.classList.add('invalid');
            icon.textContent = '✗';
          }
          errorDiv.textContent = rules.message;
          errorDiv.style.display = 'block';
          return false;
        }
      }
      
      // Valid state
      if (value || !rules.required) {
        field.classList.add('valid');
        if (icon) {
          icon.classList.add('valid');
          icon.textContent = '✓';
        }
      }
      
      return true;
    }

    // ✅ Validate Entire Form
    function validateForm() {
      let isValid = true;
      
      // Validate all fields
      if (!validateField('policyId', CLAIM_VALIDATION_RULES.policyId)) isValid = false;
      if (!validateField('amountClaimed', CLAIM_VALIDATION_RULES.amountClaimed)) isValid = false;
      if (!validateField('remarks', CLAIM_VALIDATION_RULES.remarks)) isValid = false;
      
      // Validate optional URL field
      const url = $('#supportingDocumentUrl').val().trim();
      if (url) {
        if (!validateField('supportingDocumentUrl', CLAIM_VALIDATION_RULES.supportingDocumentUrl)) {
          isValid = false;
        }
      }
      
      return isValid;
    }

    function collectFormData() {
      return {
        policyId: parseInt(document.getElementById('policyId').value),
        amountClaimed: parseFloat(document.getElementById('amountClaimed').value),
        supportingDocumentUrl: document.getElementById('supportingDocumentUrl').value.trim() || null,
        remarks: document.getElementById('remarks').value.trim()
      };
    }

    function submitClaim(claimData) {
      $.ajax({
        url: API_BASE_URL + '/claims',
        type: 'POST',
        contentType: 'application/json',
        headers: {
          'Authorization': 'Bearer ' + authToken
        },
        data: JSON.stringify(claimData),
        success: function (data) {
          showAlert('Claim submitted successfully! Redirecting to dashboard...', 'success');
          setTimeout(function () {
            window.location.href = API_BASE_URL + '/customer-dashboard';
          }, 1500);
        },
        error: function (xhr) {
          let msg = 'Claim submission failed. Please try again.';
          if (xhr.status === 0) {
            msg = 'Unable to connect to server.';
          } else if (xhr.status === 400) {
            msg = 'Invalid claim data. Please check your input.';
          } else if (xhr.status === 401) {
            msg = 'Authentication required. Please log in again.';
            setTimeout(() => { window.location.href = API_BASE_URL + '/login'; }, 2000);
          } else if (xhr.status >= 500) {
            msg = 'Server error. Please try again later.';
          } else {
            try {
              const json = JSON.parse(xhr.responseText);
              msg = json.message || json.error || msg;
            } catch (e) {
              msg = xhr.responseText || msg;
            }
          }
          showAlert(msg, 'error', false);
        },
        complete: function () {
          setLoadingState(false);
        }
      });
    }

    // ✅ Character Counter for Remarks
    $('#remarks').on('input', function() {
      const count = $(this).val().length;
      $('#remarksCount').text(count);
      
      if (count >= 10 && count <= 1000) {
        validateField('remarks', CLAIM_VALIDATION_RULES.remarks);
      }
    });

    // ✅ Real-time Validation on Blur
    $('#policyId').on('change', function() {
      validateField('policyId', CLAIM_VALIDATION_RULES.policyId);
    });

    $('#amountClaimed').on('blur', function() {
      if ($(this).val()) {
        validateField('amountClaimed', CLAIM_VALIDATION_RULES.amountClaimed);
      }
    });

    $('#supportingDocumentUrl').on('blur', function() {
      const url = $(this).val().trim();
      if (url) {
        validateField('supportingDocumentUrl', CLAIM_VALIDATION_RULES.supportingDocumentUrl);
      } else {
        // Clear validation state if empty (optional field)
        $(this).removeClass('valid invalid');
        $('#supportingDocumentUrlIcon').removeClass('valid invalid');
        $('#supportingDocumentUrlError').hide();
      }
    });

    // ✅ Enhanced Form Submission
    $('#claimForm').on('submit', function (e) {
      e.preventDefault();
      closeAlert();

      if (!validateForm()) {
        showAlert('Please fix all validation errors before submitting', 'error');
        return;
      }

      setLoadingState(true);

      try {
        const claimData = collectFormData();
        submitClaim(claimData);
      } catch (err) {
        console.error(err);
        showAlert('An error occurred while submitting the claim', 'error', false);
        setLoadingState(false);
      }
    });

    $('.form-control').on('focus', function () {
      $(this).css('border-color', '#667eea');
    });

    // ✅ Load Policies on Page Load
    $(document).ready(function () {
      setLoadingState(false);
      
      // Load customer policies
      $.ajax({
        url: API_BASE_URL + '/policies',
        method: 'GET',
        headers: { 'Authorization': 'Bearer ' + authToken },
        success: function(policies) {
          const select = $('#policyId');
          select.empty().append('<option value="">Choose your policy...</option>');
          
          if (policies && policies.length > 0) {
            policies.forEach(policy => {
              if (policy.active) {
                select.append('<option value="' + policy.id + '">' + 
                  policy.policyNumber + ' - ' + policy.title + 
                  ' (Coverage: $' + policy.coverageAmount.toLocaleString() + ')' +
                  '</option>');
              }
            });
          } else {
            select.append('<option value="" disabled>No active policies found</option>');
          }
        },
        error: function() {
          showAlert('Failed to load policies', 'error');
        }
      });
    });
  </script>
</body>
</html>
