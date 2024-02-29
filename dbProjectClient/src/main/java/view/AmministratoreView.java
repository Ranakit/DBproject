package view;

import java.io.IOException;
import java.util.Scanner;

public class AmministratoreView {
    public static int showMenu() throws IOException {
        System.out.println("*********************************");
        System.out.println("*    ADMINISTRATOR DASHBOARD    *");
        System.out.println("*********************************\n");
        System.out.println("*** What should I do for you? ***\n");
        System.out.println("1) Add Exam");
        System.out.println("2) Show Staff Report");
        System.out.println("3) Quit");


        Scanner input = new Scanner(System.in);
        int choice;
        while (true) {
            System.out.print("Please enter your choice: ");
            choice = input.nextInt();
            if (choice >= 1 && choice <= 3) {
                break;
            }
            System.out.println("Invalid option");
        }

        return choice;
    }

    public static String showAddExamMenu() {
        System.out.println("Insert the name of the Exam you want to add:\n");
        Scanner input = new Scanner(System.in);
        return input.nextLine();
    }

    public static String showStaffReportChoice() {
        Scanner input = new Scanner(System.in);
        String in;
        while (true) {
            System.out.print("Select the type of report you want: [ m (on a monthly basis) / y (on an annual basis) / my (both)]: \n");
            in = input.nextLine();
            if (in.equals("m") || in.equals("y") || in.equals("my")){
                break;
            }
            System.out.println("You must enter 'm', 'y' or 'my'");
        }
        return in;
    }
}
