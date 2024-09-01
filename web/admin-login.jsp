<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Login - Denty App</title>
    <link rel="stylesheet" href="styles.css">
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">
</head>
<body>
<!-- Navigation Bar -->
<header>
    <nav class="navbar">
        <div class="logo">Denty App v1.0 BETA</div>
        <button class="menu-toggle" id="menu-toggle">☰</button>
        <ul class="nav-links">
            <li><a href="index.html">Home</a></li>
            <li><a href="index.html#services">Services</a></li>
            <li><a href="index.html#testimonials">Testimonials</a></li>
            <li><a href="contact.jsp">Contact</a></li>
            <li><a href="admin-login.jsp" class="admin-btn">Admin Login</a></li>
        </ul>
    </nav>
</header>

<!-- Admin Login Section -->
<section id="admin-login" class="admin-login">
    <div class="login-container">
        <h2>Admin Login</h2>
        <form action="checkLogin" method="POST" class="login-form">
            <div class="form-group">
                <label for="username">Username</label>
                <input type="text" id="username" name="username" required>
            </div>
            <div class="form-group">
                <label for="password">Password</label>
                <input type="password" id="password" name="password" required>
            </div>
            <button type="submit" class="btn">Login</button>
        </form>
    </div>
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
