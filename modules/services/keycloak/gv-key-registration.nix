{pkgs ? import <nixpkgs> {}}:
pkgs.maven.buildMavenPackage {
  pname = "gv-key-registration";
  version = "0.0.3";

  src = ./gv-key-registration; # folder next to this .nix file

  mvnHash = "sha256-F94cD2IebTVZgVh183P8mhdtkDGk7y/DBNfmkqpeCNs=";

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp target/*.jar $out/
    runHook postInstall
  '';
}
