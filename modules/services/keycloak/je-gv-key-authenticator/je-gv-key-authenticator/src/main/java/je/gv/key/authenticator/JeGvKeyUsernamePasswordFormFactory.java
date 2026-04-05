package je.gv.key.authenticator;

import org.keycloak.authentication.Authenticator;
import org.keycloak.authentication.authenticators.browser.UsernamePasswordFormFactory;
import org.keycloak.models.KeycloakSession;

import je.gv.key.authenticator.JeGvKeyUsernamePasswordForm;

public class JeGvKeyUsernamePasswordFormFactory extends UsernamePasswordFormFactory {

    public static final String ID = "je-gv-auth-form";

    @Override
    public Authenticator create(KeycloakSession session) {
        return new JeGvKeyUsernamePasswordForm();
    }

    @Override
    public String getId() {
        return ID;
    }

    @Override
    public String getDisplayType() {
        return "GV.je Username Password Form (append @gv.je)";
    }

    @Override
    public String getHelpText() {
        return "GV.je Username/password form that appends @gv.je if missing.";
    }
}