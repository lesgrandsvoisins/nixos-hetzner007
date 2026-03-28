{pkgs ? import <nixpkgs> {}}: let
  pname = "gv-login";
  version = "0.1.16";
in
  pkgs.stdenv.mkDerivation {
    pname = pname;
    version = version;

    src = ./gv-keycloak-theme;

    nativeBuildInputs = [
      pkgs.keycloak
      pkgs.unzip
      pkgs.findutils
      pkgs.gnused
      pkgs.openjdk
    ];
    buildInputs = [];

    installPhase = pkgs.lib.strings.concatStrings [
      # installPhase = ''
      ''
        runHook preInstall
        mkdir -p $out
        tmpdir="$(mktemp -d)"
        mkdir -p $tmpdir/src
        mkdir -p $tmpdir/vendor
        mkdir -p $tmpdir/target
        cp -a . $tmpdir/src

      ''
      # mkdir -p $out/target
      # cp -a . $out/src
      # ''
      #   mkdir -p "$out/login/templates"
      #   mkdir -p "$out/temp"
      # ''
      # mkdir -p "$out/login/resources"
      ''
        themeJar="$(find ${pkgs.keycloak}/lib/lib/main -name 'org.keycloak.keycloak-themes-2*.jar' | head -n 1)"

        if [ -z "$themeJar" ]; then
          echo "Could not find keycloak themes jar"
          exit 1
        fi
      ''
      ''
        unzip -q "$themeJar" 'theme/*' -d "$tmpdir/vendor"
      ''
      ''
        mkdir -p $tmpdir/src/gv-login/login/templates
        cp "$tmpdir/vendor/theme/base/login/template.ftl" \
          "$tmpdir/src/gv-login/login/templates/template.ftl"
      ''
      ''
        sed -i 's/<\/body>/<a href="https:\/\/www.gv.je" class="site-action-button" aria-label="Open action">\n<img src="https:\/\/public.gv.je\/static\/web\/gvbtn\/gv-logo-512x512.png" class="site-action-button-img">\n<\/a>\n<\/body>/' $tmpdir/src/gv-login/login/templates/template.ftl
      ''
      ''
        ${pkgs.openjdk}/bin/jar cf $out/${pname}-${version}.jar -C $tmpdir/src .
      ''
      # "cp -a $tmpdir/src/gv-login $out"
      "runHook postInstall"
    ];
  }
