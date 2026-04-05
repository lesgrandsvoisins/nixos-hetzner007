package je.gv.key.authenticator;

import jakarta.ws.rs.core.MultivaluedMap;
import org.keycloak.authentication.AuthenticationFlowContext;
import org.keycloak.authentication.authenticators.browser.UsernamePasswordForm;

import jakarta.ws.rs.core.MultivaluedMap;

public class JeGvKeyUsernamePasswordForm extends UsernamePasswordForm {

  private static final String DOMAIN = "@gv.je";

  @Override
  protected boolean validateForm(AuthenticationFlowContext context,
      MultivaluedMap<String, String> inputData) {
    String username = inputData.getFirst("username");

    if (username != null && !username.endsWith(DOMAIN) && !username.contains("@")) {
      username = username + DOMAIN;
    }

    if (username != null && username.endsWith("@@")) {
      username = username + DOMAIN;
    }

    return super.validateForm(context, inputData);
  }
}
