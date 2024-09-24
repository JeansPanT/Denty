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
    <title>Dashboard - Denty</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    
    <style>
        body {
            background-color: #f8f9fa;
        }
        .card {
            transition: transform 0.2s, box-shadow 0.2s;
        }
        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
        }
        .card-title {
            font-weight: bold;
        }
        .card-text {
            font-size: 0.9em;
        }
    </style>
</head>
<body>
    <div class="content container mt-5">
        <h1 class="text-center">Welcome to Denty App v1.0 BETA</h1>
        <p class="text-center">This is your dashboard. Use the navigation cards below to manage various aspects.</p>

        <!-- Quick Access Cards -->
        <div class="row text-center">
            <div class="col-md-4 mb-4">
                <div class="card text-white bg-primary">
                    <div class="card-body">
                        <i class="fas fa-user-injured fa-3x"></i>
                        <h5 class="card-title">Manage Patients</h5>
                        <p class="card-text">View and manage patient records.</p>
                        <a href="patients.jsp" class="btn btn-light">Go to Patients</a>
                    </div>
                </div>
            </div>
            <div class="col-md-4 mb-4">
                <div class="card text-white bg-success">
                    <div class="card-body">
                        <i class="fas fa-calendar-alt fa-3x"></i>
                        <h5 class="card-title">Manage Appointments</h5>
                        <p class="card-text">Schedule and manage appointments.</p>
                        <a href="appointments.jsp" class="btn btn-light">Go to Appointments</a>
                    </div>
                </div>
            </div>
            <div class="col-md-4 mb-4">
                <div class="card text-white bg-warning">
                    <div class="card-body">
                        <i class="fas fa-money-check-alt fa-3x"></i>
                        <h5 class="card-title">Manage Payments</h5>
                        <p class="card-text">Process and view payment details.</p>
                        <a href="payments.jsp" class="btn btn-light">Go to Payments</a>
                    </div>
                </div>
            </div>
            <div class="col-md-4 mb-4">
                <div class="card text-white bg-info">
                    <div class="card-body">
                        <i class="fas fa-comments fa-3x"></i> <!-- Updated icon for Manage Feeds -->
                        <h5 class="card-title">Manage Feeds</h5>
                        <p class="card-text">View and manage feed updates.</p>
                        <a href="adminFeed.jsp" class="btn btn-light">Go to Feeds</a>
                    </div>
                </div>
            </div>
            <div class="col-md-4 mb-4">
                <div class="card text-white bg-danger">
                    <div class="card-body">
                        <i class="fas fa-file-alt fa-3x"></i>
                        <h5 class="card-title">Generate Reports</h5>
                        <p class="card-text">Create and download reports.</p>
                        <a href="reports.jsp" class="btn btn-light">Go to Reports</a>
                    </div>
                </div>
            </div>
            <div class="col-md-4 mb-4">
                <div class="card text-white bg-secondary">
                    <div class="card-body">
                        <i class="fas fa-sign-out-alt fa-3x"></i>
                        <h5 class="card-title">Logout</h5>
                        <p class="card-text">End your session securely.</p>
                        <a href="LogoutServlet" class="btn btn-light">Logout</a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS (optional) -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
