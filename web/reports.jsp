<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="navbar.jsp" %>
<%@ page import="java.sql.Connection, java.sql.DriverManager, java.sql.ResultSet, java.sql.Statement" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page import="java.net.URLEncoder" %>
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

    // Get search query from request
    String searchQuery = request.getParameter("searchQuery") != null ? request.getParameter("searchQuery") : "";

    // Database connection details
    String url = "jdbc:mysql://localhost:3306/denty"; // Update your database URL
    String username = "root"; // Update your DB username
    String password = ""; // Update your DB password

    Connection conn = null;
    Statement stmt = null;
    ResultSet rs = null;
    ArrayList<String[]> patients = new ArrayList<>();
    ArrayList<String[]> reports = new ArrayList<>();

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(url, username, password);
        stmt = conn.createStatement();

        // Query for searching patients
        String sql = "SELECT id, name, phoneno, age, gender FROM patient";
        if (!searchQuery.isEmpty()) {
            sql += " WHERE id LIKE '%" + searchQuery + "%' OR name LIKE '%" + searchQuery + "%' OR phoneno LIKE '%" + searchQuery + "%'";
        }
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

        // Query for fetching reports for a selected patient
        String selectedPatientId = request.getParameter("selectedPatientId") != null ? request.getParameter("selectedPatientId") : "";
        if (!selectedPatientId.isEmpty()) {
            String reportSql = "SELECT report_id, report_name, file_path FROM patient_reports WHERE patient_id = '" + selectedPatientId + "'";
            rs = stmt.executeQuery(reportSql);
            while (rs.next()) {
                String[] report = new String[3];
                report[0] = rs.getString("report_id");
                report[1] = rs.getString("report_name");
                report[2] = rs.getString("file_path");
                reports.add(report);
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (rs != null) rs.close();
        if (stmt != null) stmt.close();
        if (conn != null) conn.close();
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reports - Denty</title>
    <link rel="stylesheet" href="admin.css">
    <style>
        .content {
            margin: 50px auto;
            max-width: 1050px;
            padding: 20px;
        }

        .table-container {
            margin-top: 30px;
        }

        .form-inline {
            display: flex;
            justify-content: center;
            margin-bottom: 20px;
        }

        .form-inline input {
            width: 300px;
            margin-right: 10px;
        }

        .btn-primary, .btn-success, .btn-danger {
            border-radius: 30px;
            padding: 10px 20px;
        }

        .btn-close {
            color: black;
        }

        .modal-content {
            border-radius: 15px;
        }
    </style>
</head>
<body>
    <!-- Main Content -->
    <div class="content">
        <h1 class="text-center">Reports</h1>
        <p class="text-center">Search and view patient reports, or upload new reports for patients.</p>

        <!-- Search Form -->
        <form method="get" action="reports.jsp" class="form-inline">
            <input type="text" class="form-control" name="searchQuery" placeholder="Search by ID, Name, or Phone" value="<%= searchQuery %>">
            <button type="submit" class="btn btn-primary">Search</button>
        </form>

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
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (int i = 0; i < patients.size(); i++) { String[] patient = patients.get(i); %>
                    <tr class="table-info">
                        <td><%= patient[0] %></td>
                        <td><%= patient[1] %></td>
                        <td><%= patient[2] %></td>
                        <td><%= patient[3] %></td>
                        <td><%= patient[4] %></td>
                        <td>
                            <button class="btn btn-sm btn-success" onclick="openAddReportModal('<%= patient[0] %>', '<%= patient[1] %>')">Add Report</button>
                            <form method="get" action="reports.jsp" style="display:inline;">
                                <input type="hidden" name="selectedPatientId" value="<%= patient[0] %>">
                                <button type="submit" class="btn btn-sm btn-primary">View Reports</button>
                            </form>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>

        <!-- View Reports Table -->
        <div class="table-container" style="margin-top: 50px;">
            <h3>Reports for Patient ID: <%= request.getParameter("selectedPatientId") != null ? request.getParameter("selectedPatientId") : "None Selected" %></h3>
            <table class="table table-striped table-bordered table-hover">
                <thead class="thead-light">
                    <tr>
                        <th>Report ID</th>
                        <th>Report Name</th>
                        <th>File Path</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (!reports.isEmpty()) { 
                        for (String[] report : reports) { %>
                        <tr>
                            <td><%= report[0] %></td>
                            <td><%= report[1] %></td>
                            <td><%= report[2] %></td>
                            <td>
                                <a href="DownloadReportServlet?filePath=<%= URLEncoder.encode(report[2], "UTF-8") %>" target="_blank" class="btn btn-sm btn-primary">Download</a>
                                <form action="DeleteReportServlet" method="post" style="display:inline;">
                                    <input type="hidden" name="filePath" value="<%= URLEncoder.encode(report[2], "UTF-8") %>">
                                    <input type="submit" value="Delete" class="btn btn-sm btn-danger" onclick="return confirm('Are you sure you want to delete this report?');">
                                </form>
                            </td>
                        </tr>
                    <% }
                    } else { %>
                        <tr>
                            <td colspan="4" class="text-center">No reports found for this patient.</td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>

    <!-- Add Report Modal -->
    <div class="modal fade" id="addReportModal" tabindex="-1" aria-labelledby="addReportModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="addReportModalLabel">Add New Report</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form action="AddReportServlet" method="post" enctype="multipart/form-data">
                        <div class="mb-3">
                            <label for="patientId" class="form-label">Patient ID</label>
                            <input type="text" class="form-control" id="patientId" name="patientId" required>
                        </div>
                        <div class="mb-3">
                            <label for="reportName" class="form-label">Report Name</label>
                            <input type="text" class="form-control" id="reportName" name="reportName" required>
                        </div>
                        <div class="mb-3">
                            <label for="reportFile" class="form-label">Upload Report</label>
                            <input type="file" class="form-control" id="reportFile" name="reportFile" required>
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
        function openAddReportModal(patientId, patientName) {
            document.getElementById('patientId').value = patientId;
            document.getElementById('reportName').value = '';
            $('#addReportModal').modal('show'); // Ensure jQuery is loaded
        }

        // Check if the URL contains the success query parameter
        const urlParams = new URLSearchParams(window.location.search);
        if (urlParams.has('success')) {
            alert(urlParams.get('success'));
        }
    </script>
</body>
</html>
