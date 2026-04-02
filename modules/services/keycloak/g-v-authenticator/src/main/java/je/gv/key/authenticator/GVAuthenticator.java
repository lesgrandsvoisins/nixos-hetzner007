package je.gv.key.authenticator;

import jakarta.ws.rs.core.MultivaluedMap;
import jakarta.ws.rs.core.Response;
import org.keycloak.authentication.AuthenticationFlowContext;
import org.keycloak.authentication.Authenticator;
import org.keycloak.models.KeycloakSession;
import org.keycloak.models.RealmModel;
import org.keycloak.models.UserModel;
import org.keycloak.sessions.AuthenticationSessionModel;
import org.keycloak.authentication.AuthenticationFlowError;

public class GVAuthenticator implements Authenticator {

    private final KeycloakSession session;

    public GVAuthenticator(KeycloakSession session) {
        this.session = session;
    }

    @Override
    public void authenticate(AuthenticationFlowContext context) {
        MultivaluedMap<String, String> formData = context.getHttpRequest().getDecodedFormParameters();
        String inviteCode = formData.getFirst("inviteCode");

        // If no invite code provided yet, show the form
        if (inviteCode == null || inviteCode.isEmpty()) {
            Response challenge = context.form()
                .createForm("g-v-authenticator.ftl");
            context.challenge(challenge);
            return;
        }

        // Validate the invite code
        if (isValidInviteCode(inviteCode)) {
            // Store verification in session for later use
            context.getAuthenticationSession().setAuthNote("inviteCodeValidated", "true");
            context.success();
        } else {
            // Invalid code - show error and challenge again
            Response challenge = context.form()
                .setError("Invalid invitation code. Please try again.")
                .createForm("g-v-authenticator.ftl");
            context.failureChallenge(AuthenticationFlowError.INVALID_CREDENTIALS, challenge);
        }
    }

    private boolean isValidInviteCode(String code) {
        // Your validation logic here
        // Could check against database, cache, or external service
        return "VALID2024".equals(code);
    }

    @Override
    public void action(AuthenticationFlowContext context) {
        // Form submission comes here - redirect to authenticate for processing
        authenticate(context);
    }

    @Override
    public boolean requiresUser() {
        // For registration flow, user doesn't exist yet
        return false;
    }

    @Override
    public boolean configuredFor(KeycloakSession session, RealmModel realm, UserModel user) {
        return true;
    }

    @Override
    public void setRequiredActions(KeycloakSession session, RealmModel realm, UserModel user) {
        // No required actions needed
    }

    @Override
    public void close() {
        // Cleanup if needed
    }
}