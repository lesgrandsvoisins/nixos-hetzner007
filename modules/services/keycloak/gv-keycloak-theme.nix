{pkgs ? import <nixpkgs> {}}:
pkgs.stdenv.mkDerivation rec {
  name = "gv-keycloak-theme";
  version = "0.1.17";

  src = ./gv-keycloak-provider/theme/gv-login;

  nativeBuildInputs = [];
  buildInputs = [];

  installPhase = ''
    mkdir -p $out
    cp -a login $out
  '';
}
