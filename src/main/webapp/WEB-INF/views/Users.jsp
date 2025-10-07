<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>HIMS - Users</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/app.css" />
</head>
<body>
  <div class="header app-header" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 16px 0;">
    <div class="header-content" style="max-width:1200px; margin:0 auto; padding:0 20px; display:flex; justify-content:space-between; align-items:center;">
      <h1 style="font-size:24px;">Users</h1>
      <a href="${pageContext.request.contextPath}/admin-dashboard" style="color:white; text-decoration:none;">← Back</a>
    </div>
  </div>

  <div class="container" style="max-width:1200px; margin:0 auto; padding:30px 20px;">
    <div id="alertMessage" class="alert" style="display:none; padding:12px; border-radius:8px; margin-bottom:16px;"><div id="alertText"></div></div>

    <div style="margin-bottom:12px; display:flex; gap:8px;">
      <input id="userSearch" class="form-control" placeholder="Search by email or name..." style="flex:1;"/>
      <button class="btn btn-primary" onclick="searchUsers()">Search</button>
    </div>

    <table class="table" style="width:100%; border-collapse:collapse;">
      <thead>
        <tr>
          <th style="text-align:left; padding:10px; border-bottom:1px solid #e9ecef;">ID</th>
          <th style="text-align:left; padding:10px; border-bottom:1px solid #e9ecef;">Name</th>
          <th style="text-align:left; padding:10px; border-bottom:1px solid #e9ecef;">Email</th>
          <th style="text-align:left; padding:10px; border-bottom:1px solid #e9ecef;">Role</th>
        </tr>
      </thead>
      <tbody id="usersTbody"></tbody>
    </table>
  </div>

  <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
  <script>
    const API_BASE_URL = window.APP_CONTEXT || '${pageContext.request.contextPath}';
    let authToken = localStorage.getItem('token');
    let userRole = localStorage.getItem('userRole');

    if (!authToken || userRole !== 'ADMIN') {
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

    function renderUsers(users) {
    	  const tbody = document.getElementById('usersTbody');
    	  tbody.innerHTML = '';

    	  if (!users || users.length === 0) {
    	    const tr = document.createElement('tr');
    	    const td = document.createElement('td');
    	    td.colSpan = 4;
    	    td.textContent = 'No users found.';
    	    td.style.padding = '10px';
    	    tr.appendChild(td);
    	    tbody.appendChild(tr);
    	    return;
    	  }

    	  users.forEach(u => {
    	    const tr = document.createElement('tr');

    	    // Create and append <td> elements safely (no innerHTML)
    	    const idTd = document.createElement('td');
    	    idTd.textContent = u.id;
    	    idTd.style.padding = '10px';
    	    idTd.style.borderBottom = '1px solid #e9ecef';

    	    const nameTd = document.createElement('td');
    	    nameTd.textContent = u.name || '';
    	    nameTd.style.padding = '10px';
    	    nameTd.style.borderBottom = '1px solid #e9ecef';

    	    const emailTd = document.createElement('td');
    	    emailTd.textContent = u.email || '';
    	    emailTd.style.padding = '10px';
    	    emailTd.style.borderBottom = '1px solid #e9ecef';

    	    const roleTd = document.createElement('td');
    	    roleTd.textContent = u.role || '';
    	    roleTd.style.padding = '10px';
    	    roleTd.style.borderBottom = '1px solid #e9ecef';

    	    // Append all tds to tr
    	    tr.appendChild(idTd);
    	    tr.appendChild(nameTd);
    	    tr.appendChild(emailTd);
    	    tr.appendChild(roleTd);

    	    // Append the row
    	    tbody.appendChild(tr);
    	  });
    	}



    function loadUsers(){
      $.ajax({
        url: API_BASE_URL + '/users',
        method: 'GET',
        headers: { 'Authorization': 'Bearer ' + authToken },
        success: function(data){ renderUsers(data); },
        error: function(){ showAlert('Failed to load users', 'error'); }
      });
    }

    function searchUsers(){
      const q = document.getElementById('userSearch').value.trim();
      if (!q) { loadUsers(); return; }
      // If a search endpoint exists, call it. Otherwise, client-filter after load
      $.ajax({
        url: API_BASE_URL + '/users',
        method: 'GET',
        headers: { 'Authorization': 'Bearer ' + authToken },
        success: function(data){
          const list = (data || []).filter(u => (u.email||'').toLowerCase().includes(q.toLowerCase()) || (u.name||'').toLowerCase().includes(q.toLowerCase()));
          renderUsers(list);
        },
        error: function(){ showAlert('Search failed', 'error'); }
      });
    }

    $(document).ready(function(){ loadUsers(); });
  </script>
</body>
</html>


