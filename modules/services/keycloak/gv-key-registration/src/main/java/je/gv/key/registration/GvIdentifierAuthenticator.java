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
        
        // Check if we already have generated values (after successful generation)
        String existingIdentifier = context.getAuthenticationSession().getAuthNote("gv_generated_identifier");
        
        if (existingIdentifier != null) {
            // We've already generated the identifier, proceed to main registration
            context.success();
            return;
        }

        // Get form values - they might come from the main registration form
        String family = getFormValue(formData, ATTR_FAMILY_NAME_FOR_ID);
        String given = getFormValue(formData, ATTR_GIVEN_NAME_FOR_ID);

        // If we have both names, generate the identifier and continue
        if (!isBlank(family) && !isBlank(given)) {
            List<FormMessage> errors = new ArrayList<>();

            String base = normalizedSlice(family, NAME_SLICE) + normalizedSlice(given, NAME_SLICE);
            String identifier = nextAvailableIdentifier(context.getSession(), context.getRealm(), base);

            if (identifier == null) {
                errors.add(new FormMessage(null, "gvNoIdentifierAvailable"));
                context.getEvent().error(Errors.INVALID_REGISTRATION);
                Response challenge = context.form()
                    .setErrors(errors)
                    .setAttribute("gvIdentifierRule", "family[:4] + given[:4] + counter")
                    .createForm("gv-identifier.ftl");
                context.failureChallenge(AuthenticationFlowError.GENERIC_AUTHENTICATION_ERROR, challenge);
                return;
            }

            // Store the generated identifier in auth session
            context.getAuthenticationSession().setAuthNote("gv_generated_identifier", identifier);
            
            // CRITICAL: Store the identifier in a place where the main form can find it
            // We'll add it to the form data that gets passed to the next steps
            formData.putSingle("username", identifier);
            formData.putSingle("gv_generated_identifier", identifier);
            
            // Also store original names for reference
            context.getAuthenticationSession().setAuthNote("gv_given_name", given);
            context.getAuthenticationSession().setAuthNote("gv_family_name", family);
            
            formData.putSingle("gv_given_name", given);
            formData.putSingle("gv_family_name", family);
            formData.putSingle("firstName", given);
            formData.putSingle("lastName", family);
            

            context.success();
            return;
        }

        // If we don't have the names yet, show our form
        Response challenge = context.form()
            .setAttribute("gvIdentifierRule", "family[:4] + given[:4] + counter")
            .setAttribute("gvIdentifierFields", List.of(ATTR_FAMILY_NAME_FOR_ID, ATTR_GIVEN_NAME_FOR_ID))
            // Pass any existing values back to the form
            .setAttribute("firstName", family)
            .setAttribute("lastName", given)
            .createForm("gv-identifier.ftl");
        context.challenge(challenge);
    }

    @Override
    public void action(AuthenticationFlowContext context) {
        // Form submission comes here
        authenticate(context);
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

    private String getFormValue(MultivaluedMap<String, String> formData, String fieldName) {
        // Try multiple possible field names that the main form might use
        String value = field(formData, "user.attributes." + fieldName);
        if (!isBlank(value)) return value;
        
        value = field(formData, fieldName);
        if (!isBlank(value)) return value;
        
        if ("firstName".equals(fieldName)) {
            value = field(formData, "givenName");
            if (!isBlank(value)) return value;
        }
        
        if ("lastName".equals(fieldName)) {
            value = field(formData, "familyName");
            if (!isBlank(value)) return value;
        }
        
        return null;
    }

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

    static boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }
}