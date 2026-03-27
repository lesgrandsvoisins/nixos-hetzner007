{pkgs ? import <nixpkgs>}:
pkgs.stdenv.mkDerivation {
  pname = "gv-keycloak-theme";
  version = "0.1.15";

  src = ./gv-keycloak-provider/theme/gv-login;

  nativeBuildInputs = [
    pkgs.keycloak
    pkgs.unzip
    pkgs.findutils
    pkgs.gnused
  ];
  buildInputs = [];

  installPhase = pkgs.lib.strings.concatStrings [
    "runHook preInstall"
    "mkdir -p $out"
    "cp -a login $out"
    ''
      mkdir -p "$out/login/templates"
      mkdir -p "$out/login/resources"

      themeJar="$(find ${pkgs.keycloak}/lib/lib/main -name 'org.keycloak.keycloak-themes-*.jar' | head -n 1)"

      if [ -z "$themeJar" ]; then
        echo "Could not find keycloak themes jar"
        exit 1
      fi

      tmpdir="$(mktemp -d)"
      unzip -q "$themeJar" 'theme/base/login/*' -d "$tmpdir"

      cp "$tmpdir/theme/base/login/template.ftl" \
        "$out/login/templates/template.ftl"
    ''
    ''
      sed -i 's/<\/body>/<a href="https:\/\/www.gv.je" class="site-action-button" aria-label="Open action">\n<img src="https:\/\/public.gv.je\/static\/web\/gvbtn\/gv-logo-512x512.png" class="site-action-button-img">\n<\/a>\n<\/body>/' $out/login/templates/template.ftl
    ''
    "runHook postInstall"
  ];
}
