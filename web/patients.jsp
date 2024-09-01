<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.HttpSession" %>
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
    <title>Patients</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css" integrity="sha384-xOolHFLEh07PJGoPkLv1IbcEPTNtaed2xpHsD9ESMhqIYd0nLMwNLD69Npy4HI+N" crossorigin="anonymous">
    <link rel="stylesheet" href="admin.css"> <!-- Link to the external CSS file -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css"> <!-- Font Awesome for icons -->
</head>
<body>
    <!-- Hamburger Menu Button -->
    <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarContent" aria-controls="navbarContent" aria-expanded="false" aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
    </button>

    <!-- Collapsible Navbar -->
    <div class="collapse" id="navbarContent">
        <nav class="navbar navbar-expand-md navbar-dark flex-column">
            <ul class="navbar-nav flex-column">
                <li class="nav-item">
                    <a href="dashboard.jsp" class="nav-link">
                        <i class="fas fa-tachometer-alt"></i> Dashboard
                    </a>
                </li>
                <li class="nav-item">
                    <a href="patients.jsp" class="nav-link active">
                        <i class="fas fa-user-injured"></i> Patients
                    </a>
                </li>
                <li class="nav-item">
                    <a href="#" class="nav-link">
                        <i class="fas fa-calendar-alt"></i> Appointments
                    </a>
                </li>
                <li class="nav-item">
                    <a href="#" class="nav-link">
                        <i class="fas fa-file-invoice-dollar"></i> Payments
                    </a>
                </li>
                <!-- Logout Button -->
                <li class="nav-item">
                    <a href="LogoutServlet" class="nav-link">
                        <i class="fas fa-sign-out-alt"></i> Logout
                    </a>
                </li>
            </ul>
        </nav>
    </div>

    <!-- Main Content -->
    <div class="container">
        <h1 class="text-center">Patients</h1>
        <div class="table-container table-responsive">
            <div class="card-deck">
                <div class="card">
                    <div class="card-body">
                        <h5 class="card-title">Today Patients</h5>
                        <p class="card-text">10</p>
                        <a href="#" class="btn btn-info">Refresh</a>
                    </div>
                </div>
                <div class="card">
                    <div class="card-body">
                        <h5 class="card-title">Monthly Patients</h5>
                        <p class="card-text">65</p>
                        <a href="#" class="btn btn-info">View Details</a>
                    </div>
                </div>
                <div class="card">
                    <div class="card-body">
                        <h5 class="card-title">Yearly Patients</h5>
                        <p class="card-text">240</p>
                        <a href="#" class="btn btn-info">Go somewhere</a>
                    </div>
                </div>
            </div>
            <table class="table table-striped table-bordered table-hover">
                <thead class="thead-light">
                    <tr>
                        <th scope="col">#</th>
                        <th scope="col">Patient Name</th>
                        <th scope="col">Age</th>
                        <th scope="col">Gender</th>
                        <th scope="col">Phone Number</th>
                        <th scope="col">Blood Group</th>
                        <th scope="col">Action</th>
                    </tr>
                </thead>
                <tbody>
                    <tr class="table-info">
                        <td>1</td>
                        <td>John Doe</td>
                        <td>45</td>
                        <td>Male</td>
                        <td>(123) 456-7890</td>
                        <td>A</td>
                        <td><a href="#" class="btn btn-sm btn-primary">Edit</a></td>
                    </tr>
                    <tr class="table-info">
                        <td>2</td>
                        <td>Bicchu</td>
                        <td>38</td>
                        <td>Female</td>
                        <td>(987) 654-3210</td>
                        <td>B</td>
                        <td><a href="#" class="btn btn-sm btn-primary">Edit</a></td>
                    </tr>
                    <tr class="table-info">
                        <td>3</td>
                        <td>Robert Johnson</td>
                        <td>29</td>
                        <td>Male</td>
                        <td>(555) 123-4567</td>
                        <td>C</td>
                        <td><a href="#" class="btn btn-sm btn-primary">Edit</a></td>
                    </tr>
                    <!-- Add more patient rows as needed -->
                </tbody>
            </table>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/jquery@3.5.1/dist/jquery.slim.min.js" integrity="sha384-DfXdz2htPH0lsSSs5nCTpuj/zy4C+OGpamoFVy38MVBnE+IbbVYUew+OrCXaRkfj" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-Fy6S3B9q64WdZWQUiU+q4/2Lc9npb8tCaSX9FK7E8HnRr0Jz8D6OP9dO5Vg3Q9ct" crossorigin="anonymous"></script>
    <script>
    // Function to toggle sidebar and adjust table size
    $('.navbar-toggler').on('click', function() {
        $('.navbar').toggleClass('collapsed');
        $('.content').toggleClass('collapsed');

        if ($('.navbar').hasClass('collapsed')) {
            $('.table-container').removeClass('expanded').addClass('collapsed');
        } else {
            $('.table-container').removeClass('collapsed').addClass('expanded');
        }
    });

    // Initialize the table size based on the current state of the sidebar
    $(document).ready(function() {
        if ($('.navbar').hasClass('collapsed')) {
            $('.table-container').addClass('collapsed');
        } else {
            $('.table-container').addClass('expanded');
        }
    });
</script>

</body>
</html>
