package model.domain;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.List;

public class ExamResult {
    private final Timestamp dateTime;
    private final int reservationCode;
    private final int examCode;
    private final List<String> names;
    private final List<BigDecimal> values;
    public ExamResult(int reservationCode,Timestamp dateTime, int examCode, List<String> names, List<BigDecimal> values) {
        this.dateTime = dateTime;
        this.reservationCode = reservationCode;
        this.examCode= examCode;
        this.names = names;
        this.values = values;
    }

    public List<String> getNames() {
        return names;
    }

    public List<BigDecimal> getValues() {
        return values;
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
