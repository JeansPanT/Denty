import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

@WebServlet("/AddReportServlet")
@MultipartConfig
public class AddReportServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String patientId = request.getParameter("patientId");
        String reportName = request.getParameter("reportName");
        Part filePart = request.getPart("reportFile");

        if (patientId == null || patientId.trim().isEmpty() || reportName == null || reportName.trim().isEmpty() || filePart == null) {
            response.sendRedirect("reports.jsp?error=Invalid input");
            return;
        }

        String uploadDirPath = getServletContext().getRealPath("") + File.separator + "uploads";
        Path uploadDir = Paths.get(uploadDirPath);
        if (!Files.exists(uploadDir)) {
            Files.createDirectories(uploadDir);
        }

        String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
        Path filePath = uploadDir.resolve(fileName);
        try (InputStream fileContent = filePart.getInputStream()) {
            Files.copy(fileContent, filePath);
        }

        String dbUrl = "jdbc:mysql://localhost:3306/denty";
        String dbUser = "root";
        String dbPassword = "";

        try (Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword)) {
            Class.forName("com.mysql.cj.jdbc.Driver");

            String sql = "INSERT INTO patient_reports (patient_id, report_name, file_path) VALUES (?, ?, ?)";
            try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                pstmt.setString(1, patientId);
                pstmt.setString(2, reportName);
                pstmt.setString(3, filePath.toString());

                int rowsAffected = pstmt.executeUpdate();
                if (rowsAffected > 0) {
                    response.sendRedirect("reports.jsp?success=Report successfully submitted");
                } else {
                    response.sendRedirect("reports.jsp?error=Failed to add report");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("reports.jsp?error=Error occurred: " + e.getMessage());
        }
    }
}
