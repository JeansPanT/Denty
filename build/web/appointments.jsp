<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%
    // Database connection setup
    String dbURL = "jdbc:mysql://localhost:3306/denty";
    String dbUser = "root";
    String dbPassword = "";

    // Check if session is valid
    if (session == null || session.getAttribute("username") == null) {
        response.sendRedirect("admin-login.jsp");
        return;
    }

    // Disable caching
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    List<String[]> todayAppointments = new ArrayList<>();
    List<String[]> upcomingAppointments = new ArrayList<>();
    List<String[]> previousAppointments = new ArrayList<>();

    try (Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);
         Statement stmt = conn.createStatement()) {

        // Query to get today's appointments
        String todayQuery = "SELECT * FROM appointments WHERE date = CURDATE()";
        ResultSet rsToday = stmt.executeQuery(todayQuery);
        while (rsToday.next()) {
            todayAppointments.add(new String[]{
                String.valueOf(rsToday.getInt("id")),
                rsToday.getString("name"),
                rsToday.getString("email"),
                rsToday.getString("date"),
                rsToday.getString("timeslot"),
                rsToday.getString("status")
            });
        }

        // Query to get upcoming appointments
        String upcomingQuery = "SELECT * FROM appointments WHERE date > CURDATE()";
        ResultSet rsUpcoming = stmt.executeQuery(upcomingQuery);
        while (rsUpcoming.next()) {
            upcomingAppointments.add(new String[]{
                String.valueOf(rsUpcoming.getInt("id")),
                rsUpcoming.getString("name"),
                rsUpcoming.getString("email"),
                rsUpcoming.getString("date"),
                rsUpcoming.getString("timeslot"),
                rsUpcoming.getString("status")
            });
        }

        // Query to get previous appointments
        String previousQuery = "SELECT * FROM appointments WHERE date < CURDATE()";
        ResultSet rsPrevious = stmt.executeQuery(previousQuery);
        while (rsPrevious.next()) {
            previousAppointments.add(new String[]{
                String.valueOf(rsPrevious.getInt("id")),
                rsPrevious.getString("name"),
                rsPrevious.getString("email"),
                rsPrevious.getString("date"),
                rsPrevious.getString("timeslot"),
                rsPrevious.getString("status")
            });
        }

    } catch (SQLException e) {
        e.printStackTrace();
    }
    

%>


<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Appointments - Denty</title>
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

        .content {
            margin: 50px auto;
            max-width: 1050px;
            padding: 20px;
        }

        .table-container {
            margin: 30px 0;
        }
        
        h2 {
            font-weight: bold;
            text-align: center;
            margin-bottom: 20px;
        }
        
        h3 {
            font-weight: bold;
           
            margin-bottom: 20px;
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

        .table th, .table td {
            padding: 16px 10px;
            vertical-align: middle;
        }

        .table th {
            background-color: #007bff;
            color: white;
            font-weight: 600;
        }

        .btn {
            border-radius: 30px;
            padding: 10px 20px;
        }

        .btn-success:hover {
            background-color: #218838;
        }

        /* Modal Styles */
        .modal-content {
            border-radius: 15px;
        }

        .btn-close {
            color: black;
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

            .content {
                margin-left: 60px;
                width: calc(100% - 60px);
            }

            .navbar.collapsed + .content {
                margin-left: 0;
                width: 100%;
            }
        }
    </style>
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
                <a href="dashboard.jsp" class="nav-link">
                    <i class="fas fa-tachometer-alt"></i> <span>Dashboard</span>
                </a>
            </li>
            <li class="nav-item">
                <a href="patients.jsp" class="nav-link">
                    <i class="fas fa-user-injured"></i> <span>Patients</span>
                </a>
            </li>
            <li class="nav-item">
                <a href="appointments.jsp" class="nav-link active">
                    <i class="fas fa-calendar-alt"></i> <span>Appointments</span>
                </a>
            </li>
            <li class="nav-item">
                <a href="payment.jsp" class="nav-link">
                    <i class="fas fa-file-invoice-dollar"></i> <span>Payments</span>
                </a>
            </li>
            <li class="nav-item">
    <a href="adminFeed.jsp" class="nav-link">
        <i class="fas fa-rss"></i> <span>Feeds</span>
    </a>
</li>
            <li class="nav-item">
                <a href="reports.jsp" class="nav-link">
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

    <!-- Main Content -->
    <div class="content container mt-5">
        <h2 class="text-center mb-4">Appointment Management</h2>
    
     <!-- New Appointment Button -->
<div class="mb-4 text-end">
    <button class="btn btn-success" data-bs-toggle="modal" data-bs-target="#appointmentModal">New Appointment</button>
</div>

    <!-- Today's Appointments -->
    <h3>Today's Appointments</h3>
    <div class="table-container card mb-4">
        <div class="card-body">
            <table class="table table-bordered mb-0">
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Name</th>
                        <th>Email</th>
                        <th>Date</th>
                        <th>Time</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        for (String[] appointment : todayAppointments) {
                    %>
                    <tr>
                        <td><%= appointment[0] %></td>
                        <td><%= appointment[1] %></td>
                        <td><%= appointment[2] %></td>
                        <td><%= appointment[3] %></td>
                        <td><%= appointment[4] %></td>
                        <td><%= appointment[5] %></td>
                        <td>
    <button class="btn btn-warning btn-sm" 
            data-bs-toggle="modal" 
            data-bs-target="#editAppointmentModal"
            data-id="<%= appointment[0] %>"
            data-name="<%= appointment[1] %>"
            data-email="<%= appointment[2] %>"
            data-date="<%= appointment[3] %>"
            data-timeslot="<%= appointment[4] %>"
            data-status="<%= appointment[5] %>">
        Edit
    </button>
    <%
        if (!appointment[5].equals("completed")) { // Show only if the status is not completed
    %>
    <form action="CompleteAppointmentServlet" method="post" style="display:inline;">
        <input type="hidden" name="id" value="<%= appointment[0] %>">
        <button type="submit" class="btn btn-success btn-sm">Completed</button>
    </form>
    <%
        }
    %>
</td>
   
                    </tr>
                    <%
                        }
                    %>
                </tbody>
            </table>
        </div>
    </div>
              

<!-- Upcoming Appointments -->
<h3>Upcoming Appointments</h3>
<div class="table-container card mb-4">
    <div class="card-body">
        <table class="table table-bordered mb-0">
            <thead>
                <tr>
                    <th>#</th>
                    <th>Name</th>
                    <th>Email</th>
                    <th>Date</th>
                    <th>Time</th>
                    <th>Status</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <%
                    for (String[] appointment : upcomingAppointments) {
                %>
                <tr>
                    <td><%= appointment[0] %></td>
                    <td><%= appointment[1] %></td>
                    <td><%= appointment[2] %></td>
                    <td><%= appointment[3] %></td>
                    <td><%= appointment[4] %></td>
                    <td><%= appointment[5] %></td>
                    <td>
    <button class="btn btn-warning btn-sm" 
            data-bs-toggle="modal" 
            data-bs-target="#editAppointmentModal"
            data-id="<%= appointment[0] %>"
            data-name="<%= appointment[1] %>"
            data-email="<%= appointment[2] %>"
            data-date="<%= appointment[3] %>"
            data-timeslot="<%= appointment[4] %>"
            data-status="<%= appointment[5] %>">
        Edit
    </button>
    <%
        if (!appointment[5].equals("completed")) { // Show only if the status is not completed
    %>
    <form action="CompleteAppointmentServlet" method="post" style="display:inline;">
        <input type="hidden" name="id" value="<%= appointment[0] %>">
        <button type="submit" class="btn btn-success btn-sm">Completed</button>
    </form>
    <%
        }
    %>
</td>
    
                </tr>
                <%
                    }
                %>
            </tbody>
        </table>
    </div>
</div>

<!-- Previous Appointments -->
<h3>Previous / Completed Appointments</h3>
<div class="table-container card mb-4">
    <div class="card-body">
        <table class="table table-bordered mb-0">
            <thead>
                <tr>
                    <th>#</th>
                    <th>Name</th>
                    <th>Email</th>
                    <th>Date</th>
                    <th>Time</th>
                    <th>Status</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <%
                    for (String[] appointment : previousAppointments) {
                %>
                <tr>
                    <td><%= appointment[0] %></td>
                    <td><%= appointment[1] %></td>
                    <td><%= appointment[2] %></td>
                    <td><%= appointment[3] %></td>
                    <td><%= appointment[4] %></td>
                    <td><%= appointment[5] %></td>
                    <td>
                        <button class="btn btn-warning btn-sm" 
                                data-bs-toggle="modal" 
                                data-bs-target="#editAppointmentModal"
                                data-id="<%= appointment[0] %>"
                                data-name="<%= appointment[1] %>"
                                data-email="<%= appointment[2] %>"
                                data-date="<%= appointment[3] %>"
                                data-timeslot="<%= appointment[4] %>"
                                data-status="<%= appointment[5] %>">
                            Edit
                        </button>
                        <%
                            if (!appointment[5].equals("completed")) { // This condition might not be necessary here since it's already in "Previous"
                        %>
                        <form action="CompleteAppointmentServlet" method="post" style="display:inline;">
                            <input type="hidden" name="id" value="<%= appointment[0] %>">
                            <button type="submit" class="btn btn-success btn-sm">Mark as Completed</button>
                        </form>
                        <%
                            }
                        %>
                    </td>
                </tr>
                <%
                    }
                %>
            </tbody>
        </table>
    </div>
</div>




<!-- New Appointment Modal -->
<div class="modal fade" id="appointmentModal" tabindex="-1" aria-labelledby="appointmentModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="appointmentModalLabel">New Appointment</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="appointmentForm" method="post" action="Mailer">
                    <input type="hidden" id="appointmentId" name="id">
                    <div class="mb-3">
                        <label for="modalName" class="form-label">Name</label>
                        <input type="text" class="form-control" id="modalName" name="name" required>
                    </div>
                    <div class="mb-3">
                        <label for="modalEmail" class="form-label">Email</label>
                        <input type="email" class="form-control" id="modalEmail" name="email" required>
                    </div>
                    <div class="mb-3">
                        <label for="modalDate" class="form-label">Date</label>
                        <input type="date" class="form-control" id="modalDate" name="date" required>
                    </div>
                    <div class="mb-3">
                        <label for="modalTime" class="form-label">Time</label>
                        <input type="time" class="form-control" id="modalTime" name="timeslot" required>
                    </div>
                    <div class="mb-3">
                        <label for="modalStatus" class="form-label">Status</label>
                        <select class="form-select" id="modalStatus" name="status" required>
                            <option value="upcoming">Upcoming</option>
                            <option value="completed">Completed</option>
                            <option value="cancelled">Cancelled</option>
                        </select>
                    </div>
                    <button type="submit" class="btn btn-primary">Save Appointment</button>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- Edit Appointment Modal -->
<div class="modal fade" id="editAppointmentModal" tabindex="-1" aria-labelledby="editAppointmentModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="editAppointmentModalLabel">Edit Appointment</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="editAppointmentForm" method="post" action="UpdateAppointmentServlet">
                    <input type="hidden" id="editAppointmentId" name="id">
                    <div class="mb-3">
                        <label for="editModalName" class="form-label">Name</label>
                        <input type="text" class="form-control" id="editModalName" name="name" required readonly>
                    </div>
                    <div class="mb-3">
                        <label for="editModalEmail" class="form-label">Email</label>
                        <input type="email" class="form-control" id="editModalEmail" name="email" required readonly>
                    </div>
                    <div class="mb-3">
                        <label for="editModalDate" class="form-label">Date</label>
                        <input type="date" class="form-control" id="editModalDate" name="date" required>
                    </div>
                    <div class="mb-3">
                        <label for="editModalTime" class="form-label">Time</label>
                        <input type="time" class="form-control" id="editModalTime" name="timeslot" required>
                    </div>
                    <div class="mb-3">
                        <label for="editModalStatus" class="form-label">Status</label>
                        <select class="form-select" id="editModalStatus" name="status" required>
                            <option value="upcoming">Upcoming</option>
                            <option value="completed">Completed</option>
                            <option value="cancelled">Cancelled</option>
                        </select>
                    </div>
                    <button type="submit" class="btn btn-primary">Update Appointment</button>
                </form>
            </div>
        </div>
    </div>
</div>


<script>
    // JavaScript to prefill the edit modal
    var editButtons = document.querySelectorAll('button[data-bs-target="#editAppointmentModal"]');
    editButtons.forEach(function(button) {
        button.addEventListener('click', function() {
            document.getElementById('editAppointmentId').value = button.getAttribute('data-id');
            document.getElementById('editModalName').value = button.getAttribute('data-name');
            document.getElementById('editModalEmail').value = button.getAttribute('data-email');
            document.getElementById('editModalDate').value = button.getAttribute('data-date');
            document.getElementById('editModalTime').value = button.getAttribute('data-timeslot');
            document.getElementById('editModalStatus').value = button.getAttribute('data-status');
        });
    });
</script>
<script>
        window.onload = function() {
            const urlParams = new URLSearchParams(window.location.search);
            if (urlParams.get('success') === 'true') {
                alert('Appointment has been updated succesfully!');
            }
        };
 </script>

    <script>
        // JavaScript to handle the navbar toggle and modal prefill
        document.getElementById('navbarToggle').addEventListener('click', function() {
            document.getElementById('navbarContent').classList.toggle('collapsed');
            document.querySelector('.content').classList.toggle('collapsed');
        });
    </script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.min.js"></script>

</body>
</html>
