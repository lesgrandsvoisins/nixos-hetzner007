# keycloak.nix
{
  pkgs,
  lib,
  config,
  vars,
  ...
}: let
in {
  users.users.keycloak = {
    uid = vars.uid.keycloak;
    group = "services";
    isSystemUser = true;
  };
  security.acme.certs."key.gv.je" = {
    dnsProvider = "porkbun";
    environmentFile = "/var/caddy/caddy.env";
    group = "services";
    extraDomainNames = ["admin.key.gv.je"];
  };
  services = {
    keycloak = {
      enable = true;

      database = {
        username = "keygvje";
        # name = "keycloaklesgv";
        name = "keygvje"; # I think the database is keycloak and not key
        # passwordFile="/etc/.secrets.key";
        passwordFile = "/etc/key.gv.je/.postgres.keygvje";
        # createLocally = false;
        host = "127.0.0.1";
        # useSSL = false;
        caCert = "/etc/postgres/postgres.crt";
        port = vars.ports.postgresql;
      };
      settings = {
        https-port = 14446;
        http-port = 14086;
        # proxy = "passthrough";
        # proxy = "reencrypt";
        proxy-headers = "xforwarded";
        hostname = "https://key.gv.je";
        # hostname-admin = "https://admin.key.gv.je";
        # db-url-port = lib.mkForce vars.ports.postgresql;
        # db-url = lib.mkForce "postgresql:///dbname?host=/var/lib/postgresql?port=${builtins.toString vars.ports.postgresql}";
      };
      sslCertificate = "/var/lib/acme/key.gv.je/fullchain.pem";
      sslCertificateKey = "/var/lib/acme/key.gv.je/key.pem";
      initialAdminPassword = "lksajdlkgh579821asfsdfksf4dskjhgfkjsahf";
      # themes = {lesgv = (pkgs.callPackage "/etc/nixos/keycloaktheme/derivation.nix" {});};
    };
  };
}
