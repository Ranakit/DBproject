package view;

import model.domain.Patient;
import model.domain.Reservation;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Timestamp;
import java.text.ParseException;
import java.sql.Date;
import java.util.Scanner;

public class CUPView {

    public static int showMenu() throws IOException {
        System.out.println("*********************************");
        System.out.println("*    CUP STAFF DASHBOARD    *");
        System.out.println("*********************************\n");
        System.out.println("*** What should I do for you? ***\n");
        System.out.println("1) Add patient");
        System.out.println("2) Add patient infos");
        System.out.println("3) List exams");
        System.out.println("4) Add reservation");
        System.out.println("5) reservations report");
        System.out.println("6) exams report");
        System.out.println("7) Quit");


        Scanner input = new Scanner(System.in);
        int choice = 0;
        while (true) {
            System.out.print("Please enter your choice: ");
            choice = input.nextInt();
            if (choice >= 1 && choice <= 7) {
                break;
            }
            System.out.println("Invalid option");
        }
        return choice;
    }

    public static Patient showAddPatientMenu() throws ParseException {
        System.out.println("Please enter patient information: sanitaryCode name surname birthDate(yyyy-MM-dd) birthPlace addresslikethis9\n");

        Scanner input = new Scanner(System.in);

        String in = input.nextLine();
        String[] entry = in.split(" ");
        return new Patient(entry[0], entry[1], entry[2], Date.valueOf(entry[3]), entry[4], entry[5]);
    }

    public static String[] showAddPatientInfoMenu() {
        System.out.println("Enter the Patient information like this: sanitaryCode [phone/cellphone/email] *information* *information* ...\n");
        Scanner input = new Scanner(System.in);
        String in = input.nextLine();
        return in.split(" ");
    }

    public static int showReservationReportMenu() {
        Scanner input = new Scanner(System.in);
        int in;
        while (true) {
            System.out.print("Insert the reservation code you want a report about: \n");
            in = input.nextInt();
            if (in >= 0) {
                break;
            }
            System.out.println("the reservation code must be a positive number");
        }
        return in;
    }

    public static String showExamReportMenu() {
        Scanner input = new Scanner(System.in);

        String in;
        while (true) {
            System.out.print("Insert the sanitary code of the patient you want a report about: \n");
            in = input.nextLine();
            if (in.matches("^[a-zA-Z0-9]{20}$")){
                break;
            }
            System.out.println("the sanitary code must be an alphanumeric string of 20 characters");
        }

        return in;
    }

    public static Reservation showAddReservationMenu() {
        System.out.println("Please enter reservation information: reservationCode,Date(yyyy-MM-dd hh:mm:ss),ExamCode cost(cdu.dc),urgency(true or false),sanitaryCode\n");

        Scanner input = new Scanner(System.in);

        String in = input.nextLine();
        String[] entry = in.split(",");
        BigDecimal bigDecimal = new BigDecimal(entry[2]);
        return new Reservation(Integer.parseInt(entry[0]), Timestamp.valueOf(entry[1]), Integer.parseInt(entry[2]), bigDecimal, Boolean.parseBoolean(entry[4]), entry[5]);
    }
}