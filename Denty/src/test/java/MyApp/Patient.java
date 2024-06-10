package MyApp;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Scanner;

public class Patient {
	Connection cn;

	{
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
		} catch (ClassNotFoundException ex) {
			throw new RuntimeException(ex);
		}
		try {
			cn = DriverManager.getConnection("jdbc:mysql://localhost/denty", "root", "");
		} catch (SQLException ex) {
			throw new RuntimeException(ex);
		}
	}
}


class NewPatient extends Patient{
	Scanner Sc = new Scanner(System.in);
	public void addNew() {
		System.out.println("Enter your ID");
		int id = Sc.nextInt();
		System.out.println("Enter your name");
		String name = Sc.next();
		System.out.println("Enter your phone no");
		int phoneno = Sc.nextInt();


		PreparedStatement ps;
		try {
			ps = cn.prepareStatement("insert into patient values(?,?,?)");

			ps.setInt(1, id);
			ps.setString(2, name);
			ps.setInt(3, phoneno);
		} catch (SQLException ex) {
			throw new RuntimeException(ex);
		}
		try {
			boolean b = ps.execute();
			if (!b) {

				System.out.println("Data Inserted...");
			}
		}
		catch(Exception e)
		{
			System.out.println(e.getMessage());
		}
	}
	public void viewPatient(){
		PreparedStatement ps;
		try {
			ps = cn.prepareStatement("select * from patient");


		} catch (SQLException ex) {
			throw new RuntimeException(ex);
		}
        try {
            ResultSet rs=ps.executeQuery();
			System.out.println("PATIENT ID"+" | "+"PATIENT NAME"+" | "+"PHONE NO");
			while(rs.next())
			{
				int id=rs.getInt(1);
				String name=rs.getString(2);
				int phoneno=rs.getInt(3);
				System.out.println(id+" - "+name+" - "+phoneno);
			}
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

	public void viewPatientbyID(){
		System.out.println("Enter your ID :");
		int iid= Sc.nextInt();
		PreparedStatement ps;
		try {
			ps = cn.prepareStatement("select * from patient where id=?");
			ps.setInt(1,iid);


		} catch (SQLException ex) {
			throw new RuntimeException(ex);
		}
		try {
			ResultSet rs=ps.executeQuery();
			System.out.println("PATIENT ID"+" | "+"PATIENT NAME"+" | "+"PHONE NO");
			while(rs.next())
			{
				int id=rs.getInt(1);
				String name=rs.getString(2);
				int phoneno=rs.getInt(3);
				System.out.println(id+" - "+name+" - "+phoneno);
			}
		} catch (SQLException e) {
			throw new RuntimeException(e);
		}
	}


	public void delPatient(){
		System.out.println("Enter your ID");
		int id= Sc.nextInt();
		PreparedStatement ps;
		try {
			ps = cn.prepareStatement("delete from patient where id=?");
			ps.setInt(1,id);
		} catch (SQLException ex) {
			throw new RuntimeException(ex);
		}
		try {
			boolean b = ps.execute();
			if (!b) {

				System.out.println("Data deleted...");
			}
		} catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

	public void editPatient(){
		System.out.println("Enter your ID");
		int id= Sc.nextInt();
		System.out.println("Enter your updated Name");
		String name= Sc.next();
		System.out.println("Enter your updated PhoneNo");
		int phoneno= Sc.nextInt();
		PreparedStatement ps;
		try {
			ps = cn.prepareStatement("UPDATE patient SET name=?, phoneno=? WHERE id=?");
			ps.setString(1,name);
			ps.setInt(2,phoneno);
			ps.setInt(3,id);


		} catch (SQLException ex) {
			throw new RuntimeException(ex);
		}
		try {
			boolean b = ps.execute();
			if (!b) {

				System.out.println("Data updated...");
			}
			// Connection Closed
			cn.close();
		} catch (SQLException e) {
			throw new RuntimeException(e);
		}
	}
}



