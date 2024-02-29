package model.dao;

import model.domain.Credentials;
import model.domain.Role;

import java.sql.*;

public class LoginProcedureDAO {

    public Credentials execute(Object... params){
        String username = (String) params[0];
        String password = (String) params[1];
        int role = 0;

        try {
            Connection conn = ConnectionFactory.getConnection();
            CallableStatement cs = conn.prepareCall("{call login(?,?,?)}");
            cs.setString(1, username);
            cs.setString(2, password);
            cs.registerOutParameter(3, Types.NUMERIC);
            cs.executeQuery();
            role = cs.getInt(3);
        } catch(SQLException e) {
            System.out.println("Login error: " + e.getMessage().toString());
        }
        return new Credentials(username, password, Role.fromInt(role));
    }
}
