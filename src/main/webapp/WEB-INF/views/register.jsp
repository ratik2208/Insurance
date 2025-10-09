<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>HIMS - User Registration</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/app.css" />
  <style>
    * { margin:0; padding:0; box-sizing:border-box; }
    body {
      font-family: 'Arial', sans-serif;
      min-height: 100vh;
      display: flex;
      align-items: center;
      justify-content: center;
      padding: 20px 0;
    }
    .registration-container {
      background: #fff; border-radius: 15px; box-shadow: 0 20px 40px rgba(0,0,0,.1);
      padding: 40px; width: 100%; max-width: 600px; margin: 20px;
    }
    .header { text-align:center; margin-bottom:30px; }
    .header h1 { color:#333; font-size:28px; font-weight:600; margin-bottom:10px; }
    .header p { color:#666; font-size:16px; }
    .form-group { margin-bottom:25px; position: relative; }
    .form-group label { display:block; margin-bottom:8px; color:#333; font-weight:500; font-size:14px; }
    .form-control {
      width:100%; padding:12px 15px; border:2px solid #e1e1e1; border-radius:8px; font-size:14px;
      transition: all .3s ease; background-color:#f9f9f9;
    }
    .form-control:focus { outline:none; border-color:#667eea; background:#fff; box-shadow:0 0 0 3px rgba(102,126,234,.1); }
    .form-control:hover { border-color:#c1c1c1; }
    select.form-control { cursor:pointer; }
    
    /* ✅ Validation States */
    .form-control.valid {
      border-color:#27ae60;
      background-color:#f0fff4;
    }
    .form-control.invalid {
      border-color:#e74c3c;
      background-color:#fff5f5;
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
    
    /* ✅ Password Strength Indicator */
    .password-strength {
      height: 4px;
      background: #e1e1e1;
      border-radius: 2px;
      margin-top: 8px;
      overflow: hidden;
    }
    .password-strength-bar {
      height: 100%;
      transition: all 0.3s ease;
      width: 0;
    }
    .password-strength-bar.weak { background: #e74c3c; width: 33%; }
    .password-strength-bar.medium { background: #f39c12; width: 66%; }
    .password-strength-bar.strong { background: #27ae60; width: 100%; }
    
    .form-row { display:flex; gap:20px; }
    .form-row .form-group { flex:1; }
    .submit-btn {
      width:100%; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color:#fff; border:none; padding:15px 30px;
      border-radius:10px; font-size:16px; font-weight:600; cursor:pointer; transition: all .3s ease; margin-top:20px;
      position:relative; display:flex; align-items:center; justify-content:center;
    }
    .submit-btn:hover:not(:disabled) { transform: translateY(-2px); box-shadow:0 10px 25px rgba(102,126,234,.3); }
    .submit-btn:active { transform: translateY(0); }
    .submit-btn:disabled { opacity:.7; cursor:not-allowed; transform:none; }
    .loading-spinner {
      display:none; width:20px; height:20px; border:2px solid #fff; border-top:2px solid transparent; border-radius:50%;
      animation: spin 1s linear infinite; margin-right:10px;
    }
    @keyframes spin { 0%{transform:rotate(0)} 100%{transform:rotate(360deg)} }
    .login-link { text-align:center; margin-top:25px; color:#666; }
    .login-link a { color:#667eea; text-decoration:none; font-weight:500; }
    .login-link a:hover { text-decoration:underline; }
    .error { 
      color:#e74c3c; 
      font-size:12px; 
      margin-top:5px; 
      display:none;
      animation: fadeIn 0.3s ease;
    }
    @keyframes fadeIn {
      from { opacity: 0; transform: translateY(-5px); }
      to { opacity: 1; transform: translateY(0); }
    }
    .required { color:#e74c3c; }
    .alert {
      padding:15px; margin-bottom:20px; border-radius:8px; display:none; animation: slideDown .3s ease-out; position:relative;
    }
    .alert.success { background:#d4edda; border:1px solid #c3e6cb; color:#155724; }
    .alert.error { background:#f8d7da; border:1px solid #f5c6cb; color:#721c24; }
    .alert-close { position:absolute; right:10px; top:10px; cursor:pointer; font-size:18px; line-height:1; color:inherit; opacity:.7; }
    .alert-close:hover { opacity:1; }
    @keyframes slideDown { from{opacity:0; transform: translateY(-20px)} to{opacity:1; transform: translateY(0)} }
    
    /* ✅ Helper Text */
    .helper-text {
      font-size: 11px;
      color: #999;
      margin-top: 4px;
    }
    
    @media (max-width:768px){
      .registration-container { padding:20px; margin:10px; }
      .form-row { flex-direction:column; gap:0; }
      .header h1 { font-size:24px; }
    }
  </style>
</head>
<body>
  <div class="registration-container card fade-in theme-gradient">
    <div class="header">
      <h1>Create Your Account</h1>
      <p>Join the Healthcare Insurance Management System</p>
    </div>

    <div id="alertMessage" class="alert">
      <span class="alert-close" onclick="closeAlert()">&times;</span>
      <div id="alertText"></div>
    </div>

    <form id="registrationForm" novalidate>
      <div class="form-row">
        <!-- ✅ Name Field with Validation -->
        <div class="form-group">
          <label for="name">Full Name <span class="required">*</span></label>
          <input type="text" 
                 id="name" 
                 name="name" 
                 class="form-control" 
                 required 
                 minlength="2"
                 maxlength="100"
                 pattern="[A-Za-z\s]+"
                 placeholder="Enter your full name" />
          <span class="validation-icon" id="nameIcon">✓</span>
          <div class="error" id="nameError">Name must be 2-100 characters (letters only)</div>
        </div>
        
        <!-- ✅ Email Field with Validation -->
        <div class="form-group">
          <label for="email">Email Address <span class="required">*</span></label>
          <input type="email" 
                 id="email" 
                 name="email" 
                 class="form-control" 
                 required 
                 pattern="[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}"
                 placeholder="Enter your email" />
          <span class="validation-icon" id="emailIcon">✓</span>
          <div class="error" id="emailError">Please enter a valid email address</div>
        </div>
      </div>

      <div class="form-row">
        <!-- ✅ Password Field with Strength Indicator -->
        <div class="form-group">
          <label for="password">Password <span class="required">*</span></label>
          <input type="password" 
                 id="password" 
                 name="password" 
                 class="form-control" 
                 required 
                 minlength="6"
                 placeholder="Enter password" />
          <span class="validation-icon" id="passwordIcon">✓</span>
          <div class="password-strength">
            <div class="password-strength-bar" id="strengthBar"></div>
          </div>
          <div class="error" id="passwordError">Password must be at least 6 characters</div>
          <div class="helper-text">Use a mix of letters, numbers, and symbols for a strong password</div>
        </div>
        
        <!-- ✅ Confirm Password Field -->
        <div class="form-group">
          <label for="confirmPassword">Confirm Password <span class="required">*</span></label>
          <input type="password" 
                 id="confirmPassword" 
                 name="confirmPassword" 
                 class="form-control" 
                 required 
                 minlength="6"
                 placeholder="Re-enter password" />
          <span class="validation-icon" id="confirmPasswordIcon">✓</span>
          <div class="error" id="confirmPasswordError">Passwords must match</div>
        </div>
      </div>

      <!-- ✅ Role Selection -->
      <div class="form-group">
        <label for="role">Select Your Role <span class="required">*</span></label>
        <select id="role" name="role" class="form-control" required>
          <option value="">Choose your role...</option>
          <option value="CUSTOMER">Customer</option>
          <option value="AGENT">Insurance Agent</option>
          <option value="ADMIN">Administrator</option>
        </select>
        <span class="validation-icon" id="roleIcon">✓</span>
        <div class="error" id="roleError">Please select a role</div>
      </div>

      <button type="submit" class="submit-btn" id="submitBtn">
        <div class="loading-spinner" id="loadingSpinner"></div>
        <span id="submitText">Create Account</span>
      </button>
    </form>

    <div class="login-link">
      Already have an account? <a href="${pageContext.request.contextPath}/login">Sign in here</a>
    </div>
  </div>

  <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
  <script>
    // Server configuration
    const API_BASE_URL = window.APP_CONTEXT || '${pageContext.request.contextPath}';
    window.APP_CONTEXT = API_BASE_URL;
    const REGISTRATION_ENDPOINT = API_BASE_URL + '/auth/register';

    // ✅ Validation Rules
    const VALIDATION_RULES = {
      name: {
        required: true,
        minLength: 2,
        maxLength: 100,
        pattern: /^[A-Za-z\s]+$/,
        message: 'Name must be 2-100 characters (letters only)'
      },
      email: {
        required: true,
        pattern: /^[^\s@]+@[^\s@]+\.[^\s@]+$/,
        message: 'Please enter a valid email address'
      },
      password: {
        required: true,
        minLength: 6,
        message: 'Password must be at least 6 characters'
      },
      confirmPassword: {
        required: true,
        match: 'password',
        message: 'Passwords must match'
      },
      role: {
        required: true,
        message: 'Please select a role'
      }
    };

    // ✅ Alert Functions
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
        text.textContent = 'Creating Account...';
      } else {
        btn.disabled = false; 
        spinner.style.display = 'none'; 
        text.textContent = 'Create Account';
      }
    }

    // ✅ Password Strength Calculator
    function calculatePasswordStrength(password) {
      let strength = 0;
      if (password.length >= 6) strength++;
      if (password.length >= 10) strength++;
      if (/[a-z]/.test(password) && /[A-Z]/.test(password)) strength++;
      if (/\d/.test(password)) strength++;
      if (/[^a-zA-Z0-9]/.test(password)) strength++;
      
      return strength;
    }

    function updatePasswordStrength(password) {
      const strengthBar = document.getElementById('strengthBar');
      const strength = calculatePasswordStrength(password);
      
      strengthBar.className = 'password-strength-bar';
      
      if (strength <= 2) {
        strengthBar.classList.add('weak');
      } else if (strength <= 3) {
        strengthBar.classList.add('medium');
      } else {
        strengthBar.classList.add('strong');
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
      icon.classList.remove('valid', 'invalid');
      errorDiv.style.display = 'none';
      
      // Required check
      if (rules.required && !value) {
        field.classList.add('invalid');
        icon.classList.add('invalid');
        icon.textContent = '✗';
        errorDiv.textContent = rules.message || 'This field is required';
        errorDiv.style.display = 'block';
        return false;
      }
      
      // Min length check
      if (rules.minLength && value && value.length < rules.minLength) {
        field.classList.add('invalid');
        icon.classList.add('invalid');
        icon.textContent = '✗';
        errorDiv.textContent = rules.message;
        errorDiv.style.display = 'block';
        return false;
      }
      
      // Max length check
      if (rules.maxLength && value && value.length > rules.maxLength) {
        field.classList.add('invalid');
        icon.classList.add('invalid');
        icon.textContent = '✗';
        errorDiv.textContent = rules.message;
        errorDiv.style.display = 'block';
        return false;
      }
      
      // Pattern check
      if (rules.pattern && value && !rules.pattern.test(value)) {
        field.classList.add('invalid');
        icon.classList.add('invalid');
        icon.textContent = '✗';
        errorDiv.textContent = rules.message;
        errorDiv.style.display = 'block';
        return false;
      }
      
      // Match check (for confirm password)
      if (rules.match && value) {
        const matchField = document.getElementById(rules.match);
        if (value !== matchField.value) {
          field.classList.add('invalid');
          icon.classList.add('invalid');
          icon.textContent = '✗';
          errorDiv.textContent = rules.message;
          errorDiv.style.display = 'block';
          return false;
        }
      }
      
      // Valid state
      if (value) {
        field.classList.add('valid');
        icon.classList.add('valid');
        icon.textContent = '✓';
      }
      
      return true;
    }

    // ✅ Validate Entire Form
    function validateForm() {
      let isValid = true;
      
      // Validate all fields
      if (!validateField('name', VALIDATION_RULES.name)) isValid = false;
      if (!validateField('email', VALIDATION_RULES.email)) isValid = false;
      if (!validateField('password', VALIDATION_RULES.password)) isValid = false;
      if (!validateField('confirmPassword', VALIDATION_RULES.confirmPassword)) isValid = false;
      if (!validateField('role', VALIDATION_RULES.role)) isValid = false;
      
      return isValid;
    }

    function collectFormData() {
      return {
        name: document.getElementById('name').value.trim(),
        email: document.getElementById('email').value.trim(),
        password: document.getElementById('password').value,
        role: document.getElementById('role').value
      };
    }

    function parseSpringErrors(xhr) {
      try {
        const json = xhr.responseJSON || JSON.parse(xhr.responseText);
        if (json) {
          if (json.message && Array.isArray(json.errors)) {
            const details = json.errors.map(e => e.defaultMessage || (e.field ? (e.field + ': ' + e.message) : e)).join('; ');
            return json.message + (details ? ' - ' + details : '');
          }
          if (Array.isArray(json.errors)) {
            return json.errors.join('; ');
          }
          if (json.message) return json.message;
          if (json.error) return json.error;
        }
      } catch (e) {
        // fall through
      }
      return xhr.responseText || 'Registration failed. Please try again.';
    }

    function submitRegistration(payload) {
      $.ajax({
        url: REGISTRATION_ENDPOINT,
        type: 'POST',
        contentType: 'application/json',
        data: JSON.stringify(payload),
        success: function (data) {
          showAlert('Registration successful! Redirecting to login page...', 'success');
          $('#registrationForm')[0].reset();

          setTimeout(function () {
            window.location.href = API_BASE_URL + '/login';
          }, 1500);
        },
        error: function (xhr) {
          let msg = 'Registration failed. Please try again.';
          if (xhr.status === 0) {
            msg = 'Unable to connect to server.';
          } else if (xhr.status === 400) {
            msg = parseSpringErrors(xhr) || 'Invalid data provided.';
          } else if (xhr.status === 409) {
            msg = 'Email already exists. Please use a different email.';
          } else if (xhr.status >= 500) {
            msg = 'Server error. Please try again later.';
          } else {
            msg = parseSpringErrors(xhr);
          }
          showAlert(msg, 'error', false);
        },
        complete: function () { setLoadingState(false); }
      });
    }

    // ✅ Form Submit Handler
    $('#registrationForm').on('submit', function (e) {
      e.preventDefault();
      closeAlert();

      if (!validateForm()) {
        showAlert('Please fix all validation errors before submitting', 'error');
        return;
      }

      setLoadingState(true);

      try {
        const formData = collectFormData();
        submitRegistration(formData);
      } catch (err) {
        console.error(err);
        showAlert('An error occurred while submitting the form', 'error', false);
        setLoadingState(false);
      }
    });

    // ✅ Real-time Validation
    $('#name').on('blur', function() {
      if ($(this).val().trim()) {
        validateField('name', VALIDATION_RULES.name);
      }
    });

    $('#email').on('blur', function() {
      if ($(this).val().trim()) {
        validateField('email', VALIDATION_RULES.email);
      }
    });

    $('#password').on('input', function() {
      const password = $(this).val();
      if (password) {
        updatePasswordStrength(password);
        validateField('password', VALIDATION_RULES.password);
      }
    });

    $('#confirmPassword').on('input', function() {
      if ($(this).val()) {
        validateField('confirmPassword', VALIDATION_RULES.confirmPassword);
      }
    });

    $('#role').on('change', function() {
      validateField('role', VALIDATION_RULES.role);
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

