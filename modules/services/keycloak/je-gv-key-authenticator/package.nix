{pkgs ? import <nixpkgs> {}}:
pkgs.maven.buildMavenPackage {
  pname = "gv-je-key-authenticator";
  version = "0.0.5";

  src = ./je-gv-key-authenticator; # folder next to this .nix file

  mvnHash = "sha256-7J570AXMwoRqLB6WmG2pRI7YqxvBZxmhxkJThBwWjvY=";

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp target/je-gv-key-authenticator*.jar $out/
    runHook postInstall
  '';
}
