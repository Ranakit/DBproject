package controller;

import model.dao.ConnectionFactory;
import model.dao.ExamDAO;
import model.dao.ExamResultsDao;
import model.domain.ExamDiagnosis;
import model.domain.ExamResult;
import model.domain.Role;
import view.MedicoView;

import java.io.IOException;
import java.sql.SQLException;

public class MedicoController implements Controller {

    @Override
    public void start() {
        try {
            ConnectionFactory.changeRole(Role.MEDICO);
        } catch(SQLException e) {
            throw new RuntimeException(e);
        }

        while(true) {
            int choice;
            try {
                choice = MedicoView.showMenu();
            } catch(IOException e) {
                throw new RuntimeException(e);
            }

            switch(choice) {
                case 1 -> addExamResult();
                case 2 -> addDiagnosis();
                case 3 -> addDoneExam();
                case 4 -> System.exit(0);
                default -> throw new RuntimeException("Invalid choice");
            }
        }
    }

    private void addDoneExam() {
        String[] doneExam = MedicoView.showAddDoneExamMenu();
        ExamDAO dao = new ExamDAO();
        dao.AddDoneExam(doneExam);
    }

    private void addDiagnosis() {
        ExamDiagnosis diagnosis = MedicoView.showAddExamDiagnosisMenu();
        ExamResultsDao dao = new ExamResultsDao();
        dao.addExamDiagnosis(diagnosis);
    }

    private void addExamResult() {
        ExamResult result = MedicoView.showAddExamResultMenu();
        ExamResultsDao dao = new ExamResultsDao();
        dao.addExamResult(result);
    }
}
