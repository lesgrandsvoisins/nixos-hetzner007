{pkgs ? import <nixpkgs> {}}:
pkgs.stdenv.mkDerivation rec {
  name = "gv-keyclaokify";
  version = "0.1.19";

  src = ./gv-keycloakify;

  nativeBuildInputs = [];
  buildInputs = [];

  installPhase = ''
    cp -a keycloak-theme-for-kc-26.2-and-above.jar $out
  '';
}
