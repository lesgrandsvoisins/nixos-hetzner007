{pkgs ? import <nixpkgs> {}}:
pkgs.maven.buildMavenPackage {
  pname = "gv-je-key-authenticator";
  version = "0.0.8";

  src = ./je-gv-key-authenticator; # folder next to this .nix file

  mvnHash = "sha256-qwu1FftrzP6+73SEe1uznOEvq7BLbziVS5+IchPzNX8=";

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp target/je-gv-key-authenticator*.jar $out/
    runHook postInstall
  '';
}
