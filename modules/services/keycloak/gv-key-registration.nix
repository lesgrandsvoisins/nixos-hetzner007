{pkgs ? import <nixpkgs> {}}:
pkgs.maven.buildMavenPackage {
  pname = "gv-key-registration";
  version = "0.0.6";

  src = ./gv-key-registration; # folder next to this .nix file

  mvnHash = "sha256-ZN/kPjVRCSdgxlIHPbxUPi+U8lqhNVp57Cl4Yo368FY=";

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp target/*.jar $out/
    runHook postInstall
  '';
}
