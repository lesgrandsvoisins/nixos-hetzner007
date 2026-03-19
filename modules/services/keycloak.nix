# keycloak.nix
{
  pkgs,
  lib,
  config,
  vars,
  keycloakWithGv,
  ...
}: let
  # 1) Your custom provider/theme jar as a derivation.
  # Put the jar in your repo, for example:
  #   ./keycloak/gv-keycloak.jar
  # gvKeycloakProvider = pkgs.stdenvNoCC.mkDerivation {
  #   pname = "gv-keycloak-provider";
  #   version = "1.0.0";
  #   src = ./keycloak/gv-keycloak-theme/gv-keycloak-registration-theme-0.1.2.jar;
  #   dontUnpack = true;
  #   installPhase = ''
  #     mkdir -p $out
  #     cp $src $out/gv-keycloak.jar
  #   '';
  # };
  # # 2) Keycloak package with the extra provider baked in.
  # keycloakWithGv = pkgs.keycloak.override {
  #   plugins =
  #     pkgs.keycloak.enabledPlugins
  #     ++ [gvKeycloakProvider];
  # };
  gvKeycloakProvider = pkgs.maven.buildMavenPackage {
    pname = "gv-keycloak-provider";
    version = "0.1.3";

    src = ./keycloak/gv-keycloak-provider/src; # folder next to this .nix file

    mvnHash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";

    installPhase = ''
      runHook preInstall
      mkdir -p $out
      cp target/*.jar $out/
      runHook postInstall
    '';
  };
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
  imports = [
    ../../derivations/gv-keycloak-theme
  ];
  services = {
    keycloak = {
      enable = true;
      # package = keycloakWithGv;
      themes = {
        gv-login = pkgs.callPackage ./keycloak/gv-keycloak-theme.nix {};
      };
      plugins = [gvKeycloakProvider];
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
        "spi-gv-provider" = "gv-keycloak-provider";
      };
      sslCertificate = "/var/lib/acme/key.gv.je/fullchain.pem";
      sslCertificateKey = "/var/lib/acme/key.gv.je/key.pem";
      # initialAdminPassword = "lksajdlkgh579821asfsdfksf4dskjhgfkjsahf";
      # themes = {lesgv = (pkgs.callPackage "/etc/nixos/keycloaktheme/derivation.nix" {});};
    };
  };
}
