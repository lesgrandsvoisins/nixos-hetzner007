{pkgs ? import <nixpkgs> {}}:
pkgs.maven.buildMavenPackage {
  pname = "gv-je-key-authenticator";
  version = "0.0.6";

  src = ./je-gv-key-authenticator; # folder next to this .nix file

  mvnHash = "sha256-1bfqgyH3UKRa2GsE9wkWtWgQUnNNHkn26adNeKqZxo8=";

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp target/je-gv-key-authenticator*.jar $out/
    runHook postInstall
  '';
}
