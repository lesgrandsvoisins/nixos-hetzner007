{stdenv}:
stdenv.mkDerivation rec {
  name = "gv-keycloak-theme";
  version = "0.1.12";

  src = ./gv-keycloak-provider/theme/gv-login;

  nativeBuildInputs = [];
  buildInputs = [];

  installPhase = ''
    mkdir -p $out
    cp -a login $out
  '';
}
