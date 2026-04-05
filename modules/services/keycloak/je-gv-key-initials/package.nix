{pkgs ? import <nixpkgs> {}}:
pkgs.maven.buildMavenPackage {
  pname = "je-gv-key-initials";
  version = "0.0.2";

  src = ./je-gv-key-initials; # folder next to this .nix file

  mvnHash = "sha256-FzoOJXQdR37merf7Amgwr/a4qTbBYp5rNpl/El7+cDM=";

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp target/*.jar $out/
    runHook postInstall
  '';
}
