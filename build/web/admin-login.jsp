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
    <style>
        /* Admin Login Section */
        .admin-login {
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            background-color: #f4f4f4;
        }
        .login-container {
            max-width: 400px;
            width: 100%;
            padding: 30px;
            background-color: #ffffff;
            border-radius: 12px;
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.1);
            text-align: left;
            transition: all 0.3s ease;
        }

        .login-container:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 30px rgba(0, 0, 0, 0.2);
        }

        .login-container h2 {
            margin-bottom: 20px;
            font-size: 28px;
            color: #2c3e50;
            text-align: center;
            font-weight: 700;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: #333;
            font-weight: 600;
        }

        .form-group input {
            width: 100%;
            padding: 12px 15px;
            border-radius: 8px;
            border: 1px solid #ccc;
            font-size: 16px;
            background-color: #f9f9f9;
            transition: all 0.3s ease;
        }

        .form-group input:focus {
            border-color: #3498db;
            background-color: #ffffff;
            outline: none;
            box-shadow: 0 0 8px rgba(52, 152, 219, 0.3);
        }

        .btn {
            width: 100%;
            padding: 15px;
            background-color: #e74c3c;
            border: none;
            border-radius: 8px;
            color: white;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: background-color 0.3s ease, transform 0.2s ease;
            margin-top: 10px;
        }

        .btn:hover {
            background-color: #c0392b;
            transform: translateY(-2px);
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
        }

        /* Responsive adjustments */
        @media (max-width: 768px) {
            .login-container {
                padding: 20px;
                width: 90%;
            }

            .form-group input {
                padding: 10px;
                font-size: 14px;
            }

            .btn {
                padding: 12px;
                font-size: 14px;
            }
        }
    </style>
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
            <li><a href="index.html#appointment">Book Appointment</a></li>
            <li><a href="feed.html">Feed</a></li>
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

        <!-- Error Message Placeholder -->
        <div id="error-message" style="color: red; font-weight: bold; margin-top: 15px;">
            <%
                String errorMessage = (String) request.getAttribute("errorMessage");
                if (errorMessage != null) {
                    out.println(errorMessage);
                }
            %>
        </div>
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
