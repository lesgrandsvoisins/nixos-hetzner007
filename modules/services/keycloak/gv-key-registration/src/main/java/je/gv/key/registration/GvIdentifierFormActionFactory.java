package je.gv.key.registration;

import org.keycloak.authentication.FormAction;
import org.keycloak.authentication.FormActionFactory;
import org.keycloak.models.AuthenticationExecutionModel;
import org.keycloak.models.KeycloakSession;
import org.keycloak.models.KeycloakSessionFactory;
import org.keycloak.provider.ProviderConfigProperty;
import org.keycloak.Config;
import java.util.List;

public class GvIdentifierFormActionFactory implements FormActionFactory {

    public static final String PROVIDER_ID = "gv-identifier-form-action";
    private static final String DISPLAY_TYPE = "GV Identifier Generation";
    private static final String HELP_TEXT = "Generates a unique username from first and last names";

    @Override
    public String getId() {
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
    public String getReferenceCategory() {
        return "gv-identifier";
    }

    @Override
    public boolean isConfigurable() {
        return false;
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
    public boolean isUserSetupAllowed() {
        return false;
    }

    @Override
    public List<ProviderConfigProperty> getConfigProperties() {
        return List.of();
    }

    @Override
    public FormAction create(KeycloakSession session) {
        return new GvIdentifierFormAction();
    }

    @Override
    public void init(Config.Scope config) {
        // Initialization
    }

    @Override
    public void postInit(KeycloakSessionFactory factory) {
        // Post-init
    }

    @Override
    public void close() {
        // Cleanup
    }
}