import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/UpdateAppointmentServlet")
public class UpdateAppointmentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Database connection setup
        String dbURL = "jdbc:mysql://localhost:3306/denty";
        String dbUser = "root";
        String dbPassword = "";

        // Get the updated appointment data from the request
        int appointmentId = Integer.parseInt(request.getParameter("id"));
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String date = request.getParameter("date");
        String timeslot = request.getParameter("timeslot");
        String status = request.getParameter("status");

        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);
            String sql = "UPDATE appointments SET name = ?, email = ?, date = ?, timeslot = ?, status = ? WHERE id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, name);
            pstmt.setString(2, email);
            pstmt.setString(3, date);
            pstmt.setString(4, timeslot);
            pstmt.setString(5, status);
            pstmt.setInt(6, appointmentId);
            pstmt.executeUpdate();

            response.sendRedirect("appointments.jsp?success=true"); // Redirect to the appointments page with success message
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("appointments.jsp?error=true"); // Redirect with error message
        } finally {
            if (pstmt != null) try { pstmt.close(); } catch (Exception e) { e.printStackTrace(); }
            if (conn != null) try { conn.close(); } catch (Exception e) { e.printStackTrace(); }
        }
    }
}
