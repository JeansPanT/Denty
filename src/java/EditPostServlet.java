import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

@WebServlet("/EditPostServlet")
@MultipartConfig
public class EditPostServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Extract parameters from the request
        int id = Integer.parseInt(request.getParameter("id"));
        String title = request.getParameter("postTitle");
        String description = request.getParameter("postDescription");
        
        // Handle file upload
        Part filePart = request.getPart("postImage");
        String imagePath = null;

        if (filePart != null && filePart.getSize() > 0) {
            // Set up file saving path
            String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads";
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdir(); // Create upload directory if it doesn't exist
            }
            String fileName = File.separator + System.currentTimeMillis() + "_" + filePart.getSubmittedFileName();
            String filePath = uploadPath + fileName;
            filePart.write(filePath);
            imagePath = "uploads" + fileName; // Relative path to save in the database
        }

        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            // Load the database driver
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/denty", "root", "");
            // Prepare SQL update statement
            String sql = "UPDATE posts SET title=?, description=?, imagePath=? WHERE id=?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, title);
            pstmt.setString(2, description);
            pstmt.setString(3, imagePath != null ? imagePath : ""); // Handle case when no image is uploaded
            pstmt.setInt(4, id);
            pstmt.executeUpdate();

            // Redirect to success page
            response.sendRedirect("adminFeed.jsp");
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "An error occurred while updating the post.");
        } finally {
            if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    }
}
