<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>

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

    // Example of initializing some session or data
    if (session.getAttribute("username") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Current page for active link highlighting
    String currentPage = request.getRequestURI();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        /* Global Styles */
body {
    margin: 0;
    padding: 0;
    font-family: 'Roboto', sans-serif;
    background-color: #f4f6f9;
    transition: margin-left 0.3s ease;
    overflow-x: hidden;
}

/* Navbar Styles */
.navbar {
    position: fixed;
    top: 0;
    left: 0;
    width: 220px;
    height: 100vh;
    background: linear-gradient(180deg, #007bff, #17a2b8);
    padding-top: 60px;
    box-shadow: 2px 0 5px rgba(0, 0, 0, 0.2);
    z-index: 1000;
    display: flex;
    flex-direction: column;
    justify-content: flex-start;
    transition: width 0.3s ease;
}

.navbar.collapsed {
    width: 60px;
}

.navbar.collapsed .nav-link span {
    display: none;
}

.navbar.collapsed .nav-link {
    justify-content: center;
}

.navbar-toggler {
    position: fixed;
    top: 10px;
    left: 10px;
    z-index: 1030;
    border: none;
}

.navbar-toggler-icon {
    background-image: url("data:image/svg+xml,%3csvg viewBox='0 0 30 30' xmlns='http://www.w3.org/2000/svg'%3e%3cpath stroke='white' stroke-width='2' stroke-linecap='round' stroke-miterlimit='10' d='M4 7h22M4 15h22M4 23h22'/%3e%3c/svg%3e");
}

.navbar-nav {
    width: 100%;
    display: flex;
    flex-direction: column;
    padding-left: 0;
}

.nav-item {
    width: 100%;
}

.nav-link {
    color: white !important;
    font-size: 16px;
    transition: all 0.3s ease-in-out;
    display: flex;
    align-items: center;
    padding: 15px 20px;
    border-radius: 30px 0 0 30px;
    margin-bottom: 5px;
}

.nav-link i {
    font-size: 20px;
    width: 40px;
    text-align: center;
}

.nav-link span {
    white-space: nowrap;
}

.nav-link:hover {
    background-color: rgba(255, 255, 255, 0.2);
    color: #ffcc00 !important;
}

.nav-link.active {
    background-color: rgba(255, 255, 255, 0.3);
}

.navbar.collapsed + .content {
    margin-left: 60px;
    width: calc(100% - 60px);
}

h2 {
    color: #343a40;
    font-weight: 700;
    margin-bottom: 30px;
}

h3 {
    color: #007bff;
    font-weight: 600;
    margin-top: 30px;
    margin-bottom: 20px;
}

/* Responsive Styles */
@media (max-width: 768px) {
    .navbar {
        width: 60px;
    }

    .navbar.collapsed {
        width: 100%;
        height: 60px;
        flex-direction: row;
        padding-top: 0;
    }

    .navbar.collapsed .navbar-nav {
        flex-direction: row;
        justify-content: space-around;
        align-items: center;
    }

    .navbar.collapsed .nav-link {
        justify-content: center;
        padding: 10px;
        margin: 0;
    }

    .navbar.collapsed + .content {
        margin-left: 0;
        width: 100%;
    }
}

/* Additional Modal and Button Styles */
.modal-content {
    border-radius: 15px;
}

.btn-primary {
    border-radius: 30px;
}

.btn-close {
    color: black;
}

    </style>
    <!-- Font Awesome for icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
</head>
<body>

    <!-- Hamburger Menu Button -->
    <button class="navbar-toggler" type="button" id="navbarToggle">
        <span class="navbar-toggler-icon"></span>
    </button>

    <!-- Collapsible Navbar -->
    <nav class="navbar navbar-expand-md navbar-dark flex-column" id="navbarContent">
        <ul class="navbar-nav flex-column">
            <li class="nav-item">
                <a href="dashboard.jsp" class="nav-link <%=(currentPage.contains("dashboard.jsp") ? "active" : "")%>">
                    <i class="fas fa-tachometer-alt"></i> <span>Dashboard</span>
                </a>
            </li>
            <li class="nav-item">
                <a href="patients.jsp" class="nav-link <%=(currentPage.contains("patients.jsp") ? "active" : "")%>">
                    <i class="fas fa-user-injured"></i> <span>Patients</span>
                </a>
            </li>
            <li class="nav-item">
                <a href="appointments.jsp" class="nav-link <%=(currentPage.contains("appointments.jsp") ? "active" : "")%>">
                    <i class="fas fa-calendar-alt"></i> <span>Appointments</span>
                </a>
            </li>
            <li class="nav-item">
                <a href="#" class="nav-link <%=(currentPage.contains("payments.jsp") ? "active" : "")%>">
                    <i class="fas fa-file-invoice-dollar"></i> <span>Payments</span>
                </a>
            </li>
            <li class="nav-item">
                <a href="reports.jsp" class="nav-link <%=(currentPage.contains("reports.jsp") ? "active" : "")%>">
                    <i class="fas fa-file-alt"></i> <span>Reports</span>
                </a>
            </li>
            <li class="nav-item">
                <a href="LogoutServlet" class="nav-link">
                    <i class="fas fa-sign-out-alt"></i> <span>Logout</span>
                </a>
            </li>
        </ul>
    </nav>

    <script>
        // JavaScript to handle the navbar toggle
        document.getElementById('navbarToggle').addEventListener('click', function() {
            document.getElementById('navbarContent').classList.toggle('collapsed');
            document.querySelector('.content').classList.toggle('collapsed');
        });
    </script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
