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
          <div class="form-group">
            <label for="policyId">Select Policy <span class="required">*</span></label>
            <select id="policyId" name="policyId" class="form-control" required>
              <option value="">Choose your policy...</option>
              <option value="1">POL-2025-0001 - Comprehensive Health Insurance</option>
              <option value="2">POL-2025-0002 - Family Health Plan</option>
            </select>
            <div class="error" id="policyIdError">Please select a policy</div>
          </div>
          <div class="form-group">
            <label for="amountClaimed">Claim Amount <span class="required">*</span></label>
            <input type="number" id="amountClaimed" name="amountClaimed" class="form-control" 
                   placeholder="0.00" step="0.01" min="0" required />
            <div class="error" id="amountClaimedError">Please enter a valid amount</div>
          </div>
        </div>

        <div class="form-group">
          <label for="supportingDocumentUrl">Supporting Document URL</label>
          <input type="url" id="supportingDocumentUrl" name="supportingDocumentUrl" 
                 class="form-control" placeholder="https://example.com/document.pdf" />
          <div class="error" id="supportingDocumentUrlError">Please enter a valid URL</div>
        </div>

        <div class="form-group">
          <label for="remarks">Claim Description <span class="required">*</span></label>
          <textarea id="remarks" name="remarks" class="form-control" 
                    placeholder="Please describe the incident, medical treatment, or reason for the claim..." 
                    rows="4" required></textarea>
          <div class="error" id="remarksError">Please provide a description</div>
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

    function validateForm() {
      let isValid = true;

      // Hide old errors
      document.querySelectorAll('.error').forEach(e => e.style.display = 'none');

      // Check required fields
      document.querySelectorAll('input[required], select[required], textarea[required]').forEach(field => {
        if (!field.value || !field.value.trim()) {
          const err = document.getElementById(field.id + 'Error');
          if (err) err.style.display = 'block';
          field.style.borderColor = '#e74c3c';
          isValid = false;
        } else {
          field.style.borderColor = '#e1e1e1';
        }
      });

      // Amount validation
      const amount = parseFloat(document.getElementById('amountClaimed').value);
      if (amount <= 0) {
        document.getElementById('amountClaimedError').style.display = 'block';
        document.getElementById('amountClaimed').style.borderColor = '#e74c3c';
        isValid = false;
      }

      // URL validation
      const url = document.getElementById('supportingDocumentUrl').value.trim();
      if (url && !isValidUrl(url)) {
        document.getElementById('supportingDocumentUrlError').style.display = 'block';
        document.getElementById('supportingDocumentUrl').style.borderColor = '#e74c3c';
        isValid = false;
      }

      return isValid;
    }

    function isValidUrl(string) {
      try {
        new URL(string);
        return true;
      } catch (_) {
        return false;
      }
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
        success: function (data, textStatus, xhr) {
          showAlert('Claim submitted successfully! Redirecting to dashboard...', 'success');
          setTimeout(function () {
            window.location.href = '/hims/customer-dashboard';
          }, 1500);
        },
        error: function (xhr, status, error) {
          console.group('AJAX Claim Submission Error Debug');
          console.log('HTTP Status Code:', xhr.status);
          console.log('jQuery Status Text:', status);
          console.log('Error Thrown:', error);
          console.log('Response Content-Type:', xhr.getResponseHeader('Content-Type'));
          console.log('Raw Response Body:', xhr.responseText);
          console.groupEnd();

          let msg = 'Claim submission failed. Please try again.';
          if (xhr.status === 0) {
            msg = 'Unable to connect to server. Please ensure it is running at ' + API_BASE_URL;
          } else if (xhr.status === 400) {
            msg = 'Invalid claim data. Please check your input.';
          } else if (xhr.status === 401) {
            msg = 'Authentication required. Please log in again.';
            setTimeout(() => { window.location.href = '/hims/login'; }, 2000);
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

    // Event handlers
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

    // Live validations
    $('#amountClaimed').on('input', function () {
      const amount = parseFloat($(this).val());
      const errorDiv = $('#amountClaimedError');
      if (amount > 0) {
        errorDiv.hide();
        $(this).css('border-color', '#27ae60');
      } else if ($(this).val() !== '') {
        errorDiv.show();
        $(this).css('border-color', '#e74c3c');
      } else {
        errorDiv.hide();
        $(this).css('border-color', '#e1e1e1');
      }
    });

    $('#supportingDocumentUrl').on('blur', function () {
      const url = $(this).val().trim();
      const errorDiv = $('#supportingDocumentUrlError');
      if (url && !isValidUrl(url)) {
        errorDiv.show();
        $(this).css('border-color', '#e74c3c');
      } else if (url) {
        errorDiv.hide();
        $(this).css('border-color', '#27ae60');
      } else {
        errorDiv.hide();
        $(this).css('border-color', '#e1e1e1');
      }
    });

    $('.form-control').on('focus', function () {
      $(this).css('border-color', '#667eea');
    });

    $(document).ready(function () {
      setLoadingState(false);
    });
  </script>
</body>
</html>
