import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;

@WebServlet("/DeleteReportServlet")
public class DeleteReportServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final String UPLOAD_DIRECTORY = "C:/Users/JeansPanT/Desktop/My Programs/Denty App/build/web/uploads"; // Update as needed

    // Database connection details
    private static final String DB_URL = "jdbc:mysql://localhost:3306/denty";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "";

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Retrieve and decode the file path from the request
        String filePath = request.getParameter("filePath");
        if (filePath != null) {
            filePath = URLDecoder.decode(filePath, StandardCharsets.UTF_8.toString());
        }
        
        // Validate and sanitize the file path
        if (filePath == null || filePath.contains("..")) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid file path");
            return;
        }

        // Create a file object using the absolute path
        File file = new File(UPLOAD_DIRECTORY, new File(filePath).getName());
        System.out.println("File to delete: " + file.getAbsolutePath()); // Log file path

        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            // Connect to the database
            conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
            conn.setAutoCommit(false); // Start transaction

            // Delete the file
            if (file.exists() && file.isFile()) {
                if (file.delete()) {
                    System.out.println("File deletion successful"); // Log success message

                    // Prepare and execute the database update
                    String sql = "DELETE FROM patient_reports WHERE file_path = ?";
                    stmt = conn.prepareStatement(sql);
                    stmt.setString(1, filePath);
                    int rowsAffected = stmt.executeUpdate();

                    if (rowsAffected > 0) {
                        conn.commit(); // Commit transaction if update is successful
                        response.sendRedirect("reports.jsp?success=Report%20deleted%20successfully");
                    } else {
                        conn.rollback(); // Rollback transaction if update fails
                        System.out.println("File not found in database"); // Log message
                        response.sendError(HttpServletResponse.SC_NOT_FOUND, "Report not found in database");
                    }
                } else {
                    System.out.println("File deletion failed"); // Log failure message
                    response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to delete file");
                }
            } else {
                System.out.println("File not found: " + file.getAbsolutePath()); // Log file not found message
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "File not found");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            if (conn != null) {
                try {
                    conn.rollback(); // Rollback transaction on error
                } catch (SQLException rollbackEx) {
                    rollbackEx.printStackTrace();
                }
            }
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error: " + e.getMessage());
        } finally {
            // Clean up resources
            if (stmt != null) {
                try {
                    stmt.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }
}
