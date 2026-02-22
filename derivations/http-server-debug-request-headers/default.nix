{
  pkgs ? import <nixpkgs> {},
  name ? "http-server-debug-requests-headers",
}: let
in
  pkgs.stdenv.mkDerivation {
    inherit name;

    nativeBuildInputs = with pkgs; [
      go
      gnused
    ];

    src = ./.;

    phases = "installPhase";

    installPhase = ''
      mkdir -p $out/bin
      cp -r $src/* $out/
      sed -i "s|go run \\.\\./|go run $out/|" $out/bin/go-debug-http.sh
    '';
  }
