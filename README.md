# Denty App v1.0 BETA

This is a web-based application designed for managing patient appointments, records, and payments for a dental clinic. The system is built using Java, JSP, Servlets, MySQL, and Tomcat. The frontend utilizes Bootstrap for styling, and the application is optimized for both desktop and mobile usage.

## Features

- **Patient Management**: Add, edit, and delete patient records.
- **Appointment Scheduling**: Schedule and manage patient appointments.
- **Payments Tracking**: Record and manage payments from patients.
- **Reports**: Generate reports related to patients, appointments, and payments.
- **Feed**: Create responsive and creative pages that will reflect back on home page as blog cascades.
- **Responsive Design**: Fully responsive UI, compatible with mobile devices.
- **Error Handling**: Graceful handling of errors with a centralized `error.jsp` page.

## Technologies Used

- **Backend**: Java, JSP, Servlets
- **Database**: MySQL
- **Frontend**: HTML, CSS (Bootstrap), JavaScript
- **Server**: Apache Tomcat
- **Database Driver**: JDBC

## Installation and Setup

### Prerequisites

- Java (JDK 8 or later)
- Apache Tomcat (v8.5 or later)
- MySQL
- Maven (optional, for dependency management)

### Clone the Repository

```bash
git clone https://github.com/your-username/denty-appointment-management.git
cd denty-appointment-management
```

### Database Setup

1. Create a new MySQL database:
   ```sql
   CREATE DATABASE denty;
   ```
2. Import the database schema from the `denty.sql` file in the `db/` directory.

3. Update the MySQL connection details in your configuration file (usually in `web.xml` or `context.xml`):
   ```xml
   <resource>
      <url>jdbc:mysql://localhost:3306/denty</url>
      <username>root</username>
      <password>yourpassword</password>
   </resource>
   ```

### Deployment

1. Build the project using your preferred method (e.g., Maven, IDE tools).
2. Deploy the `.war` file to your Apache Tomcat server.
3. Access the application at:
   ```
   http://localhost:8080/Denty_App/
   ```

## Usage

- **Login**: Use the admin credentials (set in the database or default credentials).
- **Manage Patients**: Navigate to the "Patients" section to view, add, or edit patient information.
- **Manage Appointments**: Use the "Appointments" tab to schedule or manage patient appointments.
- **Payments**: View and record payments for patient services.
- **Feed**: Create responsive and creative pages that will reflect back on home page as blog cascades.
- **Reports**: Generate reports related to patients, appointments, and payments.
  
## Error Handling

In case of any errors, a custom `error.jsp` page will handle unexpected issues and display a relevant message to the user. Ensure proper session and connection cleanup to avoid errors.

## Troubleshooting

If you encounter issues such as JDBC memory leaks or undeployed threads:
- Ensure all JDBC connections are closed properly after each request.
- Use the `ServletContextListener` to clean up resources when the application stops.

## Contributing

Contributions are welcome! Please submit a pull request with detailed descriptions of the changes you propose.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
