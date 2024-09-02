<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection, java.sql.DriverManager, java.sql.ResultSet, java.sql.Statement" %>
<%@ page import="java.util.ArrayList" %>

<%
    // Database connection parameters
    String url = "jdbc:mysql://localhost:3306/denty"; // Replace with your database URL
    String username = "root"; // Replace with your MySQL username
    String password = ""; // Replace with your MySQL password

    Connection conn = null;
    Statement stmt = null;
    ResultSet rs = null;
    ArrayList<String[]> patients = new ArrayList<>();

    try {
        // Load the MySQL JDBC driver
        Class.forName("com.mysql.cj.jdbc.Driver");

        // Establish the connection
        conn = DriverManager.getConnection(url, username, password);

        // Create a statement to execute SQL queries
        stmt = conn.createStatement();

        // Execute the query to retrieve patients
        String sql = "SELECT id, name, age, gender, phoneno, blood FROM patient";
        rs = stmt.executeQuery(sql);

        // Process the result set and store it in an ArrayList
        while (rs.next()) {
            String[] patient = new String[6];
            patient[0] = rs.getString("id");
            patient[1] = rs.getString("name");
            patient[2] = rs.getString("age");
            patient[3] = rs.getString("gender");
            patient[4] = rs.getString("phoneno");
            patient[5] = rs.getString("blood");
            patients.add(patient);
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        try {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Patients</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="admin.css"> <!-- Link to the external CSS file -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css"> <!-- Font Awesome for icons -->
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
                <a href="#" class="nav-link">
                    <i class="fas fa-calendar-alt"></i> <span>Appointments</span>
                </a>
            </li>
            <li class="nav-item">
                <a href="#" class="nav-link">
                    <i class="fas fa-file-invoice-dollar"></i> <span>Payments</span>
                </a>
            </li>
            <!-- Add the Logout Button -->
            <li class="nav-item">
                <a href="LogoutServlet" class="nav-link">
                    <i class="fas fa-sign-out-alt"></i> <span>Logout</span>
                </a>
            </li>
        </ul>
    </nav>
    <!-- Main Content -->
    <div class="container">
        <h1 class="text-center">Patients</h1>

        <!-- Add New Patient Button -->
        <div class="mb-3 text-right">
            <button class="btn btn-success" onclick="openAddModal()">
                <i class="fas fa-user-plus"></i> Add New Patient
            </button>
        </div>

        <div class="table-container table-responsive">
            <table class="table table-striped table-bordered table-hover">
                <thead class="thead-light">
                    <tr>
                        <th scope="col">ID</th>
                        <th scope="col">Patient Name</th>
                        <th scope="col">Age</th>
                        <th scope="col">Gender</th>
                        <th scope="col">Phone Number</th>
                        <th scope="col">Blood Group</th>
                        <th scope="col">Action</th>
                    </tr>
                </thead>
                <tbody>
                    <!-- Iterate through patients list -->
                    <%
                        for (int i = 0; i < patients.size(); i++) {
                            String[] patient = patients.get(i);
                    %>
                    <tr class="table-info">
                        <td><%= patient[0] %></td>
                        <td><%= patient[1] %></td>
                        <td><%= patient[2] %></td>
                        <td><%= patient[3] %></td>
                        <td><%= patient[4] %></td>
                        <td><%= patient[5] %></td>
                        <td>
                            <button class="btn btn-sm btn-primary" onclick="openEditModal('<%= patient[0] %>', '<%= patient[1] %>', '<%= patient[2] %>', '<%= patient[3] %>', '<%= patient[4] %>', '<%= patient[5] %>')">Edit</button>
                            <button class="btn btn-sm btn-danger" onclick="deletePatient('<%= patient[0] %>')">Delete</button>
                        </td>
                    </tr>
                    <%
                        }
                    %>
                </tbody>
            </table>
        </div>
    </div>

    <!-- Edit Patient Modal -->
    <div class="modal fade" id="editPatientModal" tabindex="-1" role="dialog" aria-labelledby="editPatientModalLabel" aria-hidden="true">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="editPatientModalLabel">Edit Patient</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <form action="EditPatients" method="post">
                    <div class="modal-body">
                        <input type="hidden" id="editId" name="id">
                        <div class="form-group">
                            <label for="editName">Name:</label>
                            <input type="text" class="form-control" id="editName" name="name" required>
                        </div>
                        <div class="form-group">
                            <label for="editAge">Age:</label>
                            <input type="text" class="form-control" id="editAge" name="age" required>
                        </div>
                        <div class="form-group">
                            <label for="editGender">Gender:</label>
                            <select class="form-control" id="editGender" name="gender" required>
                                <option value="Male">Male</option>
                                <option value="Female">Female</option>
                                <option value="Other">Other</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="editPhoneNumber">Phone Number:</label>
                            <input type="text" class="form-control" id="editPhoneNumber" name="phoneno" required>
                        </div>
                        <div class="form-group">
                            <label for="editBloodGroup">Blood Group:</label>
                            <select class="form-control" id="editBloodGroup" name="blood" required>
                                <option value="A+">A+</option>
                                <option value="A-">A-</option>
                                <option value="B+">B+</option>
                                <option value="B-">B-</option>
                                <option value="AB+">AB+</option>
                                <option value="AB-">AB-</option>
                                <option value="O+">O+</option>
                                <option value="O-">O-</option>
                            </select>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                        <button type="submit" class="btn btn-primary">Save changes</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Add New Patient Modal -->
    <div class="modal fade" id="addPatientModal" tabindex="-1" role="dialog" aria-labelledby="addPatientModalLabel" aria-hidden="true">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="addPatientModalLabel">Add New Patient</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <form action="AddPatientServlet" method="post">
                    <div class="modal-body">
                        <div class="form-group">
                            <label for="addName">Name:</label>
                            <input type="text" class="form-control" id="addName" name="name" required>
                        </div>
                        <div class="form-group">
                            <label for="addAge">Age:</label>
                            <input type="text" class="form-control" id="addAge" name="age" required>
                        </div>
                        <div class="form-group">
                            <label for="addGender">Gender:</label>
                            <select class="form-control" id="addGender" name="gender" required>
                                <option value="Male">Male</option>
                                <option value="Female">Female</option>
                                <option value="Other">Other</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="addPhoneNumber">Phone Number:</label>
                            <input type="text" class="form-control" id="addPhoneNumber" name="phoneno" required>
                        </div>
                        <div class="form-group">
                            <label for="addBloodGroup">Blood Group:</label>
                            <select class="form-control" id="addBloodGroup" name="blood" required>
                                <option value="A+">A+</option>
                                <option value="A-">A-</option>
                                <option value="B+">B+</option>
                                <option value="B-">B-</option>
                                <option value="AB+">AB+</option>
                                <option value="AB-">AB-</option>
                                <option value="O+">O+</option>
                                <option value="O-">O-</option>
                            </select>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                        <button type="submit" class="btn btn-primary">Add Patient</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/jquery@3.5.1/dist/jquery.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // JavaScript to handle the navbar toggle
        document.getElementById('navbarToggle').addEventListener('click', function() {
            document.getElementById('navbarContent').classList.toggle('collapsed');
            document.querySelector('.content').classList.toggle('collapsed');
        });
        function openEditModal(id, name, age, gender, phoneno, blood) {
            document.getElementById('editId').value = id;
            document.getElementById('editName').value = name;
            document.getElementById('editAge').value = age;
            document.getElementById('editGender').value = gender;
            document.getElementById('editPhoneNumber').value = phoneno;
            document.getElementById('editBloodGroup').value = blood;
            $('#editPatientModal').modal('show');
        }

        function openAddModal() {
            // Clear the form fields for adding a new patient
            document.getElementById('addName').value = '';
            document.getElementById('addAge').value = '';
            document.getElementById('addGender').value = 'Male';
            document.getElementById('addPhoneNumber').value = '';
            document.getElementById('addBloodGroup').value = 'A+';
            $('#addPatientModal').modal('show');
        }

        function deletePatient(id) {
            if (confirm('Are you sure you want to delete this patient?')) {
                window.location.href = 'DeletePatientServlet?id=' + id;
            }
        }
    </script>
</body>
</html>
