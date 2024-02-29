package model.dao;

import model.domain.Reservation;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;

public class ReservationDAO {

    public void reservationReport(int code) {
        try {
            Connection conn = ConnectionFactory.getConnection();
            CallableStatement cs = conn.prepareCall("{call report_prenotazioni(?)}");
            cs.setInt(1, code);
            ResultSet rs = cs.executeQuery();
            while (rs.next()) {
                String nome = rs.getString("Nome");
                double valore = rs.getDouble("Valore");

                System.out.println(nome + ": " + valore);
           }
        }
        catch (SQLException e){
            System.out.println("error:" + e.getMessage());
        }
    }

    public void AddReservation(Reservation reservation){
        try {
            Connection conn = ConnectionFactory.getConnection();
            CallableStatement statement = conn.prepareCall("{call registra_prenotazione(?, ?, ?, ?, ?, ?)}");
            statement.setInt(1, reservation.getReservationCode());
            statement.setTimestamp(2, reservation.getDateTime());
            statement.setInt(3, reservation.getExamCode());
            statement.setBigDecimal(4, reservation.getCost());
            statement.setBoolean(5, reservation.isUrgent());
            statement.setString(6, reservation.getPatientCode());

            statement.execute();
        }
        catch (SQLException e){
            System.out.println("error: " + e.getMessage().toString());
        }
    }
}
