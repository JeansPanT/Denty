import java.io.FileOutputStream;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.itextpdf.kernel.pdf.PdfDocument;
import com.itextpdf.kernel.pdf.PdfWriter;
import com.itextpdf.layout.Document;
import com.itextpdf.layout.element.Paragraph;

@WebServlet("/GenerateInvoiceServlet")
public class GenerateInvoiceServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Database connection setup
        String dbURL = "jdbc:mysql://localhost:3306/denty";
        String dbUser = "root";
        String dbPassword = "";

        // Get invoice details from the request
        String patientId = request.getParameter("patientId");
        String invoiceAmount = request.getParameter("invoiceAmount");
        String invoiceDescription = request.getParameter("invoiceDescription");

        // Debugging logs
        System.out.println("Received Patient ID: " + patientId);
        System.out.println("Received Invoice Amount: " + invoiceAmount);
        System.out.println("Received Invoice Description: " + invoiceDescription);

        // Check if patientId is valid
        if (patientId == null || patientId.isEmpty()) {
            response.sendRedirect("payments.jsp?error=Patient ID is required");
            return;
        }

        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            // Establish database connection
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

            // Insert invoice details into the database
            String sql = "INSERT INTO invoices (patient_id, amount, description) VALUES (?, ?, ?)";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, patientId);
            pstmt.setString(2, invoiceAmount);
            pstmt.setString(3, invoiceDescription);
            pstmt.executeUpdate();

            // Generate PDF
            String invoiceFilePath = getServletContext().getRealPath("") + "invoices/invoice_" + patientId + ".pdf";
            PdfWriter writer = new PdfWriter(new FileOutputStream(invoiceFilePath));
            PdfDocument pdfDoc = new PdfDocument(writer);
            Document document = new Document(pdfDoc);

            document.add(new Paragraph("Invoice for Patient ID: " + patientId));
            document.add(new Paragraph("Amount: $" + invoiceAmount));
            document.add(new Paragraph("Description: " + invoiceDescription));
            document.close();

            // Redirect or send success message
            response.sendRedirect("payments.jsp?invoiceGenerated=true");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("payments.jsp?invoiceError=true"); // Redirect with error message
        } finally {
            if (pstmt != null) {
                try { pstmt.close(); } catch (Exception e) { e.printStackTrace(); }
            }
            if (conn != null) {
                try { conn.close(); } catch (Exception e) { e.printStackTrace(); }
            }
        }
    }
}
