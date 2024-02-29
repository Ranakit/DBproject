package model.domain;

import java.sql.Timestamp;

public class ExamDiagnosis {
    private final Timestamp dateTime;
    private final int reservationCode;
    private final int examCode;
    private final String text;

    public ExamDiagnosis(String text, Timestamp dateTime, int reservationCode, int examCode) {
        this.dateTime = dateTime;
        this.reservationCode = reservationCode;
        this.examCode= examCode;
        this.text = text;
    }

    public String getText() {
        return text;
    }

    public int getReservationCode() {
        return reservationCode;
    }

    public int getExamCode() {
        return examCode;
    }

    public Timestamp getDateTime() {
        return dateTime;
    }
}
