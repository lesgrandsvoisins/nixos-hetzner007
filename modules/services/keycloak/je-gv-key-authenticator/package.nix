{pkgs ? import <nixpkgs> {}}:
pkgs.maven.buildMavenPackage {
  pname = "gv-je-key-authenticator";
  version = "0.0.7";

  src = ./je-gv-key-authenticator; # folder next to this .nix file

  mvnHash = "sha256-4S0Dabl53iZ8uVbSJExIjVJMe1VrTJ5mtlHkh+2828Y=";

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp target/je-gv-key-authenticator*.jar $out/
    runHook postInstall
  '';
}
