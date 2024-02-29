package controller;


import model.domain.Credentials;

public class ApplicationController implements Controller {
    Credentials cred;

    @Override
    public void start() {
        LoginController loginController = new LoginController();
        loginController.start();
        cred = loginController.getCred();

        if(cred.getRole() == null) {
            throw new RuntimeException("Invalid credentials");
        }

        switch(cred.getRole()) {
            case CUP -> new CUPController().start();
            case AMMINISTRATORE -> new AmministratoreController().start();
            case MEDICO -> new MedicoController().start();
            default -> throw new RuntimeException("Invalid credentials");
        }
    }
}
