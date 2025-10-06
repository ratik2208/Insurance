<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Healthcare Insurance Management System</title>
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
    .landing-container {
      background: #fff; border-radius: 15px; box-shadow: 0 20px 40px rgba(0,0,0,.1);
      padding: 40px; width: 100%; max-width: 800px; margin: 20px; text-align: center;
    }
    .header { margin-bottom: 40px; }
    .header h1 { color:#333; font-size:36px; font-weight:700; margin-bottom:15px; }
    .header p { color:#666; font-size:18px; line-height:1.6; }
    .features { display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 30px; margin: 40px 0; }
    .feature-card {
      background: #f8f9ff; border-radius: 12px; padding: 30px; border-left: 4px solid #667eea;
      transition: transform 0.3s ease, box-shadow 0.3s ease;
    }
    .feature-card:hover { transform: translateY(-5px); box-shadow: 0 10px 25px rgba(102,126,234,.2); }
    .feature-icon { font-size: 48px; margin-bottom: 20px; }
    .feature-title { color:#333; font-size:20px; font-weight:600; margin-bottom:15px; }
    .feature-desc { color:#666; font-size:14px; line-height:1.5; }
    .action-buttons { margin-top: 40px; display: flex; gap: 20px; justify-content: center; flex-wrap: wrap; }
    .btn {
      padding: 15px 30px; border-radius: 10px; font-size: 16px; font-weight: 600; text-decoration: none;
      transition: all 0.3s ease; border: none; cursor: pointer; display: inline-flex; align-items: center; justify-content: center;
    }
    .btn-primary {
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: #fff;
    }
    .btn-primary:hover { transform: translateY(-2px); box-shadow: 0 10px 25px rgba(102,126,234,.3); }
    .btn-secondary {
      background: #fff; color: #667eea; border: 2px solid #667eea;
    }
    .btn-secondary:hover { background: #667eea; color: #fff; }
    @media (max-width:768px){
      .landing-container { padding: 20px; margin: 10px; }
      .header h1 { font-size: 28px; }
      .action-buttons { flex-direction: column; align-items: center; }
      .btn { width: 100%; max-width: 300px; }
    }
  </style>
</head>
<body>
  <div class="landing-container">
    <div class="header">
      <h1>Healthcare Insurance Management System</h1>
      <p>Secure, efficient, and comprehensive insurance management for healthcare providers and customers</p>
    </div>

    <div class="features">
      <div class="feature-card">
        <div class="feature-icon">🏥</div>
        <div class="feature-title">Policy Management</div>
        <div class="feature-desc">Create, manage, and track healthcare insurance policies with comprehensive coverage options</div>
      </div>
      <div class="feature-card">
        <div class="feature-icon">📋</div>
        <div class="feature-title">Claim Processing</div>
        <div class="feature-desc">Streamlined claim filing, review, and approval process for faster settlements</div>
      </div>
      <div class="feature-card">
        <div class="feature-icon">👥</div>
        <div class="feature-title">User Management</div>
        <div class="feature-desc">Role-based access for administrators, agents, and customers with secure authentication</div>
      </div>
    </div>

    <div class="action-buttons">
      <a href="${pageContext.request.contextPath}/login" class="btn btn-primary">Sign In</a>
      <a href="${pageContext.request.contextPath}/register" class="btn btn-secondary">Create Account</a>
    </div>
  </div>
  <script>
    // Optional: expose context path for other inline scripts
    window.APP_CONTEXT = '${pageContext.request.contextPath}';
  </script>
</body>
</html>
