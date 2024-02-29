package model.dao;

import model.domain.Patient;
import java.sql.*;

public class AddPatientDAO {

    public void AddPatient(Patient patient){
        try {
            Connection conn = ConnectionFactory.getConnection();
            CallableStatement statement = conn.prepareCall("{call registra_paziente(?, ?, ?, ?, ?, ?)}");
            statement.setString(1, patient.getSanitaryCode());
            statement.setString(2,patient.getName());
            statement.setString(3, patient.getSurname());
            statement.setDate(4, patient.getBirthDate());
            statement.setString(5, patient.getBirthPlace());
            statement.setString(6, patient.getSurname());

            statement.execute();
        }
        catch (SQLException e){
            System.out.println("error: " + e.getMessage().toString());
        }
    }

    public void AddPhone(String[] strings){
        try {
            Connection conn = ConnectionFactory.getConnection();
            for (int i = 2; i < strings.length; i++){
                CallableStatement statement = conn.prepareCall("{call registra_telefono(?, ?)}");
                statement.setString(1, strings[i]);
                statement.setString(2, strings[0]);

                statement.execute();
            }
        }
        catch (SQLException e){
            System.out.println("error:" + e.getMessage().toString());
        }
    }

    public void AddCellphone(String[] strings){
        try {
            Connection conn = ConnectionFactory.getConnection();
            for (int i = 2; i < strings.length; i++){
                CallableStatement statement = conn.prepareCall("{call registra_cellulare(?, ?)}");
                statement.setString(1, strings[i]);
                statement.setString(2, strings[0]);

                statement.execute();
            }
        }
        catch (SQLException e){
            System.out.println("error:" + e.getMessage().toString());
        }
    }

    public void AddEmail(String[] strings){
        try {
            Connection conn = ConnectionFactory.getConnection();
            for (int i = 2; i < strings.length; i++){
                CallableStatement statement = conn.prepareCall("{call registra_email(?, ?)}");
                statement.setString(1, strings[i]);
                statement.setString(2, strings[0]);

                statement.execute();
            }
        }
        catch (SQLException e){
            System.out.println("error:" + e.getMessage());
        }
    }
}
