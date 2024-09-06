<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.HttpSession" %>
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
    <title>Dashboard - Denty App</title>
    <link rel="stylesheet" href="admin.css"> <!-- Link to the external CSS file -->
    </head>
<body>
    <!-- Main Content -->
    <div class="content">
        <h1>Welcome to Denty!!!</h1>
        <p>This is the dashboard. Use the navigation on the left to manage patients, appointments, and more.</p>
    </div>
    </body>
</html>