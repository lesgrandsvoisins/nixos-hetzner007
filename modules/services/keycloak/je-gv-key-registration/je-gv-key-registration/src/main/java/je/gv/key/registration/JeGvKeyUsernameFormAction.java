package je.gv.key.registration;

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

public final class JeGvKeyUsernameFormAction implements FormAction {

    private static final String ATTR_GIVEN_NAME_FOR_ID = "firstName";
    private static final String ATTR_FAMILY_NAME_FOR_ID = "lastName";
    private static final int NAME_SLICE = 4;
    private static final Pattern NON_ASCII = Pattern.compile("[^a-z0-9]");
    private static final String DOMAIN = "@gv.je";

    private static final Set<String> BLOCKED_SUBSTRINGS = Set.of(
            "admin", "root", "support", "owner", "test", "demo",
            "sex", "anal", "puta", "mier", "fuck", "shit", "cunt");

    @Override
    public void buildPage(FormContext context, LoginFormsProvider form) {
        // Get existing values from the form data (if coming back from validation error)
        MultivaluedMap<String, String> formData = context.getHttpRequest().getDecodedFormParameters();
        String existingFirstName = formData.getFirst(ATTR_GIVEN_NAME_FOR_ID);
        String existingLastName = formData.getFirst(ATTR_FAMILY_NAME_FOR_ID);

        // Set form attributes
        form.setAttribute("firstName", existingFirstName);
        form.setAttribute("lastName", existingLastName);
        form.setAttribute("jeGvKeyUsernameRule", "family[:4] + given[:4] + counter + @gv.je");

        // If we have a generated username from a previous attempt, show it
        String generatedId = context.getAuthenticationSession().getAuthNote("gv_generated_identifier");
        if (generatedId != null) {
            form.setAttribute("generatedUsername", generatedId);
        }
    }

    @Override
    public void validate(ValidationContext context) {
        MultivaluedMap<String, String> formData = context.getHttpRequest().getDecodedFormParameters();
        List<FormMessage> errors = new ArrayList<>();

        // Get the name values from the form submission
        String family = formData.getFirst(ATTR_FAMILY_NAME_FOR_ID);
        String given = formData.getFirst(ATTR_GIVEN_NAME_FOR_ID);

        // Validate presence
        if (isBlank(family)) {
            errors.add(new FormMessage(ATTR_FAMILY_NAME_FOR_ID, "gvMissingFamilyNameForId"));
        }
        if (isBlank(given)) {
            errors.add(new FormMessage(ATTR_GIVEN_NAME_FOR_ID, "gvMissingGivenNameForId"));
        }

        if (!errors.isEmpty()) {
            context.error(Errors.INVALID_REGISTRATION);
            context.validationError(formData, errors);
            return;
        }

        // Generate the base identifier
        String base = normalizedSlice(family, NAME_SLICE) + normalizedSlice(given, NAME_SLICE);
        String identifier = nextAvailableIdentifier(context.getSession(), context.getRealm(), base);

        if (identifier == null) {
            errors.add(new FormMessage(null, "gvNoIdentifierAvailable"));
            context.error(Errors.INVALID_REGISTRATION);
            context.validationError(formData, errors);
            return;
        }

        // Store the generated username in the auth session
        context.getAuthenticationSession().setAuthNote("gv_generated_identifier", identifier);

        // Store the names for later use
        context.getAuthenticationSession().setAuthNote("gv_given_name", given);
        context.getAuthenticationSession().setAuthNote("gv_family_name", family);

        // Store the identifier in the form data so it gets passed to the next steps
        formData.putSingle("username", identifier);
        formData.putSingle("gv_generated_identifier", identifier);

        // if (identifier != null) {
        // // Set the username
        // formData.putSingle("username", identifier);

        // // CRITICAL: Set a flag that this was auto-generated
        // formData.putSingle("gv_generated_identifier", identifier);

        // // Also store in auth session for persistence across steps
        // context.getAuthenticationSession().setAuthNote("gv_generated_identifier",
        // identifier);

        // context.success();
        // }

        context.success();
    }

    @Override
    public void success(FormContext context) {
        // This runs after all validation succeeds, before user creation

        // Get the stored values
        String identifier = context.getAuthenticationSession().getAuthNote("gv_generated_identifier");
        String family = context.getAuthenticationSession().getAuthNote("gv_family_name");
        String given = context.getAuthenticationSession().getAuthNote("gv_given_name");

        if (identifier == null) {
            return;
        }

        // The UserModel doesn't exist yet at this point in FormAction
        // We'll set attributes on the authentication session for the user creation step
        context.getAuthenticationSession().setAuthNote("username", identifier);

        // // Store the short version without domain if needed
        // String shortUsername = Pattern.compile("@gv.je").matcher(identifier).replaceAll("");
        // context.getAuthenticationSession().setAuthNote("shortUsername", shortUsername);

        // These will be picked up by the user profile form
        MultivaluedMap<String, String> formData = context.getHttpRequest().getDecodedFormParameters();
        formData.putSingle("username", identifier);
        if (given != null) {
            formData.putSingle(ATTR_GIVEN_NAME_FOR_ID, given);
        }
        if (family != null) {
            formData.putSingle(ATTR_FAMILY_NAME_FOR_ID, family);
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

    static String nextAvailableIdentifier(KeycloakSession session, RealmModel realm, String base) {
        if (isBlank(base)) {
            return null;
        }

        for (int counter = 2; counter <= 9999; counter++) {
            String candidate = base + counter + DOMAIN;
            if (containsBlockedSubstring(candidate)) {
                continue;
            }
            if (session.users().getUserByUsername(realm, candidate) == null) {
                return candidate;
            }
        }
        return null;
    }

    static String normalizedSlice(String input, int maxLen) {
        if (isBlank(input)) {
            return "";
        }
        String normalized = Normalizer.normalize(input, Normalizer.Form.NFD)
                .replaceAll("\\p{M}+", "")
                .toLowerCase(Locale.ROOT)
                .replace("'", "")
                .replace("-", "")
                .replace(" ", "");
        normalized = NON_ASCII.matcher(normalized).replaceAll("");
        return normalized.length() <= maxLen ? normalized : normalized.substring(0, maxLen);
    }

    private static boolean containsBlockedSubstring(String candidate) {
        return BLOCKED_SUBSTRINGS.stream().anyMatch(candidate::contains);
    }

    static boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }
}