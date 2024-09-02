import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/EditPatients")
public class EditPatients extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    String id = request.getParameter("id");
    String name = request.getParameter("name");
    String age = request.getParameter("age");
    String gender = request.getParameter("gender");
    String phoneno = request.getParameter("phoneno");
    String blood = request.getParameter("blood");

    System.out.println("Received ID: " + id);  // Debugging: Check if ID is received
    System.out.println("Name: " + name);
    System.out.println("Age: " + age);
    System.out.println("Gender: " + gender);
    System.out.println("Phone Number: " + phoneno);
    System.out.println("Blood Group: " + blood);

    if (id == null || id.isEmpty()) {
        System.out.println("ID is null or empty, redirecting to error page.");
        response.sendRedirect("error.jsp");
        return;
    }

    // Database connection parameters
    String url = "jdbc:mysql://localhost:3306/denty";
    String username = "root";
    String password = "";

    Connection conn = null;
    PreparedStatement stmt = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(url, username, password);

        String sql = "UPDATE patient SET name = ?, age = ?, gender = ?, phoneno = ?, blood = ? WHERE id = ?";
        stmt = conn.prepareStatement(sql);
        stmt.setString(1, name);
        stmt.setString(2, age);
        stmt.setString(3, gender);
        stmt.setString(4, phoneno);
        stmt.setString(5, blood);
        stmt.setString(6, id);

        stmt.executeUpdate();

        response.sendRedirect("patients.jsp");
    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("error.jsp");
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