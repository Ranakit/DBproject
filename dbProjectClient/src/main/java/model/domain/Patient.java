package model.domain;

import java.sql.Date;

public class Patient {
    private final String name;
    private final String surname;
    private final String sanitaryCode;
    private final Date birthDate;
    private final String birthPlace;
    private final String address;


    public Patient(String sanitaryCode, String name, String surname, Date birthDate, String birthPlace, String address) {
        this.sanitaryCode = sanitaryCode;
        this.name = name;
        this.surname = surname;
        this.birthDate = birthDate;
        this.address = address;
        this.birthPlace = birthPlace;
    }
    public String getName() {
        return name;
    }

    public Date getBirthDate() {
        return birthDate;
    }

    public String getBirthPlace() {
        return birthPlace;
    }

    public String getSanitaryCode() {
        return sanitaryCode;
    }

    public String getSurname() {
        return surname;
    }
}
