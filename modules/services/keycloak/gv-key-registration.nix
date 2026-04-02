{pkgs ? import <nixpkgs> {}}:
pkgs.maven.buildMavenPackage {
  pname = "gv-key-registration";
  version = "0.0.5";

  src = ./gv-key-registration; # folder next to this .nix file

  mvnHash = "sha256-OpkwVW7/6kKUJ34OMfHwzUp/nRfU6ydyUjpHzLsoltM=";

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp target/*.jar $out/
    runHook postInstall
  '';
}
