{pkgs ? import <nixpkgs> {}}:
pkgs.maven.buildMavenPackage {
  pname = "g-v-authenticator";
  version = "0.0.1";

  src = ./g-v-authenticator; # folder next to this .nix file

  mvnHash = "sha256-E1r3p14Rv7O4l+MYLaPOmMtbLLzEFnAQ5VkLoTxzRZw=";

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp target/*.jar $out/
    runHook postInstall
  '';
}
