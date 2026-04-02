{pkgs ? import <nixpkgs> {}}:
pkgs.maven.buildMavenPackage {
  pname = "gv-key-registration";
  version = "0.0.2";

  src = ./gv-key-registration; # folder next to this .nix file

  mvnHash = "sha256-E1r3p14Rv7O4l+MYLaPOmMtbLLzEFnAQ5VkLoTxzRZw=";

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp target/*.jar $out/
    runHook postInstall
  '';
}
