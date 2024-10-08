<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="Post" %>
<!DOCTYPE html>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Feed - Denty</title>
    <link rel="stylesheet" href="styles.css">
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">
</head>
<body>
<!-- Navigation Bar -->
<header>
    <nav id="index-navbar" class="navbar">
        <div class="logo">Denty App v1.0 BETA</div>
        <button class="menu-toggle" id="menu-toggle">☰</button>
        <ul class="nav-links">
            <li><a href="index.html">Home</a></li>
            <li><a href="index.html#services">Services</a></li>
            <li><a href="index.html#testimonials">Testimonials</a></li>
            <li><a href="index.html#appointment">Book Appointment</a></li>
            <li><a href="feed.html">Feed</a></li>
            <li><a href="contact.jsp">Contact</a></li>
            <li><a href="admin-login.jsp" class="admin-btn">Admin Login</a></li>
        </ul>
    </nav>
</header>

<!-- Hero Section -->

<!-- Services Section -->
<section id="services" class="services">
    <h2>Latest Updates</h2>
    <div class="services-container">
        <%-- Retrieve the list of posts from the request attribute --%>
        <%
            List<Post> posts = (List<Post>) request.getAttribute("posts");
            if (posts != null && !posts.isEmpty()) {
                for (Post post : posts) {
        %>
        <div class="service">
            <h3><%= post.getTitle() %></h3>
            <%-- Display the image if it exists --%>
            <c:if test="${not empty post.imagePath}">
                <img src="${pageContext.request.contextPath}/uploads/<%= post.getImagePath() %>" width="500" height="300" alt="<%= post.getTitle() %>">
            </c:if>
            <p><%= post.getDescription() %></p>
        </div>
        <%
                }
            } else {
        %>
        <p>No posts available at the moment.</p>
        <% 
            }
        %>
    </div>
</section>



<!-- Feedback Form Section -->
<section id="feedback" class="feedback">
    <h2>Feedback Form</h2>
    <form action="#" method="POST" class="feedback-form">
        <div class="form-group">
            <label for="name">Full Name</label>
            <input type="text" id="name" name="name" required>
        </div>
        <div class="form-group">
            <label for="email">Email</label>
            <input type="email" id="email" name="email" required>
        </div>
        <div class="form-group">
            <label for="phone">Phone Number</label>
            <input type="tel" id="phone" name="phone" required>
        </div>
        <div class="form-group">
            <label for="feedback">Feedback message</label>
            <textarea id="feedback" name="feedback-response" rows="5" cols="55"></textarea>
        </div>
        <button type="submit" class="btn">Submit</button>
    </form>
</section>

<!-- Footer -->
<footer>
    <div class="footer-content">
        <p>© 2024 Denty App v1.0. All rights reserved.</p>
    </div>
</footer>

<script src="script.js"></script>
</body>
</html>