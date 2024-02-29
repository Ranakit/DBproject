package model.domain;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class Reservation {

    private final int reservationCode;
    private final Timestamp dateTime;
    private final int examCode;
    private final BigDecimal cost;
    private final boolean isUrgent;
    private final String patientCode;

    public Reservation(int reservationCode, Timestamp dateTime, int examCode, BigDecimal cost, boolean isUrgent, String patientCode){
        this.reservationCode = reservationCode;
        this.cost = cost;
        this.dateTime = dateTime;
        this.examCode = examCode;
        this.patientCode = patientCode;
        this.isUrgent = isUrgent;
    }
    public Timestamp getDateTime() {
        return dateTime;
    }

    public int getExamCode() {
        return examCode;
    }

    public BigDecimal getCost() {
        return cost;
    }

    public boolean isUrgent() {
        return isUrgent;
    }

    public String getPatientCode() {
        return patientCode;
    }

    public int getReservationCode() {
        return reservationCode;
    }
}
