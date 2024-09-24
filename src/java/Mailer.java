import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.util.Properties;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/Mailer")
public class Mailer extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Redirect GET requests to POST logic
        doPost(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phoneno = request.getParameter("phone");
        String date = request.getParameter("date");
        String timeslot = request.getParameter("timeslot");
        
        
        // Database connection parameters
        String url = "jdbc:mysql://localhost:3306/denty";
        String username = "root";
        String password = "";

        // Email server properties
        final String fromEmail = "siddhukar39@gmail.com"; // Your email
        final String emailPassword = "qcge jxyp qajz oukd"; // Your email password
        final String smtpHost = "smtp.gmail.com"; // Correct SMTP server for Gmail
        final String smtpPort = "587"; // Port for TLS

        // Query to get appointments
        String query = "INSERT INTO appointments (name, email, phoneno, date, timeslot) VALUES (?, ?, ?, ?, ?)";
            
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            // Load MySQL JDBC driver
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(url, username, password);
            stmt = conn.prepareStatement(query);
            stmt.setString(1, name);
            stmt.setString(2, email);
            stmt.setString(3, phoneno);
            stmt.setString(4, date);
            stmt.setString(5, timeslot);
            
            stmt.executeUpdate();

            // Setup mail server properties
Properties props = new Properties();
props.put("mail.smtp.auth", "true");
props.put("mail.smtp.starttls.enable", "true"); // Enable TLS
props.put("mail.smtp.ssl.protocols", "TLSv1.2"); // Ensure TLS 1.2 is used
props.put("mail.smtp.host", smtpHost);
props.put("mail.smtp.port", smtpPort);
props.put("mail.debug", "true"); // Enable debugging

// Create a new session with an authenticator
Session session = Session.getInstance(props, new javax.mail.Authenticator() {
    @Override
    protected PasswordAuthentication getPasswordAuthentication() {
        return new PasswordAuthentication(fromEmail, emailPassword);
    }
});
 
                // Create a default MimeMessage object
                MimeMessage message = new MimeMessage(session);

                // Set From: header field
                message.setFrom(new InternetAddress(fromEmail));

                // Set To: header field
                message.addRecipient(Message.RecipientType.TO, new InternetAddress(email));

                // Set Subject: header field
                message.setSubject("Appointment Confirmation");

                // Set the actual message
                String body = String.format(
                        "Dear %s,%n%nYour appointment is confirmed for %s at %s.%n%nThank you!",
                        name, date, timeslot);
                message.setText(body);

                // Send message
                Transport.send(message);
            

            response.sendRedirect("index.html?success=true");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp?error=Failed to send emails. Please try again.");
        } finally {
            try {
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}
