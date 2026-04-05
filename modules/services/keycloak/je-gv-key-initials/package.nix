{pkgs ? import <nixpkgs> {}}:
pkgs.maven.buildMavenPackage {
  pname = "je-gv-key-initials";
  version = "0.0.2";

  src = ./je-gv-key-initials; # folder next to this .nix file

  mvnHash = "";

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp target/*.jar $out/
    runHook postInstall
  '';
}
