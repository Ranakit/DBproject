package model.dao;

import model.domain.ExamDiagnosis;
import model.domain.ExamResult;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.SQLException;

public class ExamResultsDao {
    public void addExamResult(ExamResult result){
        try {
            Connection conn = ConnectionFactory.getConnection();
            for (int i = 0; i < result.getNames().size(); i++) {
                CallableStatement statement = conn.prepareCall("{call registra_risultato(?, ?, ?, ?, ?)}");
                statement.setInt(1, result.getReservationCode());
                statement.setTimestamp(2, result.getDateTime());
                statement.setInt(3, result.getExamCode());
                statement.setString(4, result.getNames().get(i));
                statement.setBigDecimal(5, result.getValues().get(i));

                statement.execute();
            }
        }
        catch (SQLException e){
            System.out.println("error:" + e.getMessage().toString());
        }
    }

    public void addExamDiagnosis(ExamDiagnosis diagnosis) {
        try {
            Connection conn = ConnectionFactory.getConnection();
            CallableStatement statement = conn.prepareCall("{call registra_diagnosi(?, ?, ?, ?)}");
            statement.setString(1, diagnosis.getText());
            statement.setTimestamp(2, diagnosis.getDateTime());
            statement.setInt(3, diagnosis.getReservationCode());
            statement.setInt(4, diagnosis.getExamCode());

            statement.execute();
        }
        catch (SQLException e){
            System.out.println("error:" + e.getMessage().toString());
        }
    }
}
