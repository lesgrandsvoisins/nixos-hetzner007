{pkgs, ...}: let
  myKeycloakProvider = pkgs.buildMavenPackage {
    pname = "my-keycloak-provider";
    version = "1.0.0";

    src = ./gv-keyloak-provider/src; # folder next to this .nix file

    mvnHash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";

    installPhase = ''
      runHook preInstall
      mkdir -p $out
      cp target/*.jar $out/
      runHook postInstall
    '';
  };
in {
  services.keycloak = {
    enable = true;

    plugins = [myKeycloakProvider];

    settings = {
      # example: select your provider for an SPI
      # "spi-user-storage-provider" = "myprovider";
    };
  };
}
