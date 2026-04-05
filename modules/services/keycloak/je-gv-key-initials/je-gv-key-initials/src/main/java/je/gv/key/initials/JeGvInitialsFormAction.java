package je.gv.key.initials;

import jakarta.ws.rs.core.MultivaluedMap;
// import jakarta.ws.rs.core.Response;
import java.text.Normalizer;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.Set;
import java.util.regex.Pattern;
import org.keycloak.authentication.FormAction;
import org.keycloak.authentication.FormContext;
import org.keycloak.authentication.ValidationContext;
import org.keycloak.events.Errors;
import org.keycloak.forms.login.LoginFormsProvider;
import org.keycloak.models.KeycloakSession;
import org.keycloak.models.RealmModel;
import org.keycloak.models.UserModel;
import org.keycloak.models.utils.FormMessage;

public final class JeGvInitialsFormAction implements FormAction {

    private static final String ATTR_USERNAME_FOR_ID = "username";
    private static final Pattern NON_ASCII = Pattern.compile("[^a-z0-9]");

    private static final Set<String> BLOCKED_SUBSTRINGS = Set.of(
            "admin", "root", "support", "owner", "test", "demo",
            "sex", "anal", "puta", "mier", "fuck", "shit", "cunt");

    @Override
    public void buildPage(FormContext context, LoginFormsProvider form) {
        // Get existing values from the form data (if coming back from validation error)
        MultivaluedMap<String, String> formData = context.getHttpRequest().getDecodedFormParameters();
        String existingUsername = formData.getFirst(ATTR_USERNAME_FOR_ID);

        // Set form attributes
        form.setAttribute("username", existingUsername);

        // If we have a generated username from a previous attempt, show it
        String generatedId = context.getAuthenticationSession().getAuthNote("gv_generated_initials");
        if (generatedId != null) {
            form.setAttribute("initials", generatedId);
        }
    }

    @Override
    public void validate(ValidationContext context) {
        MultivaluedMap<String, String> formData = context.getHttpRequest().getDecodedFormParameters();
        List<FormMessage> errors = new ArrayList<>();

        // Get the name values from the form submission
        String username = formData.getFirst(ATTR_USERNAME_FOR_ID);

        // Validate presence
        if (isBlank(username)) {
            errors.add(new FormMessage(ATTR_USERNAME_FOR_ID, "gvMissingUsernameForId"));
        }

        if (!errors.isEmpty()) {
            context.error(Errors.INVALID_REGISTRATION);
            context.validationError(formData, errors);
            return;
        }

        // Generate the base initials
        String initials = username.split("@")[0];
        // String initials = nextAvailableIdentifier(context.getSession(), context.getRealm(), base);

        // if (initials == null) {
        //     errors.add(new FormMessage(null, "gvNoIdentifierAvailable"));
        //     context.error(Errors.INVALID_REGISTRATION);
        //     context.validationError(formData, errors);
        //     return;
        // }

        // Store the generated username in the auth session
        context.getAuthenticationSession().setAuthNote("gv_generated_initials", initials);

        // Store the names for later use
        context.getAuthenticationSession().setAuthNote("gv_username", username);

        // Store the initials in the form data so it gets passed to the next steps
        formData.putSingle("username", username);
        formData.putSingle("gv_generated_initials", initials);
        formData.putSingle("initials", initials);

        // if (initials != null) {
        // // Set the username
        // formData.putSingle("username", initials);

        // // CRITICAL: Set a flag that this was auto-generated
        // formData.putSingle("gv_generated_initials", initials);

        // // Also store in auth session for persistence across steps
        // context.getAuthenticationSession().setAuthNote("gv_generated_initials",
        // initials);

        // context.success();
        // }

        context.success();
    }

    @Override
    public void success(FormContext context) {
        // This runs after all validation succeeds, before user creation

        // Get the stored values
        String initials = context.getAuthenticationSession().getAuthNote("gv_generated_initials");
        String username = context.getAuthenticationSession().getAuthNote("username");

        if (initials == null) {
            return;
        }

        // The UserModel doesn't exist yet at this point in FormAction
        // We'll set attributes on the authentication session for the user creation step
        // context.getAuthenticationSession().setAuthNote("username", username);

        // Store the short version without domain if needed
        // String shortUsername = Pattern.compile("@gv.je").matcher(initials).replaceAll("");
        // context.getAuthenticationSession().setAuthNote("shortUsername", shortUsername);

        // These will be picked up by the user profile form
        MultivaluedMap<String, String> formData = context.getHttpRequest().getDecodedFormParameters();
        formData.putSingle("initials", initials);
        if (username != null) {
            formData.putSingle(ATTR_USERNAME_FOR_ID, username);
        }
    }

    @Override
    public boolean requiresUser() {
        return false;
    }

    @Override
    public boolean configuredFor(KeycloakSession session, RealmModel realm, UserModel user) {
        return true;
    }

    @Override
    public void setRequiredActions(KeycloakSession session, RealmModel realm, UserModel user) {
        // No-op
    }

    @Override
    public void close() {
        // No-op
    }

    // ========== Helper Methods ==========



    private static boolean containsBlockedSubstring(String candidate) {
        return BLOCKED_SUBSTRINGS.stream().anyMatch(candidate::contains);
    }

    static boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }
}