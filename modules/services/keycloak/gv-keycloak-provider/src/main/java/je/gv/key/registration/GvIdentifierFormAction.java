package je.gv.key.registration;

import jakarta.ws.rs.core.MultivaluedMap;
import java.text.Normalizer;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
// import java.util.Objects;
import java.util.Set;
import java.util.regex.Pattern;
// import org.keycloak.Config;
import org.keycloak.authentication.FormAction;
import org.keycloak.authentication.FormContext;
import org.keycloak.authentication.ValidationContext;
import org.keycloak.events.Errors;
import org.keycloak.forms.login.LoginFormsProvider;
import org.keycloak.models.KeycloakSession;
import org.keycloak.models.RealmModel;
import org.keycloak.models.UserModel;
import org.keycloak.models.utils.FormMessage;

public final class GvIdentifierFormAction implements FormAction {

  // private static final String ATTR_GIVEN_NAME_FOR_ID = "given_name_for_id";
  // private static final String ATTR_FAMILY_NAME_FOR_ID = "family_name_for_id";
  private static final String ATTR_GIVEN_NAME_FOR_ID = "firstName";
  private static final String ATTR_FAMILY_NAME_FOR_ID = "lastName";
  private static final int NAME_SLICE = 4;
  private static final Pattern NON_ASCII = Pattern.compile("[^a-z0-9]");
  private static final String ATDOMAIN = "@gv.je";

  /**
   * Keep this short and editable. The goal is just to avoid obviously awkward
   * auto-generated usernames.
   */
  private static final Set<String> BLOCKED_SUBSTRINGS = Set.of(
      "admin", "root", "support", "owner", "test", "demo",
      "sex", "anal", "puta", "mier", "fuck", "shit", "cunt");

  @Override
  public void buildPage(FormContext context, LoginFormsProvider form) {
    form.setAttribute("gvIdentifierRule", "family[:4] + given[:4] + counter");
    form.setAttribute("gvIdentifierFields", List.of(ATTR_FAMILY_NAME_FOR_ID, ATTR_GIVEN_NAME_FOR_ID));
  }

  @Override
  public void validate(ValidationContext context) {
    MultivaluedMap<String, String> formData = context.getHttpRequest().getDecodedFormParameters();
    List<FormMessage> errors = new ArrayList<>();

    String family = firstNonBlank(
        field(formData, "user.attributes." + ATTR_FAMILY_NAME_FOR_ID),
        field(formData, ATTR_FAMILY_NAME_FOR_ID),
        field(formData, "lastName"));
    String given = firstNonBlank(
        field(formData, "user.attributes." + ATTR_GIVEN_NAME_FOR_ID),
        field(formData, ATTR_GIVEN_NAME_FOR_ID),
        field(formData, "firstName"));

    if (isBlank(family)) {
      errors.add(new FormMessage("user.attributes." + ATTR_FAMILY_NAME_FOR_ID, "gvMissingFamilyNameForId"));
    }
    if (isBlank(given)) {
      errors.add(new FormMessage("user.attributes." + ATTR_GIVEN_NAME_FOR_ID, "gvMissingGivenNameForId"));
    }

    if (!errors.isEmpty()) {
      context.error(Errors.INVALID_REGISTRATION);
      context.validationError(formData, errors);
      return;
    }

    String base = normalizedSlice(family, NAME_SLICE) + normalizedSlice(given, NAME_SLICE);
    String identifier = nextAvailableIdentifier(context.getSession(), context.getRealm(), base);

    if (identifier == null) {
      errors.add(new FormMessage(null, "gvNoIdentifierAvailable"));
      context.error(Errors.INVALID_REGISTRATION);
      context.validationError(formData, errors);
      return;
    }

    // Keep the generated username around for the success() phase and for optional
    // template preview.
    formData.putSingle("gv_generated_identifier", identifier);
    formData.putSingle("username", identifier);
    // formData.putSingle("shortName",
    // Pattern.compile(ATDOMAIN).matcher(identifier).replaceAll(""));

    context.success();
  }

  @Override
  public void success(FormContext context) {

    MultivaluedMap<String, String> formData = context.getHttpRequest().getDecodedFormParameters();

    String identifier = field(formData, "gv_generated_identifier");
    String shortUsername = Pattern.compile(ATDOMAIN).matcher(identifier).replaceAll("");

    String family = firstNonBlank(
        field(formData, "user.attributes." + ATTR_FAMILY_NAME_FOR_ID),
        field(formData, ATTR_FAMILY_NAME_FOR_ID),
        field(formData, "lastName"));
    String given = firstNonBlank(
        field(formData, "user.attributes." + ATTR_GIVEN_NAME_FOR_ID),
        field(formData, ATTR_GIVEN_NAME_FOR_ID),
        field(formData, "firstName"));
    UserModel user = context.getUser();
    if (user == null) {
      return;
    }
    if (!isBlank(shortUsername)) {
      user.setSingleAttribute("shortUsername", shortUsername.trim());
    }
    if (!isBlank(identifier)) {
      user.setUsername(identifier);
    }

    if (!isBlank(given)) {
      user.setSingleAttribute(ATTR_GIVEN_NAME_FOR_ID, given.trim());
    }
    if (!isBlank(family)) {
      user.setSingleAttribute(ATTR_FAMILY_NAME_FOR_ID, family.trim());
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
    // No-op.
  }

  @Override
  public void close() {
    // No-op.
  }

  static String nextAvailableIdentifier(KeycloakSession session, RealmModel realm, String base) {
    if (isBlank(base)) {
      return null;
    }

    for (int counter = 2; counter <= 9999; counter++) {
      String candidate = base + counter+ ATDOMAIN;
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
