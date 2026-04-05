package je.gv.key.authenticator;

import je.gv.key.authenticator.JeGvKeyAuthenticator;
import org.keycloak.authentication.Authenticator;
import org.keycloak.authentication.AuthenticatorFactory;
import org.keycloak.models.KeycloakSession;
import org.keycloak.models.KeycloakSessionFactory;
import org.keycloak.provider.ProviderConfigProperty;

import org.keycloak.models.AuthenticationExecutionModel;

import java.util.List;

public class JeGvKeyAuthenticatorFactory implements AuthenticatorFactory {


    public static final String PROVIDER_ID = "gv-je-key-authenticator";
    private static final String DISPLAY_TYPE = "GV.je @gv.je append suffixe";
    private static final String HELP_TEXT = "Adds @gv.je before validating";


    @Override
    public Authenticator create(KeycloakSession session) {
        return new JeGvKeyAuthenticator();
    }

    @Override
    public void init(org.keycloak.Config.Scope config) {}

    @Override
    public void postInit(KeycloakSessionFactory factory) {}

    @Override
    public void close() {}

    @Override
    public String getId() {
        return PROVIDER_ID;
    }

    @Override
    public AuthenticationExecutionModel.Requirement[] getRequirementChoices() {
        return new AuthenticationExecutionModel.Requirement[]{
            AuthenticationExecutionModel.Requirement.REQUIRED,
            AuthenticationExecutionModel.Requirement.ALTERNATIVE,
            AuthenticationExecutionModel.Requirement.DISABLED
        };
    }


    @Override
    public String getReferenceCategory() {
        return PROVIDER_ID;
    }


    @Override
    public String getDisplayType() {
        return DISPLAY_TYPE;
    }

    @Override
    public String getHelpText() {
        return HELP_TEXT;
    }

    @Override
    public List<ProviderConfigProperty> getConfigProperties() {
        return List.of();
    }

    @Override
    public boolean isConfigurable() {
        return false;
    }

    @Override
    public boolean isUserSetupAllowed() {
        return false;
    }
}