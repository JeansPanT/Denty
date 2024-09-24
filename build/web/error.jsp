<%@ page isErrorPage="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Error</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
</head>
<body>
    <div class="container text-center mt-5">
        <h1 class="display-4 text-danger">Oops!</h1>
        <p class="lead">Something went wrong. Please try again later.</p>
        <%
            // Invalidate the session if it exists
            if (session != null) {
                session.invalidate();
            }

            // Display the error message if available
            if (exception != null) {
                out.println("<p class='text-muted'>" + exception.getMessage() + "</p>");
            } else {
                out.println("<p class='text-muted'>An unexpected error occurred.</p>");
            }
        %>
        <a href="index.html" class="btn btn-primary mt-3">Go to Home</a>
    </div>
</body>
</html>
