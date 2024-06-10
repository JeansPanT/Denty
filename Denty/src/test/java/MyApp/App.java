package MyApp;
import java.util.Scanner;
public class App {
	public static void main(String[] args) {
		NewPatient t = new NewPatient();
		Scanner sc = new Scanner(System.in);
		System.out.println("Welcome to Denty App v1.0");
		System.out.println("1 - add New Patients");
		System.out.println("2 - View all Patients");
		System.out.println("3 - View Patients by ID");
		System.out.println("4 - delete Patients");
		System.out.println("5 - Modify Patients");
		System.out.println("0 - Exit");
		System.out.println("Enter your Choice : ");
		int choice = sc.nextInt();
		switch (choice) {
			case 1: {
				t.addNew();
				break;
			}
			case 2: {
				t.viewPatient();
				break;
			}
			case 3: {
				t.viewPatientbyID();
				break;
			}
			case 4: {
				t.delPatient();
				break;
			}
			case 5: {
				t.editPatient();
				break;
			}
			case 0: {

			}
			default: {
				System.out.println("You've entered the wrong choice");
			}
		}
	}
}

