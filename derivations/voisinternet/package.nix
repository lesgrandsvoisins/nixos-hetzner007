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
    version = "unstable-2026-09-11";

    src = fetchFromGitHub {
      owner = "lesgrandsvoisins";
      repo = "voisinternet";
      rev = "1e598322670d9d4f1e7541f60fe2c403fea4310e";
      hash = "sha256-LyW5YJv0L+luH5csWdoFXicX0RmdEbawFmfuuq2+2mQ=";
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
