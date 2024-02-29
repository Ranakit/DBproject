package view;

import model.domain.ExamDiagnosis;
import model.domain.ExamResult;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;

public class MedicoView {
    public static int showMenu() throws IOException {
        System.out.println("*********************************");
        System.out.println("*    MEDICAL STAFF DASHBOARD    *");
        System.out.println("*********************************\n");
        System.out.println("*** What should I do for you? ***\n");
        System.out.println("1) Add Exam Results");
        System.out.println("2) Add Exam Diagnosis");
        System.out.println("3) Add Done Exam");
        System.out.println("4) Quit");


        Scanner input = new Scanner(System.in);
        int choice;
        while (true) {
            System.out.print("Please enter your choice: ");
            choice = input.nextInt();
            if (choice >= 1 && choice <= 4) {
                break;
            }
            System.out.println("Invalid option");
        }

        return choice;
    }

    public static ExamResult showAddExamResultMenu() {
        System.out.println("Enter the results information like this: reservationCode,Date(yyyy-MM-dd hh:mm:ss),ExamCode,*ResultName,ResultValue*,*ResultName,ResultValue* ...\n");
        Scanner input = new Scanner(System.in);
        String in = input.nextLine();
        String[] entry = in.split(",");
        List<BigDecimal> values = new ArrayList<>();
        List<String> names = new ArrayList<>();
        for (int i = 4; i < entry.length; i = i + 2){
            names.add(entry[i-1]);
            BigDecimal bigDecimal = new BigDecimal(entry[i]);
            values.add(bigDecimal);
        }
        return new ExamResult(Integer.parseInt(entry[0]), Timestamp.valueOf(entry[1]), Integer.parseInt(entry[2]), names, values);
    }

    public static ExamDiagnosis showAddExamDiagnosisMenu() {
        System.out.println("Enter the diagnosis like this: Diagnosis,Date(yyyy-MM-dd hh:mm:ss),ReservationCode,ExamCode\n");
        Scanner input = new Scanner(System.in);
        String in = input.nextLine();
        String[] entry = in.split(",");
        return new ExamDiagnosis(entry[0], Timestamp.valueOf(entry[1]), Integer.parseInt(entry[2]), Integer.parseInt(entry[2]));
    }

    public static String[] showAddDoneExamMenu() {
        System.out.println("Enter the done Exam like this: ExamCode YourFiscalCode\n");
        Scanner input = new Scanner(System.in);
        String in = input.nextLine();
        return in.split(" ");
    }
}