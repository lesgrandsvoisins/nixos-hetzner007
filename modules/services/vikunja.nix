{
  config,
  pkgs,
  lib,
  vars,
  unstable,
  ...
}: let
in {
  systemd.tmpfiles.rules = [
    "d /etc/vikunja 0755 vikunja services"
    "f /etc/vikunja/.env 0600 vikunja services"
    "d /etc/vikunja/.secrets 0750 vikunja services"
    "f /etc/vikunja/.secrets/.list@lesgrandsvoisins.com 0600 vikunja services"
    "f /etc/vikunja/.secrets/.vikunja@postgresql 0600 vikunja services"
  ];
  systemd.services.vikunja.serviceConfig.User = lib.mkForce "vikunja";
  systemd.services.vikunja.serviceConfig.DynamicUser = lib.mkForce false;

  users.users.vikunja = {
    isSystemUser = true;
    group = "services";
    uid = vars.uid.vikunja;
  };

  services.vikunja.package = pkgs.unstable.vikunja;
  services.vikunja = {
    enable = true;
    frontendScheme = "https";
    frontendHostname = "vikunja.gv.je";
    settings = {
      database = {
        type = lib.mkForce "postgres";
        user = "vikunja";
        host = lib.mkForce "/var/run/postgresql:${builtins.toString vars.ports.postgresql}";
        # host = lib.mkForce "127.0.0.1:${builtins.toString vars.ports.postgresql}";
        database = "vikunja";
        password.file = "/etc/vikunja/.secrets/.vikunja@postgresql";
        # sslrootcert = "/etc/postgres/postgres.crt";
        # tls = true;
        # sslmode = "require";
      };
      mailer = {
        enabled = true;
        host = "mail.lesgrandsvoisins.com";
        port = "465";
        authtype = "login";
        username = "list@lesgrandsvoisins.com";
        fromemail = "list@lesgrandsvoisins.com";
        forcessl = true;
        password.file = "/etc/vikunja/.secrets/.list@lesgrandsvoisins.com";
      };
      defaultsettings = {
        week_start = 1;
        language = "fr-FR";
        timezone = "Europe/Paris";
        discoverable_by_email = true;
        discoverable_by_name = true;
      };
      service = {
        timezone = "Europe/Paris";
      };
      environmentFiles = [
        "/etc/vikunja/.env"
      ];
      auth = {
        local.enabled = true;
        openid.enabled = true;
        # openid.redirecturl = "https://vikunja.village.ngo/auth/openid/";
        # openid.redirecturl = "https://vikunja.gv.coop/auth/openid/";
        # openid.redirecturl = "https://task.gv.je/auth/openid/";
        openid.providers = {
          key = {
            # {
            name = "key.gv.je";
            authurl = "https://key.gv.je/realms/master";
            lougouturl = "https://key.gv.je/realms/master/protocol/openid-connect/logout";
            clientid = "vikunja";
            # clientsecret = "KEYGVJE_VIKUNJA_CLIENT_SECRET";
            clientsecret = "$KEYGVJE_VIKUNJA_CLIENT_SECRET";
            # clientsecret.file = "/etc/vikunja/oidc_client_secret_keygvje";
            # usernamefallback = true;
            # emailfallback = true;
            # forceuserinfo = false;
            scope = "openid profile email";
          };
          # keycloakGDVoisins = {
          #   name = "keycloakGDVoisins";

          #   # key = "keycloakGDVoisins";
          #   authurl = "https://keycloak.gdvoisins.com/realms/master";
          #   lougouturl = "https://keycloak.gdvoisins.com/realms/master/protocol/openid-connect/logout";
          #   clientid = "vikunja";
          #   # clientsecret =  "KEYCLOAK_VIKUNJA_CLIENT_SECRET";
          #   clientsecret.file = "/etc/vikunja/oidc_client_secret";
          # };
          # {
          #   name = "keyLesGrandsVoisinsCom";
          #   authurl = "https://key.lesgrandsvoisins.com/realms/master";
          #   logouturl = "https://key.lesgrandsvoisins.com/realms/master/protocol/openid-connect/logout";
          #   clientid = "vikunja";
          #   clientsecret.file = "/etc/vikunja/oidc_client_secret"
          #   # clientsecret = import ../secrets/keylesgrandsvoisins.vikunja.nix;
          #   # clientsecret = config.age.secrets."keylesgrandsvoisins.vikunja".path;
          # }
          # {
          #   name = "keyGVcoop";
          #   authurl = "https://key.gv.coop/realms/master";
          #   logouturl = "https://key.gv.coop/realms/master/protocol/openid-connect/logout";
          #   clientid = "vikunja";
          #   clientsecret = keyGVcoopVikunja;
          # }
          # {
          #   name = "VillageNgo";
          #   authurl = "https://keycloak.village.ngo/realms/master";
          #   logouturl = "https://keycloak.village.ngo/realms/master/protocol/openid-connect/logout";
          #   clientid = "vikunja";
          #   clientsecret = import ../secrets/keylesgrandsvoisins.vikunja.nix;
          #   # clientsecret.file = config.age.secrets."keycloak.vikunja".path;
          #   # clientsecret = keycloakVikunja;
          # }
        };
      };
    };
  };
}
