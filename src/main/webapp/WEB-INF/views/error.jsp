<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>HIMS - Error</title>
  <style>
    * { margin:0; padding:0; box-sizing:border-box; }
    body {
      font-family: 'Arial', sans-serif;
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      min-height: 100vh;
      display: flex;
      align-items: center;
      justify-content: center;
    }
    .error-container {
      background: #fff; border-radius: 15px; box-shadow: 0 20px 40px rgba(0,0,0,.1);
      padding: 40px; width: 100%; max-width: 600px; margin: 20px; text-align: center;
    }
    .error-icon {
      font-size: 80px;
      margin-bottom: 30px;
      color: #e74c3c;
    }
    .error-title {
      color: #333;
      font-size: 36px;
      font-weight: 700;
      margin-bottom: 20px;
    }
    .error-message {
      color: #666;
      font-size: 18px;
      line-height: 1.6;
      margin-bottom: 30px;
    }
    .error-details {
      background: #f8f9fa;
      border-radius: 8px;
      padding: 20px;
      margin-bottom: 30px;
      text-align: left;
    }
    .error-details h3 {
      color: #333;
      font-size: 16px;
      margin-bottom: 10px;
    }
    .error-details p {
      color: #666;
      font-size: 14px;
      line-height: 1.5;
    }
    .action-buttons {
      display: flex;
      gap: 20px;
      justify-content: center;
      flex-wrap: wrap;
    }
    .btn {
      padding: 15px 30px;
      border-radius: 10px;
      font-size: 16px;
      font-weight: 600;
      text-decoration: none;
      transition: all 0.3s ease;
      border: none;
      cursor: pointer;
      display: inline-flex;
      align-items: center;
      justify-content: center;
    }
    .btn-primary {
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      color: #fff;
    }
    .btn-primary:hover {
      transform: translateY(-2px);
      box-shadow: 0 10px 25px rgba(102,126,234,.3);
    }
    .btn-secondary {
      background: #fff;
      color: #667eea;
      border: 2px solid #667eea;
    }
    .btn-secondary:hover {
      background: #667eea;
      color: #fff;
    }
    @media (max-width: 768px) {
      .error-container { padding: 20px; margin: 10px; }
      .error-title { font-size: 28px; }
      .action-buttons { flex-direction: column; align-items: center; }
      .btn { width: 100%; max-width: 300px; }
    }
  </style>
</head>
<body>
  <div class="error-container">
    <div class="error-icon">⚠️</div>
    <h1 class="error-title">Oops! Something went wrong</h1>
    <p class="error-message">
      We're sorry, but something unexpected happened. Our team has been notified and is working to fix the issue.
    </p>

    <div class="error-details">
      <h3>Error Details:</h3>
      <p id="errorDetails">
        <strong>Status Code:</strong> <span id="statusCode">500</span><br>
        <strong>Error Message:</strong> <span id="errorMessage">Internal Server Error</span><br>
        <strong>Timestamp:</strong> <span id="timestamp"></span>
      </p>
    </div>

    <div class="action-buttons">
      <a href="/hims/" class="btn btn-primary">Go to Home</a>
      <a href="javascript:history.back()" class="btn btn-secondary">Go Back</a>
    </div>
  </div>

  <script>
    // Set current timestamp
    document.getElementById('timestamp').textContent = new Date().toLocaleString();

    // Get error details from URL parameters or default values
    const urlParams = new URLSearchParams(window.location.search);
    const statusCode = urlParams.get('status') || '500';
    const errorMessage = urlParams.get('message') || 'Internal Server Error';

    document.getElementById('statusCode').textContent = statusCode;
    document.getElementById('errorMessage').textContent = decodeURIComponent(errorMessage);

    // Auto-refresh after 30 seconds (optional)
    // setTimeout(() => {
    //   window.location.href = '/hims/';
    // }, 30000);
  </script>
</body>
</html>
