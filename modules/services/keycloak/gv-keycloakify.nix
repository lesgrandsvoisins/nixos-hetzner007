{pkgs ? import <nixpkgs> {}}:
pkgs.stdenv.mkDerivation rec {
  name = "gv-keyclaokify";
  version = "0.1.21";

  src = ./gv-keycloakify;

  nativeBuildInputs = [];
  buildInputs = [];

  installPhase = ''
    mkdir $out
    cp -a keycloak-theme-for-kc-26.2-and-above.jar $out/gv-keycloakify.jar
  '';
}
