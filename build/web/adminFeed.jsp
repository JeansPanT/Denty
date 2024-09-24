<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="navbar.jsp" %>
<%@ page import="java.util.ArrayList, java.util.List" %>
<%@ page import="java.sql.Connection, java.sql.DriverManager, java.sql.ResultSet, java.sql.Statement" %>

<%
    // Check session
    if (session == null || session.getAttribute("username") == null) {
        response.sendRedirect("admin-login.jsp");
        return;
    }

    // Disable caching
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    // Database connection
    Connection conn = null;
    Statement stmt = null;
    ResultSet rs = null;
    List<String[]> posts = new ArrayList<>();
    List<String[]> feedbacks = new ArrayList<>();
    
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/denty", "root", "");
        
        // Fetch posts
        stmt = conn.createStatement();
        String sqlPosts = "SELECT id, title, description, imagePath FROM posts";
        rs = stmt.executeQuery(sqlPosts);
        
        while (rs.next()) {
            int id = rs.getInt("id");
            String title = rs.getString("title");
            String description = rs.getString("description");
            String imagePath = rs.getString("imagePath");
            posts.add(new String[]{String.valueOf(id), title, description, imagePath});
        }

        // Fetch feedback
        rs.close(); // Close previous ResultSet
        String sqlFeedback = "SELECT full_name, email, phone_number, message, created_at FROM feedback";
        rs = stmt.executeQuery(sqlFeedback);
        
        while (rs.next()) {
            String fullName = rs.getString("full_name");
            String email = rs.getString("email");
            String phoneNumber = rs.getString("phone_number");
            String message = rs.getString("message");
            String createdAt = rs.getString("created_at");
            feedbacks.add(new String[]{fullName, email, phoneNumber, message, createdAt});
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (rs != null) try { rs.close(); } catch (Exception e) { e.printStackTrace(); }
        if (stmt != null) try { stmt.close(); } catch (Exception e) { e.printStackTrace(); }
        if (conn != null) try { conn.close(); } catch (Exception e) { e.printStackTrace(); }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Feed Panel - Denty</title>
    <link rel="stylesheet" href="admin.css">
    <style>
        /* Your existing styles */
    </style>
</head>
<body>
    <div class="content">
        <h1 class="text-center mb-4">Recent Posts</h1>

        <div class="text-center mb-4">
            <button type="button" class="btn btn-primary" onclick="openAddPostModal()">Add New Post</button>
        </div>

        <table class="table table-bordered table-hover">
            <thead>
                <tr>
                    <th>Title</th>
                    <th>Description</th>
                    <th>Image</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <% for (String[] post : posts) { %>
                <tr>
                    <td><%= post[1] %></td>
                    <td><%= post[2] %></td>
                    <td>
                        <% if (post[3] != null && !post[3].isEmpty()) { %>
                        <img src="<%= post[3] %>" alt="Post Image" style="max-width: 100px; height: auto;">
                        <% } %>
                    </td>
                    <td class="action-buttons">
                        <a href="DeletePostServlet?id=<%= post[0] %>" class="btn btn-danger btn-action" onclick="return confirm('Are you sure you want to delete this post?');">Delete</a>
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>

        <h2 class="text-center mb-4">Feedback Responses</h2>
        <table class="table table-bordered table-hover">
            <thead>
                <tr>
                    <th>Full Name</th>
                    <th>Email</th>
                    <th>Phone Number</th>
                    <th>Message</th>
                    <th>Date</th>
                </tr>
            </thead>
            <tbody>
                <% for (String[] feedback : feedbacks) { %>
                <tr>
                    <td><%= feedback[0] %></td>
                    <td><%= feedback[1] %></td>
                    <td><%= feedback[2] %></td>
                    <td><%= feedback[3] %></td>
                    <td><%= feedback[4] %></td>
                </tr>
                <% } %>
            </tbody>
        </table>
    </div>

    <div class="modal fade" id="addPostModal" tabindex="-1" aria-labelledby="addPostModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="addPostModalLabel">Add New Post</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form action="AddPostServlet" method="post" enctype="multipart/form-data">
                        <div class="mb-3">
                            <label for="postTitle" class="form-label">Title</label>
                            <input type="text" class="form-control" id="postTitle" name="postTitle" required>
                        </div>
                        <div class="mb-3">
                            <label for="postDescription" class="form-label">Description</label>
                            <textarea class="form-control" id="postDescription" name="postDescription" rows="4" required></textarea>
                        </div>
                        <div class="mb-3">
                            <label for="postImage" class="form-label">Upload Image</label>
                            <input type="file" class="form-control" id="postImage" name="postImage">
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
        function openAddPostModal() {
            $('#addPostModal').modal('show');
        }
    </script>
</body>
</html>
