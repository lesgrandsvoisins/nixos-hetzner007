# keycloak.nix
{
  pkgs,
  lib,
  config,
  vars,
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
  # gvKeycloakProvider = pkgs.maven.buildMavenPackage {
  #   pname = "gv-keycloak-provider";
  #   version = "0.1.6";
  #   src = ./keycloak/gv-keycloak-provider; # folder next to this .nix file
  #   mvnHash = "sha256-Kr4sk1IjaLoGIdU6CwgPcKhqRWCnZcm0uBvIr4Qam6Y=";
  #   installPhase = ''
  #     runHook preInstall
  #     mkdir -p $out
  #     cp target/*.jar $out/
  #     runHook postInstall
  #   '';
  # };
  # keycloakWithGv = pkgs.keycloak.override {
  #   plugins =
  #     pkgs.keycloak.enabledPlugins
  #     ++ [
  #       (pkgs.callPackage ./keycloak/gv-keycloak-provider.nix {inherit pkgs;})
  #       (pkgs.callPackage ./keycloak/gv-keycloak-theme.nix {inherit pkgs;})
  #     ];
  # };
  gvKeycloakProvider = pkgs.maven.buildMavenPackage {
    pname = "gv-keycloak-provider";
    version = "0.1.21";
    src = ./keycloak/gv-keycloak-provider; # folder next to this .nix file
    mvnHash = "sha256-Kr4sk1IjaLoGIdU6CwgPcKhqRWCnZcm0uBvIr4Qam6Y=";
    installPhase = ''
      runHook preInstall
      mkdir -p $out
      cp target/*.jar $out/
      runHook postInstall
    '';
  };
  gvKeycloakify = pkgs.callPackage keycloak/gv-keycloakify.nix {};
  jeGvKeyRegistration = pkgs.callPackage keycloak/je-gv-key-registration/package.nix {inherit pkgs;};
  jeGvKeyAuthenticator = pkgs.callPackage ./keycloak/je-gv-key-authenticator/package.nix {inherit pkgs;};
  jeGvKeyInitials = pkgs.callPackage ./keycloak/je-gv-key-initials/package.nix {inherit pkgs;};
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
  # imports = [
  #   ../../derivations/gv-keycloak-theme
  # ];
  services = {
    keycloak = {
      enable = true;
      # package = keycloakWithGv;
      themes = {
        # gv-login = pkgs.callPackage ./keycloak/gv-keycloak-theme.nix {};
        gv-key-registration = pkgs.callPackage ./keycloak/je-gv-key-registration/theme.nix {};
      };
      plugins = [
        gvKeycloakProvider
        "${gvKeycloakify}/gv-keycloakify.jar"
        "${jeGvKeyRegistration}/je-gv-key-username-formaction.jar"
        "${jeGvKeyAuthenticator}/je-gv-key-authenticator.jar"
        "${jeGvKeyInitials}/je-gv-key-initials.jar"
        # gvKeyInitials
      ];
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
        # "spi-gv-keycloak-registration-theme--provider" = "gv-identifier-form-action";
        # "spi-gv-keycloak-registration-theme--provider--enabled" = true;
      };
      sslCertificate = "/var/lib/acme/key.gv.je/fullchain.pem";
      sslCertificateKey = "/var/lib/acme/key.gv.je/key.pem";
      # initialAdminPassword = "lksajdlkgh579821asfsdfksf4dskjhgfkjsahf";
      # themes = {lesgv = (pkgs.callPackage "/etc/nixos/keycloaktheme/derivation.nix" {});};
    };
  };
}
