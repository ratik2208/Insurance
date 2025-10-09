<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>HIMS - User Management</title>
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
    .btn-back {
      background: rgba(255,255,255,.2);
      color: white;
      border: 1px solid rgba(255,255,255,.3);
      padding: 8px 16px;
      border-radius: 6px;
      text-decoration: none;
      cursor: pointer;
    }
    .container {
      max-width: 1200px;
      margin: 0 auto;
      padding: 30px 20px;
    }
    table {
      width: 100%;
      background: white;
      border-collapse: collapse;
      border-radius: 12px;
      overflow: hidden;
      box-shadow: 0 4px 15px rgba(0,0,0,.1);
    }
    table th {
      background: #f8f9fa;
      padding: 15px;
      text-align: left;
      font-weight: 600;
      border-bottom: 2px solid #dee2e6;
    }
    table td {
      padding: 15px;
      border-bottom: 1px solid #e9ecef;
    }
    .badge {
      padding: 5px 12px;
      border-radius: 5px;
      font-size: 12px;
      font-weight: 600;
      text-transform: uppercase;
    }
    .badge-admin { background: #dc3545; color: white; }
    .badge-agent { background: #ffc107; color: #333; }
    .badge-customer { background: #28a745; color: white; }
    .loading {
      text-align: center;
      padding: 40px;
      color: #999;
    }
  </style>
</head>
<body>
  <div class="header">
    <div class="header-content">
      <h1>User Management</h1>
      <a href="${pageContext.request.contextPath}/admin-dashboard" class="btn-back">← Back to Dashboard</a>
    </div>
  </div>

  <div class="container">
    <div id="usersTableContainer">
      <p class="loading">Loading users...</p>
    </div>
  </div>

  <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
  <script>
    var API_BASE_URL = '${pageContext.request.contextPath}';
    var authToken = localStorage.getItem('token');
    var userRole = localStorage.getItem('userRole');

    // Check authentication
    if (!authToken || userRole !== 'ADMIN') {
      window.location.href = API_BASE_URL + '/login';
    }

    function loadUsers() {
      $.ajax({
        url: API_BASE_URL + '/users',
        method: 'GET',
        headers: { 
          'Authorization': 'Bearer ' + authToken,
          'Content-Type': 'application/json'
        },
        success: function(users) {
          displayUsers(users);
        },
        error: function(xhr) {
          console.error('Error:', xhr.status, xhr.responseText);
          if (xhr.status === 401) {
            alert('Session expired. Please login again.');
            window.location.href = API_BASE_URL + '/login';
          } else {
            $('#usersTableContainer').html('<p style="text-align:center; padding:40px; color:#e74c3c;">Failed to load users: ' + xhr.responseText + '</p>');
          }
        }
      });
    }

    function displayUsers(users) {
      if (!users || users.length === 0) {
        $('#usersTableContainer').html('<p style="text-align:center; padding:40px; color:#999;">No users found</p>');
        return;
      }

      var html = '<table>';
      html += '<thead><tr>';
      html += '<th>ID</th>';
      html += '<th>Name</th>';
      html += '<th>Email</th>';
      html += '<th>Role</th>';
      html += '<th>Created At</th>';
      html += '</tr></thead><tbody>';

      for (var i = 0; i < users.length; i++) {
        var u = users[i];
        var badgeClass = 'badge-customer';
        if (u.role === 'ADMIN') badgeClass = 'badge-admin';
        else if (u.role === 'AGENT') badgeClass = 'badge-agent';

        html += '<tr>';
        html += '<td>' + u.id + '</td>';
        html += '<td>' + u.name + '</td>';
        html += '<td>' + u.email + '</td>';
        html += '<td><span class="badge ' + badgeClass + '">' + u.role + '</span></td>';
        html += '<td>' + formatDate(u.createdAt) + '</td>';
        html += '</tr>';
      }

      html += '</tbody></table>';
      $('#usersTableContainer').html(html);
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

    $(document).ready(function() {
      loadUsers();
    });
  </script>
</body>
</html>
