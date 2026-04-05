{pkgs ? import <nixpkgs> {}}:
pkgs.maven.buildMavenPackage {
  pname = "gv-key-registration";
  version = "0.0.22";

  src = ./je-gv-key-registration; # folder next to this .nix file

  mvnHash = "sha256-uFHyPENTRppFUnI/Trxhxj7EtWXE2JkscatF52gp5Gk=";

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp target/*.jar $out/
    runHook postInstall
  '';
}
