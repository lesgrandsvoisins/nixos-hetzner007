{pkgs ? import <nixpkgs> {}}:
pkgs.maven.buildMavenPackage {
  pname = "gv-key-registration";
  version = "0.0.7";

  src = ./gv-key-registration; # folder next to this .nix file

  mvnHash = "sha256-rbMH5ZTA6FSd1k15Kyv6iFcDbepwRss6gqBPmAbrtfg=";

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp target/*.jar $out/
    runHook postInstall
  '';
}
