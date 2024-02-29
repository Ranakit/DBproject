package controller;

import model.dao.AddPatientDAO;
import model.dao.ConnectionFactory;
import model.dao.ExamDAO;
import model.dao.ReservationDAO;
import model.domain.Patient;
import model.domain.Reservation;
import model.domain.Role;
import view.CUPView;

import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;

public class CUPController implements Controller{

    @Override
    public void start() {
        try {
            ConnectionFactory.changeRole(Role.CUP);
        } catch(SQLException e) {
            throw new RuntimeException(e);
        }

        while(true) {
            int choice;
            try {
                choice = CUPView.showMenu();
            } catch(IOException e) {
                throw new RuntimeException(e);
            }

            switch(choice) {
                case 1 -> addPatient();
                case 2 -> addPatientInfo();
                case 3 -> listExams();
                case 4 -> addReservation();
                case 5 -> reservationsReport();
                case 6 -> examsReport();
                case 7 -> System.exit(0);
                default -> throw new RuntimeException("Invalid choice");
            }
        }
    }

    private void listExams() {
        ExamDAO dao = new ExamDAO();
        dao.getExams();
    }

    private void examsReport() {
        String code = CUPView.showExamReportMenu();
        ExamDAO dao = new ExamDAO();
        dao.getExamsReport(code);
    }

    private void addReservation() {
        Reservation reservation = CUPView.showAddReservationMenu();
        ReservationDAO dao = new ReservationDAO();
        dao.AddReservation(reservation);
    }

    public void addPatient() {
        Patient patient;
        try {
            patient = CUPView.showAddPatientMenu();
        } catch (ParseException e) {
            throw new RuntimeException(e);
        }
        AddPatientDAO dao = new AddPatientDAO();
        dao.AddPatient(patient);
    }

    public void addPatientInfo() {
        String[] information = CUPView.showAddPatientInfoMenu();
        AddPatientDAO dao = new AddPatientDAO();
        switch (information[1]) {
            case "cellphone" -> dao.AddCellphone(information);
            case "phone" -> dao.AddPhone(information);
            case "email" -> dao.AddEmail(information);
        }
    }
    private void reservationsReport() {
        int code = CUPView.showReservationReportMenu();
        ReservationDAO dao = new ReservationDAO();
        dao.reservationReport(code);
    }
}
