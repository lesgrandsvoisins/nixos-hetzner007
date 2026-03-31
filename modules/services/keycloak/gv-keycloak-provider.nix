{pkgs ? import <nixpkgs>}:
pkgs.maven.buildMavenPackage {
  pname = "gv-keycloak-provider";
  version = "0.1.18";

  src = ./gv-keycloak-provider; # folder next to this .nix file

  mvnHash = "sha256-Kr4sk1IjaLoGIdU6CwgPcKhqRWCnZcm0uBvIr4Qam6Y=";

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp target/*.jar $out/
    runHook postInstall
  '';
}
