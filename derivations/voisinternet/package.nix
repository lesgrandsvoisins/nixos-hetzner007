{
  pkgs ? import <nixpkgs> {},
  lib ? pkgs.lib,
  python3 ? pkgs.python3,
  fetchFromGitHub ? pkgs.fetchFromGitHub,
  makeWrapper ? pkgs.makeWrapper,
  ...
}: let
  # django-modeltranslation and mozilla-django-oidc depend on the generic
  # "django" attribute (currently 5.2.x in nixpkgs); alias it to django_6 so
  # the whole environment resolves to a single, matching Django version.
  python = python3.override {
    packageOverrides = self: super: {django = self.django_6;};
  };
  pythonEnv = python.withPackages (ps:
    with ps; [
      django
      mozilla-django-oidc
      django-modeltranslation
      pillow
      markdown
      bleach
      gunicorn
      psycopg
    ]);
in
  pkgs.stdenvNoCC.mkDerivation {
    pname = "voisinternet";
    version = "v0.1.1";

    src = fetchFromGitHub {
      owner = "lesgrandsvoisins";
      repo = "voisinternet";
      rev = "v0.1.1";
      hash = "sha256-cH8dP0ULF2pwp6pwOu002qlqxIYpOutEqQecIV0GzKQ=";
    };

    nativeBuildInputs = [makeWrapper];

    dontBuild = true;
    dontConfigure = true;

    installPhase = ''
      runHook preInstall

      mkdir -p $out/share/voisinternet
      cp -a . $out/share/voisinternet

      makeWrapper ${pythonEnv}/bin/gunicorn $out/bin/voisinternet-gunicorn \
        --set PYTHONPATH $out/share/voisinternet \
        --run "cd $out/share/voisinternet"

      makeWrapper ${pythonEnv}/bin/python $out/bin/voisinternet-manage \
        --set PYTHONPATH $out/share/voisinternet \
        --add-flags $out/share/voisinternet/manage.py \
        --run "cd $out/share/voisinternet"

      runHook postInstall
    '';

    meta = with lib; {
      description = "Voisinternet, le site de voisinter.net (Les Grands Voisins)";
      homepage = "https://github.com/lesgrandsvoisins/voisinternet";
      mainProgram = "voisinternet-gunicorn";
      platforms = platforms.linux;
    };
  }
