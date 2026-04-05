{pkgs ? import <nixpkgs> {}}:
pkgs.stdenv.mkDerivation rec {
  name = "gv-key-registration-theme";
  version = "0.0.9";

  src = ./je-gv-key-registration/themes/gv-registration;

  nativeBuildInputs = [];
  buildInputs = [];

  installPhase = ''
    mkdir -p $out
    cp -a . $out
  '';
}
