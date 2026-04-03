{pkgs ? import <nixpkgs> {}}:
pkgs.maven.buildMavenPackage {
  pname = "gv-je-key-authentificator";
  version = "0.0.2";

  src = ./gv-je-key-authentificator; # folder next to this .nix file

  mvnHash = "";

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp target/*.jar $out/
    runHook postInstall
  '';
}
