package je.gv.key.authenticator;

import org.keycloak.authentication.AuthenticationFlowContext;
import org.keycloak.authentication.Authenticator;
import org.keycloak.models.UserModel;
import org.keycloak.services.messages.Messages;
import org.keycloak.authentication.AuthenticationFlowError;
// import org.keycloak.events.Errors;

import jakarta.ws.rs.core.MultivaluedMap;

public class JeGvKeyAuthenticator implements Authenticator {

    private static final String SUFFIX = "@gv.je";



    @Override
    public void authenticate(AuthenticationFlowContext context) {
        MultivaluedMap<String, String> formData = context.getHttpRequest().getDecodedFormParameters();

        String username = formData.getFirst("username");


        if (username != null && !username.endsWith(SUFFIX) && !username.contains("@")) {
            username = username + SUFFIX;
            formData.putSingle("username", username);
        }
        if (username != null && username.endsWith("@@")) {
            username = username.substring(0, username.length() - 2);
            formData.putSingle("username", username);
        }

        context.success();
    }

    // @Override
    // public void authenticate(AuthenticationFlowContext context) {
    //     MultivaluedMap<String, String> params = context.getHttpRequest().getDecodedFormParameters();
    //     String username = params.getFirst("username");




    //     UserModel user = context.getSession()
    //             .users()
    //             .getUserByUsername(context.getRealm(), username);

    //     if (user == null) {
    //         context.failure(AuthenticationFlowError.INVALID_USER);
    //         return;
    //     }

    //     context.setUser(user);
    //     context.success();
    // }

    @Override
    public void action(AuthenticationFlowContext context) {
        // Not used
        context.success();
    }

    @Override
    public boolean requiresUser() {
        return false;
    }

    @Override
    public boolean configuredFor(org.keycloak.models.KeycloakSession session,
                                 org.keycloak.models.RealmModel realm,
                                 UserModel user) {
        return true;
    }

    @Override
    public void setRequiredActions(org.keycloak.models.KeycloakSession session,
                                   org.keycloak.models.RealmModel realm,
                                   UserModel user) {}

    @Override
    public void close() {}
}