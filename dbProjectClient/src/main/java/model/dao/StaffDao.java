package model.dao;

import java.sql.*;

public class StaffDao {
    public void getStaffReport(String basis){
        try {
            Connection conn = ConnectionFactory.getConnection();
            CallableStatement statement;

            if(basis.equals("m")) {
                statement = conn.prepareCall("{call report_personale_mensile()}");
                ResultSet rs = statement.executeQuery();
                printM(rs);
            }
            else if(basis.equals("y")) {
                statement = conn.prepareCall("{call report_personale_annuale()}");
                ResultSet rs = statement.executeQuery();
                printY(rs);
            }
            else {
                statement = conn.prepareCall("{call report_personale_mensile()}");
                ResultSet rs = statement.executeQuery();
                System.out.println("MONTHLY BASIS:");
                printM(rs);

                statement = conn.prepareCall("{call report_personale_annuale()}");
                rs = statement.executeQuery();
                System.out.println("ANNUAL BASIS:");
                printY(rs);
            }

        }
        catch (SQLException e){
            System.out.println("error:" + e.getMessage().toString());
        }
    }

    private void printY(ResultSet rs) {
        try {
            while (rs.next()) {
                String codiceFiscale = rs.getString("Personale_CodiceFiscale");
                int anno = rs.getInt("Anno");
                int numeroEsami = rs.getInt("NumeroEsami");

                System.out.println(codiceFiscale + " - " + anno + " - " + numeroEsami);
            }
        } catch (SQLException e) {
            System.out.println("error: " + e.getMessage().toString());
        }
    }

    private void printM(ResultSet rs) {
        try {
            while (rs.next()) {
                String codiceFiscale = rs.getString("Personale_CodiceFiscale");
                int mese = rs.getInt("Mese");
                int numeroEsami = rs.getInt("NumeroEsami");

                System.out.println(codiceFiscale + " - " + mese + " - " + numeroEsami);
            }
        } catch (SQLException e) {
            System.out.println("error: " + e.getMessage().toString());
        }
    }
}
