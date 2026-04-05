package je.gv.key.authenticator;

import jakarta.ws.rs.core.MultivaluedMap;
import org.keycloak.authentication.AuthenticationFlowContext;
import org.keycloak.authentication.authenticators.browser.UsernamePasswordForm;
import org.jboss.logging.Logger;

import jakarta.ws.rs.core.MultivaluedMap;

public class JeGvKeyUsernamePasswordForm extends UsernamePasswordForm {
  private static final Logger LOG = Logger.getLogger(JeGvKeyUsernamePasswordForm.class);
  private static final String DOMAIN = "@gv.je";

  @Override
  protected boolean validateForm(AuthenticationFlowContext context,
      MultivaluedMap<String, String> inputData) {

    String username = inputData.getFirst("username");

    LOG.infof("Original username: %s", username);

    if (username != null && !username.endsWith(DOMAIN) && !username.contains("@")) {
      username = username + DOMAIN;
    }

    if (username != null && username.endsWith("@@")) {
      username = username.substring(username.length() - 2);
    }

    LOG.infof("Updated username: %s", username);

    return super.validateForm(context, inputData);
  }
}
