package je.gv.key.authenticator;

import je.gv.key.authenticator.GvJeKeyAuthenticator;
import org.keycloak.authentication.Authenticator;
import org.keycloak.authentication.AuthenticatorFactory;
import org.keycloak.models.KeycloakSession;
import org.keycloak.models.KeycloakSessionFactory;
import org.keycloak.provider.ProviderConfigProperty;

import org.keycloak.models.AuthenticationExecutionModel;

import java.util.List;

public class GvJeKeyAuthenticatorFactory implements AuthenticatorFactory {

    public static final String ID = "gv-je-key-authenticator";

    @Override
    public Authenticator create(KeycloakSession session) {
        return new GvJeKeyAuthenticator();
    }

    @Override
    public void init(org.keycloak.Config.Scope config) {}

    @Override
    public void postInit(KeycloakSessionFactory factory) {}

    @Override
    public void close() {}

    @Override
    public String getId() {
        return ID;
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
        return ID;
    }


    @Override
    public String getDisplayType() {
        return "Append @gv.je to Username";
    }

    @Override
    public String getHelpText() {
        return "Automatically appends @gv.je to the username before authentication.";
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