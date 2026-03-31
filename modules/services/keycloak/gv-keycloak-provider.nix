{pkgs ? import <nixpkgs>}:
pkgs.maven.buildMavenPackage {
  pname = "gv-keycloak-provider";
  version = "0.1.21";

  src = ./gv-keycloak-provider; # folder next to this .nix file

  mvnHash = pkgs.lib.fakeHash;

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp target/*.jar $out/
    runHook postInstall
  '';
}
