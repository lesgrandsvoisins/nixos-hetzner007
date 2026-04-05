{pkgs ? import <nixpkgs> {}}:
pkgs.maven.buildMavenPackage {
  pname = "gv-key-registration";
  version = "0.0.23";

  src = ./je-gv-key-registration; # folder next to this .nix file

  mvnHash = "sha256-jlYCaudpFIuYFje5hlBtbr5JXjnAGniGyouHLHmdeds=";

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp target/*.jar $out/
    runHook postInstall
  '';
}
