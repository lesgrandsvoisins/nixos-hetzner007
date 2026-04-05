{pkgs ? import <nixpkgs> {}}:
pkgs.maven.buildMavenPackage {
  pname = "gv-je-key-authenticator";
  version = "0.0.11";

  src = ./je-gv-key-authenticator; # folder next to this .nix file

  mvnHash = "sha256-R8hiONIEaQRgtXOpUW4rdFRKFfZEDQX+udi/v4mMCAg=";

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp target/je-gv-key-authenticator*.jar $out/
    runHook postInstall
  '';
}
