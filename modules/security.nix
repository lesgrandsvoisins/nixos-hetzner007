{
  config,
  pkgs,
  libs,
  vars,
  ...
}: let
in {
  security = {
    acme = {
      acceptTerms = true;
      defaults = {
        email = "hostmaster@lesgrandsvoisins.com";
      };
      certs = {
        "hetzner007.gdvoisins.com" = {
          group = "users";
          listenHTTP = ":80";
        };
        "gdvoisins.com" = {
          dnsProvider = "clouddns";
          # environmentFile = "/etc/.secrets/.cloudns.auth";
          credentialFiles = {
            "CLOUDNS_AUTH_ID_FILE" = "/etc/.secrets/.cloudns.auth.id";
            "CLOUDNS_AUTH_PASSWORD_FILE" = "/etc/.secrets/.cloudns.auth.password";
            "CLOUDNS_AUTH_EMAIL_FILE" = "/etc/.secrets/.cloudns.auth.email";
          };
          extraDomainNames = ["www.gdvoisins.com"];
          group = "users";
        };
        "keycloak.grandsvoisins.org" = {
          dnsProvider = "clouddns";
          credentialFiles = {
            "CLOUDNS_AUTH_ID_FILE" = "/etc/.secrets/.cloudns.auth.id";
            "CLOUDNS_AUTH_PASSWORD_FILE" = "/etc/.secrets/.cloudns.auth.password";
            "CLOUDNS_AUTH_EMAIL_FILE" = "/etc/.secrets/.cloudns.auth.email";
          };
          group = "users";
        };
        "ggvv.org" = {
          dnsProvider = "clouddns";
          # environmentFile = "/etc/.secrets/.cloudns.auth";
          credentialFiles = {
            "CLOUDNS_AUTH_ID_FILE" = "/etc/.secrets/.cloudns.auth.id";
            "CLOUDNS_AUTH_PASSWORD_FILE" = "/etc/.secrets/.cloudns.auth.password";
          };
          extraDomainNames = ["wiki.ggvv.org" "homarr.ggvv.org" "www.ggvv.org" "test.ggvv.org" "auth.ggvv.org"];
          group = "services";
        };
      };
    };
  };
}
