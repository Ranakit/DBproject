package controller;

import model.dao.ConnectionFactory;
import model.dao.ExamDAO;
import model.dao.StaffDao;
import model.domain.Role;
import view.AmministratoreView;

import java.io.IOException;
import java.sql.SQLException;

public class AmministratoreController implements Controller {

    @Override
    public void start() {
        try {
            ConnectionFactory.changeRole(Role.AMMINISTRATORE);
        } catch(SQLException e) {
            throw new RuntimeException(e);
        }

        while(true) {
            int choice;
            try {
                choice = AmministratoreView.showMenu();
            } catch(IOException e) {
                throw new RuntimeException(e);
            }

            switch(choice) {
                case 1 -> addExam();
                case 2 -> staffReport();
                case 3 -> System.exit(0);
                default -> throw new RuntimeException("Invalid choice");
            }
        }
    }

    private void staffReport() {
        String basis = AmministratoreView.showStaffReportChoice();
        StaffDao dao = new StaffDao();
        dao.getStaffReport(basis);
    }

    private void addExam() {
        String name = AmministratoreView.showAddExamMenu();
        ExamDAO dao = new ExamDAO();
        dao.addExam(name);
    }
}
