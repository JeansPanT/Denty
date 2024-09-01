<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Contact Us</title>
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

<!-- Contact Section -->
<section class="contact-section">
  <h2>Contact Us</h2>
  <div class="contact-container">
    <!-- Google Map (using iframe) -->
    <div class="map">
      <iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d14716.149974532525!2d75.87008029999997!3d22.7639898!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x39630304e3540513%3A0x7da8df59c7a08023!2zVHJpbG9rIERlbnRhbCBTb2x1dGlvbnMo4KSk4KWN4KSw4KS_4KSy4KWL4KSVIOCkoeClh-CkqOCljeCkn-CksiDgpLjgpYvgpLLgpY3gpK_gpYLgpLbgpKgp!5e0!3m2!1sen!2sin!4v1725183474911!5m2!1sen!2sin" width="600" height="450" style="border:0; width: 100%; height: 400px; border-radius: 8px;" allowfullscreen="" loading="lazy" referrerpolicy="no-referrer-when-downgrade"></iframe>
    </div>

    <!-- Contact Form -->
    <form class="contact-form" id="contact-form">
      <div class="form-group">
        <label for="name">Name</label>
        <input type="text" id="name" name="name" required>
      </div>
      <div class="form-group">
        <label for="email">Email</label>
        <input type="email" id="email" name="email" required>
      </div>
      <div class="form-group">
        <label for="subject">Subject</label>
        <input type="text" id="subject" name="subject" required>
      </div>
      <div class="form-group">
        <label for="message">Message</label>
        <textarea id="message" name="message" rows="4" required></textarea>
      </div>
      <button type="submit" class="btn">Send Message</button>
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
