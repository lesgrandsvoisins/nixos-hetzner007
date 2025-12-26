{ config, pkgs, ... }:
let
in
{
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
          };
          extraDomainNames = ["www.gdvoisins.com"];
          group = "users";
        };
      };
    };
  };
}