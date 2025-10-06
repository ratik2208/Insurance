<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>HIMS - Sign In</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/app.css" />
  <style>
    * { margin:0; padding:0; box-sizing:border-box; }
    body {
      font-family: 'Arial', sans-serif;
      
      min-height: 100vh;
      display: flex;
      align-items: center;
      justify-content: center;
    }
    .login-container {
      background: #fff; border-radius: 15px; box-shadow: 0 20px 40px rgba(0,0,0,.1);
      padding: 40px; width: 100%; max-width: 450px; margin: 20px;
    }
    .header { text-align:center; margin-bottom:30px; }
    .header h1 { color:#333; font-size:28px; font-weight:600; margin-bottom:10px; }
    .header p { color:#666; font-size:16px; }
    .form-group { margin-bottom:25px; }
    .form-group label { display:block; margin-bottom:8px; color:#333; font-weight:500; font-size:14px; }
    .form-control {
      width:100%; padding:12px 15px; border:2px solid #e1e1e1; border-radius:8px; font-size:14px;
      transition: all .3s ease; background-color:#f9f9f9;
    }
    .form-control:focus { outline:none; border-color:#667eea; background:#fff; box-shadow:0 0 0 3px rgba(102,126,234,.1); }
    .form-control:hover { border-color:#c1c1c1; }
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
    .register-link { text-align:center; margin-top:25px; color:#666; }
    .register-link a { color:#667eea; text-decoration:none; font-weight:500; }
    .register-link a:hover { text-decoration:underline; }
    .error { color:#e74c3c; font-size:12px; margin-top:5px; display:none; }
    .required { color:#e74c3c; }
    .alert {
      padding:15px; margin-bottom:20px; border-radius:8px; display:none; animation: slideDown .3s ease-out; position:relative;
    }
    .alert.success { background:#d4edda; border:1px solid #c3e6cb; color:#155724; }
    .alert.error { background:#f8d7da; border:1px solid #f5c6cb; color:#721c24; }
    .alert-close { position:absolute; right:10px; top:10px; cursor:pointer; font-size:18px; line-height:1; color:inherit; opacity:.7; }
    .alert-close:hover { opacity:1; }
    @keyframes slideDown { from{opacity:0; transform: translateY(-20px)} to{opacity:1; transform: translateY(0)} }
    @media (max-width:768px){
      .login-container { padding:20px; margin:10px; }
      .header h1 { font-size:24px; }
    }
  </style>
</head>
<body>
  <div class="login-container card fade-in theme-gradient">
    <div class="header">
      <h1>Welcome Back</h1>
      <p>Sign in to your Healthcare Insurance Management System account</p>
    </div>

    <div id="alertMessage" class="alert">
      <span class="alert-close" onclick="closeAlert()">&times;</span>
      <div id="alertText"></div>
    </div>

    <form id="loginForm" novalidate>
      <div class="form-group">
        <label for="email">Email Address <span class="required">*</span></label>
        <input type="email" id="email" name="email" class="form-control" required />
        <div class="error" id="emailError">Valid email is required</div>
      </div>

      <div class="form-group">
        <label for="password">Password <span class="required">*</span></label>
        <input type="password" id="password" name="password" class="form-control" required />
        <div class="error" id="passwordError">Password is required</div>
      </div>

      <button type="submit" class="submit-btn" id="submitBtn">
        <div class="loading-spinner" id="loadingSpinner"></div>
        <span id="submitText">Sign In</span>
      </button>
    </form>

    <div class="register-link">
      Don't have an account? <a href="${pageContext.request.contextPath}/register">Create one here</a>
    </div>
  </div>

  <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
  <script>
    // Server configuration
    const API_BASE_URL = window.APP_CONTEXT || '${pageContext.request.contextPath}';
    window.APP_CONTEXT = API_BASE_URL;
    const LOGIN_ENDPOINT = API_BASE_URL + '/auth/login';

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
        text.textContent = 'Signing In...';
      } else {
        btn.disabled = false; 
        spinner.style.display = 'none'; 
        text.textContent = 'Sign In';
      }
    }

    function validateForm() {
      let isValid = true;

      // Hide old errors
      document.querySelectorAll('.error').forEach(e => e.style.display = 'none');

      // Check required fields
      document.querySelectorAll('input[required]').forEach(field => {
        if (!field.value || !field.value.trim()) {
          const err = document.getElementById(field.id + 'Error');
          if (err) err.style.display = 'block';
          field.style.borderColor = '#e74c3c';
          isValid = false;
        } else {
          field.style.borderColor = '#e1e1e1';
        }
      });

      // Email format
      const email = document.getElementById('email').value.trim();
      const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
      if (email && !emailPattern.test(email)) {
        const err = document.getElementById('emailError');
        err.textContent = 'Please enter a valid email address';
        err.style.display = 'block';
        document.getElementById('email').style.borderColor = '#e74c3c';
        isValid = false;
      }

      return isValid;
    }

    function collectFormData() {
      return {
        email: document.getElementById('email').value.trim(),
        password: document.getElementById('password').value
      };
    }

    function submitLogin(credentials) {
      $.ajax({
        url: LOGIN_ENDPOINT,
        type: 'POST',
        contentType: 'application/json',
        data: JSON.stringify(credentials),
        success: function (data, textStatus, xhr) {
          // Store token and user info
          localStorage.setItem('token', data.token);
          localStorage.setItem('userId', data.userId);
          localStorage.setItem('userRole', data.role);
          
          showAlert('Login successful! Redirecting to dashboard...', 'success');
          
          // Redirect based on role
          setTimeout(function () {
            if (data.role === 'ADMIN') {
              window.location.href = API_BASE_URL + '/admin-dashboard';
            } else if (data.role === 'AGENT') {
              window.location.href = API_BASE_URL + '/agent-dashboard';
            } else {
              window.location.href = API_BASE_URL + '/customer-dashboard';
            }
          }, 1500);
        },
        error: function (xhr, status, error) {
          console.group('AJAX Login Error Debug');
          console.log('HTTP Status Code:', xhr.status);
          console.log('jQuery Status Text:', status);
          console.log('Error Thrown:', error);
          console.log('Response Content-Type:', xhr.getResponseHeader('Content-Type'));
          console.log('Raw Response Body:', xhr.responseText);
          console.groupEnd();

          let msg = 'Login failed. Please try again.';
          if (xhr.status === 0) {
            msg = 'Unable to connect to server. Please ensure it is running at ' + API_BASE_URL;
          } else if (xhr.status === 401) {
            msg = 'Invalid email or password. Please check your credentials.';
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
        complete: function () { setLoadingState(false); }
      });
    }

    // Event handlers
    $('#loginForm').on('submit', function (e) {
      e.preventDefault();
      closeAlert();

      if (!validateForm()) {
        showAlert('Please fix all validation errors before submitting', 'error');
        return;
      }

      setLoadingState(true);

      try {
        const credentials = collectFormData();
        submitLogin(credentials);
      } catch (err) {
        console.error(err);
        showAlert('An error occurred while submitting the form', 'error', false);
        setLoadingState(false);
      }
    });

    // Live validations
    $('#email').on('blur', function () {
      const email = $(this).val().trim();
      const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
      const errorDiv = $('#emailError');
      if (email && !emailPattern.test(email)) {
        errorDiv.text('Please enter a valid email address').show();
        $(this).css('border-color', '#e74c3c');
      } else if (email) {
        errorDiv.hide();
        $(this).css('border-color', '#27ae60');
      } else {
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
