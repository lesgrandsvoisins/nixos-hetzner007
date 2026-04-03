{pkgs ? import <nixpkgs> {}}:
pkgs.maven.buildMavenPackage {
  pname = "gv-je-key-authenticator";
  version = "0.0.4";

  src = ./gv-je-key-authenticator; # folder next to this .nix file

  mvnHash = "sha256-+L3l55FNMz7LKwhVtG8dQDDi9djyps/bnpFdRTSthkQ=";

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp target/*.jar $out/
    runHook postInstall
  '';
}
