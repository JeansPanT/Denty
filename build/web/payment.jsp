<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="navbar.jsp" %>
<%@ page import="java.sql.Connection, java.sql.DriverManager, java.sql.ResultSet, java.sql.Statement" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
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

    // Database connection details
    String url = "jdbc:mysql://localhost:3306/denty"; 
    String username = "root"; 
    String password = ""; 

    Connection conn = null;
    Statement stmt = null;
    ResultSet rs = null;
    List<String[]> patients = new ArrayList<>();

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(url, username, password);
        stmt = conn.createStatement();

        // Query for fetching patients
        String sql = "SELECT id, name, phoneno, age, gender FROM patient";
        rs = stmt.executeQuery(sql);
        while (rs.next()) {
            String[] patient = new String[5];
            patient[0] = rs.getString("id");
            patient[1] = rs.getString("name");
            patient[2] = rs.getString("phoneno");
            patient[3] = rs.getString("age");
            patient[4] = rs.getString("gender");
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
    <title>Payments - Denty</title>
    <link rel="stylesheet" href="admin.css">
    <style>
        .content {
            margin: 50px auto;
            max-width: 1200px;
            padding: 20px;
        }
        .table-container {
            margin-top: 30px;
        }
        .btn-primary, .btn-success, .btn-danger {
            border-radius: 30px;
            padding: 10px 20px;
        }
        .modal-content {
            border-radius: 15px;
        }
    </style>
</head>
<body>
    <!-- Main Content -->
    <div class="content">
        <h1 class="text-center">Payments</h1>
        <p class="text-center">Manage patient payments and generate invoices.</p>

        <!-- Table of Patients -->
        <div class="table-container">
            <table class="table table-striped table-bordered table-hover">
                <thead class="thead-light">
                    <tr>
                        <th>ID</th>
                        <th>Name</th>
                        <th>Phone Number</th>
                        <th>Age</th>
                        <th>Gender</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (String[] patient : patients) { %>
                    <tr class="table-info">
                        <td><%= patient[0] %></td>
                        <td><%= patient[1] %></td>
                        <td><%= patient[2] %></td>
                        <td><%= patient[3] %></td>
                        <td><%= patient[4] %></td>
                        <td>
                            <button class="btn btn-primary btn-sm" 
                                    onclick="openInvoiceModal('<%= patient[0] %>', '<%= patient[1] %>')">
                                Add Invoice
                            </button>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>

    <!-- Add Invoice Modal -->
    <div class="modal fade" id="addInvoiceModal" tabindex="-1" aria-labelledby="addInvoiceModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="addInvoiceModalLabel">Add New Invoice</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form action="GenerateInvoiceServlet" method="post" enctype="multipart/form-data">
                        <div class="mb-3">
                            <label for="patientId" class="form-label">Patient ID</label>
                            <input type="text" class="form-control" id="patientId" name="patientId" required readonly>
                        </div>
                        <div class="mb-3">
                            <label for="invoiceAmount" class="form-label">Invoice Amount</label>
                            <input type="number" class="form-control" id="invoiceAmount" name="invoiceAmount" required>
                        </div>
                        <div class="mb-3">
                            <label for="invoiceDescription" class="form-label">Description</label>
                            <textarea class="form-control" id="invoiceDescription" name="invoiceDescription" required></textarea>
                        </div>
                        <button type="submit" class="btn btn-primary">Submit</button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.min.js"></script>
    <script>
        function openInvoiceModal(patientId, patientName) {
            document.getElementById('patientId').value = patientId; // Set the Patient ID
            console.log("Patient ID set to: " + patientId); // Debugging line
            $('#addInvoiceModal').modal('show'); // Show the modal
        }
    </script>
</body>
</html>
