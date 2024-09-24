import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;

@WebServlet("/DownloadReportServlet")
public class DownloadReportServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final String UPLOAD_DIRECTORY = "uploads"; // Use relative path

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Retrieve and decode the file path from the request
        String filePath = request.getParameter("filePath");
        System.out.println("Received filePath: " + filePath); // Log received file path

        if (filePath != null) {
            filePath = URLDecoder.decode(filePath, StandardCharsets.UTF_8.toString());
        }

        System.out.println("Decoded filePath: " + filePath); // Log decoded file path

        // Validate and sanitize the file path
        if (filePath == null || filePath.contains("..")) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid file path");
            return;
        }

        // Get the absolute path for the uploads directory
        String absolutePath = getServletContext().getRealPath("/") + UPLOAD_DIRECTORY;
        
        // Create a file object using the absolute path
        File file = new File(absolutePath, new File(filePath).getName());
        System.out.println("File to download: " + file.getAbsolutePath()); // Log file path

        if (file.exists() && file.isFile()) {
            // Set the response content type and headers
            response.setContentType("application/octet-stream");
            response.setContentLengthLong(file.length());
            response.setHeader("Content-Disposition", "attachment; filename=\"" + file.getName() + "\"");

            // Write the file to the response output stream
            try (FileInputStream in = new FileInputStream(file); OutputStream out = response.getOutputStream()) {
                byte[] buffer = new byte[1024];
                int bytesRead;
                while ((bytesRead = in.read(buffer)) != -1) {
                    out.write(buffer, 0, bytesRead);
                }
            }

            System.out.println("File download successful"); // Log success message
        } else {
            System.out.println("File not found: " + file.getAbsolutePath()); // Log file not found message
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "File not found");
        }
    }
}
