package je.gv.key.registration;

import jakarta.ws.rs.core.MultivaluedMap;
import jakarta.ws.rs.core.Response;
import java.text.Normalizer;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.Set;
import java.util.regex.Pattern;
import org.keycloak.authentication.AuthenticationFlowContext;
import org.keycloak.authentication.AuthenticationFlowError;
import org.keycloak.authentication.Authenticator;
import org.keycloak.events.Errors;
import org.keycloak.models.KeycloakSession;
import org.keycloak.models.RealmModel;
import org.keycloak.models.UserModel;
import org.keycloak.models.utils.FormMessage;

public final class GvIdentifierAuthenticator implements Authenticator {

    private static final String ATTR_GIVEN_NAME_FOR_ID = "firstName";
    private static final String ATTR_FAMILY_NAME_FOR_ID = "lastName";
    private static final int NAME_SLICE = 4;
    private static final Pattern NON_ASCII = Pattern.compile("[^a-z0-9]");

    private static final Set<String> BLOCKED_SUBSTRINGS = Set.of(
        "admin", "root", "support", "owner", "test", "demo",
        "sex", "anal", "puta", "mier", "fuck", "shit", "cunt");

    private final KeycloakSession session;

    public GvIdentifierAuthenticator(KeycloakSession session) {
        this.session = session;
    }

    @Override
    public void authenticate(AuthenticationFlowContext context) {
        MultivaluedMap<String, String> formData = context.getHttpRequest().getDecodedFormParameters();
        
        // Check if we already have a generated identifier (from a previous step)
        String existingIdentifier = context.getAuthenticationSession().getAuthNote("gv_generated_identifier");
        
        if (existingIdentifier != null) {
            // Already generated, proceed
            context.success();
            return;
        }

        String family = firstNonBlank(
            field(formData, "user.attributes." + ATTR_FAMILY_NAME_FOR_ID),
            field(formData, ATTR_FAMILY_NAME_FOR_ID),
            field(formData, "lastName"));
        String given = firstNonBlank(
            field(formData, "user.attributes." + ATTR_GIVEN_NAME_FOR_ID),
            field(formData, ATTR_GIVEN_NAME_FOR_ID),
            field(formData, "firstName"));

        // If we don't have the names yet, show the form
        if (isBlank(family) || isBlank(given)) {
            Response challenge = context.form()
                .setAttribute("gvIdentifierRule", "family[:4] + given[:4] + counter")
                .setAttribute("gvIdentifierFields", List.of(ATTR_FAMILY_NAME_FOR_ID, ATTR_GIVEN_NAME_FOR_ID))
                .createForm("gv-identifier.ftl");
            context.challenge(challenge);
            return;
        }

        // Validate and generate identifier
        List<FormMessage> errors = new ArrayList<>();

        if (isBlank(family)) {
            errors.add(new FormMessage("user.attributes." + ATTR_FAMILY_NAME_FOR_ID, "gvMissingFamilyNameForId"));
        }
        if (isBlank(given)) {
            errors.add(new FormMessage("user.attributes." + ATTR_GIVEN_NAME_FOR_ID, "gvMissingGivenNameForId"));
        }

        if (!errors.isEmpty()) {
            context.getEvent().error(Errors.INVALID_REGISTRATION);
            Response challenge = context.form()
                .setErrors(errors)
                .setAttribute("gvIdentifierRule", "family[:4] + given[:4] + counter")
                .setAttribute("gvIdentifierFields", List.of(ATTR_FAMILY_NAME_FOR_ID, ATTR_GIVEN_NAME_FOR_ID))
                .createForm("gv-identifier.ftl");
            context.failureChallenge(AuthenticationFlowError.INVALID_USER, challenge);
            return;
        }

        String base = normalizedSlice(family, NAME_SLICE) + normalizedSlice(given, NAME_SLICE);
        String identifier = nextAvailableIdentifier(context.getSession(), context.getRealm(), base);

        if (identifier == null) {
            errors.add(new FormMessage(null, "gvNoIdentifierAvailable"));
            context.getEvent().error(Errors.INVALID_REGISTRATION);
            Response challenge = context.form()
                .setErrors(errors)
                .createForm("gv-identifier.ftl");
            context.failureChallenge(AuthenticationFlowError.GENERIC_AUTHENTICATION_ERROR, challenge);
            return;
        }

        // Store the generated identifier in the auth session
        context.getAuthenticationSession().setAuthNote("gv_generated_identifier", identifier);
        context.getAuthenticationSession().setAuthNote("gv_given_name", given);
        context.getAuthenticationSession().setAuthNote("gv_family_name", family);
        
        // Also store in formData for the success phase
        MultivaluedMap<String, String> currentForm = context.getHttpRequest().getDecodedFormParameters();
        currentForm.putSingle("gv_generated_identifier", identifier);
        currentForm.putSingle("username", identifier);
        
        context.success();
    }

    @Override
    public void action(AuthenticationFlowContext context) {
        // Form submission comes here
        authenticate(context);
    }

    @Override
    public boolean requiresUser() {
        return false; // User doesn't exist yet during registration
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

    // ========== Helper Methods (copied from original) ==========

    static String nextAvailableIdentifier(KeycloakSession session, RealmModel realm, String base) {
        if (isBlank(base)) {
            return null;
        }

        for (int counter = 2; counter <= 9999; counter++) {
            String candidate = base + counter;
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

    private static String field(MultivaluedMap<String, String> formData, String key) {
        return formData == null ? null : formData.getFirst(key);
    }

    private static String firstNonBlank(String... values) {
        for (String value : values) {
            if (!isBlank(value)) {
                return value;
            }
        }
        return null;
    }

    static boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }
}