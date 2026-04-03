{pkgs ? import <nixpkgs> {}}:
pkgs.maven.buildMavenPackage {
  pname = "gv-key-initials";
  version = "0.0.1";

  src = ./gv-key-initials; # folder next to this .nix file

  mvnHash = "sha256-Ai7Cg7yQpqHmJRtMdTpn1tC2upgBOlHdkzf/ieelHoU=";

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp target/*.jar $out/
    runHook postInstall
  '';
}
