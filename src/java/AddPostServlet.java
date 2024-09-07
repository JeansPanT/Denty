import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.nio.file.Paths;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

@WebServlet("/AddPostServlet")
@MultipartConfig
public class AddPostServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String postTitle = request.getParameter("postTitle");
        String postDescription = request.getParameter("postDescription");
        Part filePart = request.getPart("postImage"); // Retrieves the file part

        String imagePath = null;
        if (filePart != null && filePart.getSize() > 0) {
            // Save the file to a desired location
            String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
            String uploadPath = getServletContext().getRealPath("/") + "uploads/" + fileName;
            File uploadDir = new File(getServletContext().getRealPath("/") + "uploads");
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }
            File uploadFile = new File(uploadPath);
            try (InputStream input = filePart.getInputStream(); OutputStream output = new FileOutputStream(uploadFile)) {
                byte[] buffer = new byte[4096];
                int bytesRead;
                while ((bytesRead = input.read(buffer)) != -1) {
                    output.write(buffer, 0, bytesRead);
                }
            }
            imagePath = "uploads/" + fileName; // Path to the uploaded file
        }

        // Save post details to the database
        String url = "jdbc:mysql://localhost:3306/denty";
        String username = "root";
        String password = "";

        String sql = "INSERT INTO posts (title, description, imagePath) VALUES (?, ?, ?)";

        try (Connection conn = DriverManager.getConnection(url, username, password);
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, postTitle);
            pstmt.setString(2, postDescription);
            pstmt.setString(3, imagePath);
            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }

        // Redirect to the feed page
        response.sendRedirect("adminFeed.jsp");
    }
}
