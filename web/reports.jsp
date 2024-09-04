<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="navbar.jsp" %>
<%
    // Check if session is valid
    if (session == null || session.getAttribute("username") == null) {
        response.sendRedirect("admin-login.jsp");
        return;
    }

    // Disable caching
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); // HTTP 1.1
    response.setHeader("Pragma", "no-cache"); // HTTP 1.0
    response.setDateHeader("Expires", 0); // Proxies
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reports</title>
    
    <link rel="stylesheet" href="admin.css"> <!-- Link to your external CSS file -->
 
</head>
<body>
    <!-- Main Content -->
    <div class="content">
        <h1>Reports</h1>
        <p>Here you can view and generate various reports.</p>
        <!-- Add your report content here -->
    </div>
    <script>
    // JavaScript to handle the navbar toggle
    document.getElementById('navbarToggle').addEventListener('click', function() {
        document.getElementById('navbarContent').classList.toggle('collapsed');
        document.querySelector('.content').classList.toggle('collapsed');
    });
</script>

</body>
</html>
