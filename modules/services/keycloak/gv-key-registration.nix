{pkgs ? import <nixpkgs> {}}:
pkgs.maven.buildMavenPackage {
  pname = "gv-key-registration";
  version = "0.0.8";

  src = ./gv-key-registration; # folder next to this .nix file

  mvnHash = "sha256-sKpo+4dDFca0uno4wcKWg8FChpG0QBkgABOSh1a3Ok8=";

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp target/*.jar $out/
    runHook postInstall
  '';
}
