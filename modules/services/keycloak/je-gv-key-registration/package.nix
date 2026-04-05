{pkgs ? import <nixpkgs> {}}:
pkgs.maven.buildMavenPackage {
  pname = "gv-key-registration";
  version = "0.0.21";

  src = ./je-gv-key-registration; # folder next to this .nix file

  mvnHash = "sha256-/o20gnJ3D7ZkPFvomn2AGMhIG15+nj8JSLYGfWYQKBs=";

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp target/*.jar $out/
    runHook postInstall
  '';
}
