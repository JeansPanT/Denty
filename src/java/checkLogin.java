import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/checkLogin")
public class checkLogin extends HttpServlet {
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        try {
            String username = request.getParameter("username");
            String password = request.getParameter("password");

            // Load the driver class
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Create connection
            Connection cn = DriverManager.getConnection("jdbc:mysql://localhost:3306/denty", "root", "");

            // Prepare statement to query user credentials
            PreparedStatement ps = cn.prepareStatement("SELECT * FROM admin_users WHERE username=? AND BINARY password=?");
            ps.setString(1, username);
            ps.setString(2, password);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                String id = rs.getString("id");
                HttpSession session = request.getSession(true);
                session.setAttribute("id", id);
                session.setAttribute("username", username);

                response.sendRedirect("dashboard.jsp");
            } else {
                request.setAttribute("errorMessage", "Username or password invalid");
                request.setAttribute("username", username); // Preserve username
                RequestDispatcher rd = request.getRequestDispatcher("admin-login.jsp");
                rd.include(request, response);
            }

            cn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }
}
