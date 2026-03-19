{stdenv}:
stdenv.mkDerivation rec {
  name = "gv-keycloak-theme";
  version = "1.0";

  src = ./gv-keycloak-theme;

  nativeBuildInputs = [];
  buildInputs = [];

  installPhase = ''
    mkdir -p $out
    cp -a login $out
  '';
}
