{pkgs ? import <nixpkgs> {}}:
pkgs.maven.buildMavenPackage {
  pname = "gv-key-registration";
  version = "0.0.4";

  src = ./gv-key-registration; # folder next to this .nix file

  mvnHash = "sha256-ttrtL4vvzdj0c6+b/ZX0jq4eVt2/TWuXf/b8Kk+srFA=";

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp target/*.jar $out/
    runHook postInstall
  '';
}
