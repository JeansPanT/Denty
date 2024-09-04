import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

// Define the servlet URL pattern
@WebServlet("/ViewReportsServlet")
public class ViewReportsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Retrieve patient ID from the request
        String patientId = request.getParameter("patientId");
        
        // Database connection parameters
        String url = "jdbc:mysql://localhost:3306/denty"; // Update with your database name
        String username = "root"; // Update with your MySQL username
        String password = ""; // Update with your MySQL password

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<Report> reports = new ArrayList<>();

        try {
            // Load MySQL JDBC driver
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Establish connection to the database
            conn = DriverManager.getConnection(url, username, password);

            // Prepare SQL query to retrieve reports for the given patient ID
            String sql = "SELECT report_id, report_name, file_path FROM patient_reports WHERE patient_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, patientId);
            
            // Execute query
            rs = pstmt.executeQuery();
            
            // Process the result set
            while (rs.next()) {
                Report report = new Report();
                report.setReportId(rs.getInt("report_id"));
                report.setReportName(rs.getString("report_name"));
                report.setFilePath(rs.getString("file_path"));
                reports.add(report);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        
        // Set the reports list as a request attribute to pass to the JSP
        request.setAttribute("reports", reports);
        request.setAttribute("patientId", patientId);

        // Forward to the JSP page to display the reports
        RequestDispatcher dispatcher = request.getRequestDispatcher("reports.jsp");
        dispatcher.forward(request, response);
    }
}
