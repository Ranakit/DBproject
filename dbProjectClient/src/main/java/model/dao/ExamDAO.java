package model.dao;

import java.sql.*;

public class ExamDAO {
    public void getExams(){
        try {
            Connection conn = ConnectionFactory.getConnection();
            CallableStatement statement = conn.prepareCall("{call lista_esami()}");
            ResultSet rs = statement.executeQuery();
            while (rs.next()) {
                int codiceEsame = rs.getInt("CodiceEsame");
                String descrizione = rs.getString("Descrizione");

                System.out.println(codiceEsame + ": " + descrizione);
            }
        }
        catch (SQLException e){
            System.out.println("error:" + e.getMessage().toString());
        }
    }

    public void getExamsReport(String code){
        try {
            Connection conn = ConnectionFactory.getConnection();
            CallableStatement statement = conn.prepareCall("{call storico_esami(?)}");
            statement.setString(1, code);
            ResultSet rs = statement.executeQuery();
            while (rs.next()) {
                Timestamp dataOra = rs.getTimestamp("DataOra");
                int codiceEsame = rs.getInt("Esame_CodiceEsame");
                String descrizione = rs.getString("Descrizione");
                double costo = rs.getDouble("Costo");
                boolean urgenza = rs.getBoolean("Urgenza");

                System.out.println(dataOra + " " + codiceEsame + " " + descrizione + " " + costo + " " + urgenza);
            }

        }
        catch (SQLException e){
            System.out.println("error:" + e.getMessage().toString());
        }
    }

    public void addExam(String name){
        try {
            Connection conn = ConnectionFactory.getConnection();
            CallableStatement statement = conn.prepareCall("{call registra_esame(?)}");
            statement.setString(1, name);

            statement.execute();
        }
        catch (SQLException e){
            System.out.println("error:" + e.getMessage().toString());
        }
    }

    public void AddDoneExam(String[] exam) {
        try {
            Connection conn = ConnectionFactory.getConnection();
            CallableStatement statement = conn.prepareCall("{call esami_svolti(?, ?)}");
            statement.setInt(1, Integer.parseInt(exam[0]));
            statement.setString(2, exam[1]);
            statement.execute();
        }
        catch (SQLException e){
            System.out.println("error: " + e.getMessage().toString());
        }
    }
}