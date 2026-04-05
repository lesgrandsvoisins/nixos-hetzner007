package je.gv.key.authenticator;

import jakarta.ws.rs.core.MultivaluedMap;
import org.keycloak.authentication.AuthenticationFlowContext;
import org.keycloak.authentication.authenticators.browser.UsernamePasswordForm;
// import org.jboss.logging.Logger;
import org.keycloak.models.UserModel;

import jakarta.ws.rs.core.MultivaluedMap;

public class JeGvKeyUsernamePasswordForm extends UsernamePasswordForm {
  // private static final Logger LOG =
  // Logger.getLogger(JeGvKeyUsernamePasswordForm.class);
  private static final String DOMAIN = "@gv.je";

  @Override
  public boolean validateUserAndPassword(AuthenticationFlowContext context,
      MultivaluedMap<String, String> inputData) {

    String username = inputData.getFirst("username");

    // LOG.infof("Original username: %s", username);

    if (username != null && !username.endsWith(DOMAIN) && !username.contains("@")) {
      username = username + DOMAIN;
    }

    if (username != null && username.endsWith("@@")) {
      username = username.substring(username.length() - 2);
    }

    // LOG.infof("Updated username: %s", username);

    // Fetch the actual user by updated username
    UserModel user = context.getSession().users().getUserByUsername(context.getRealm(), username);

    if (user == null) {
      // LOG.warnf("No user found with username: %s", username);
      return super.validateUserAndPassword(context, inputData);
    }
    // Set the user in context before continuing
    context.setUser(user);

    // Replace username in inputData so password check works
    inputData.putSingle("username", username);

    // Delegate to the normal password check with the user already set
    return super.validateUserAndPassword(context, inputData);
  }
}
