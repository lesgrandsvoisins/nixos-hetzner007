{pkgs ? import <nixpkgs> {}}:
pkgs.maven.buildMavenPackage {
  pname = "gv-je-key-authenticator";
  version = "0.0.10";

  src = ./je-gv-key-authenticator; # folder next to this .nix file

  mvnHash = "sha256-g9+ASiLN5pPOKfN1vIoU1AbonBfeTM8H8Me2SBM/yt4=";

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp target/je-gv-key-authenticator*.jar $out/
    runHook postInstall
  '';
}
