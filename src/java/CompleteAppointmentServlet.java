import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/CompleteAppointmentServlet")
public class CompleteAppointmentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Database connection setup
        String dbURL = "jdbc:mysql://localhost:3306/denty";
        String dbUser = "root";
        String dbPassword = "";

        // Get the appointment ID from the request
        int appointmentId = Integer.parseInt(request.getParameter("id"));

        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);
            String sql = "UPDATE appointments SET status = 'completed' WHERE id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, appointmentId);
            pstmt.executeUpdate();

            response.sendRedirect("appointments.jsp?success=true"); // Redirect with success message
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("appointments.jsp?error=true"); // Redirect with error message
        } finally {
            if (pstmt != null) try { pstmt.close(); } catch (Exception e) { e.printStackTrace(); }
            if (conn != null) try { conn.close(); } catch (Exception e) { e.printStackTrace(); }
        }
    }
}
