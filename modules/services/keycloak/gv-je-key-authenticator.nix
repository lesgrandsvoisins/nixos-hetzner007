{pkgs ? import <nixpkgs> {}}:
pkgs.maven.buildMavenPackage {
  pname = "gv-je-key-authenticator";
  version = "0.0.3";

  src = ./gv-je-key-authenticator; # folder next to this .nix file

  mvnHash = "sha256-N/Oroplb9+B2ad30BUV0miDDVjIkXIVSPnKet3lWvSg=";

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp target/*.jar $out/
    runHook postInstall
  '';
}
