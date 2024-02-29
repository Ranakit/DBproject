package controller;


import model.dao.LoginProcedureDAO;
import model.domain.Credentials;
import view.LoginView;

import java.io.IOException;

public class LoginController implements Controller {
    Credentials cred = null;

    @Override
    public void start() {
        try {
            cred = LoginView.authenticate();
        } catch(IOException e) {
            throw new RuntimeException(e);
        }

            cred = new LoginProcedureDAO().execute(cred.getUsername(), cred.getPassword());
     }

    public Credentials getCred() {
        return cred;
    }
}

