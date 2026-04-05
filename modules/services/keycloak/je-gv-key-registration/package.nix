{pkgs ? import <nixpkgs> {}}:
pkgs.maven.buildMavenPackage {
  pname = "gv-key-registration";
  version = "0.0.20";

  src = ./je-gv-key-registration; # folder next to this .nix file

  mvnHash = "sha256-lH7keAo8hRtBrjQNB42iUDcClCrPeJx244LX6/hMmQI=";

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp target/*.jar $out/
    runHook postInstall
  '';
}
