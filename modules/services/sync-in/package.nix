{pkgs ? import <nixpkgs> {}}: let
in
  pkgs.buildNpmPackage {
    pname = "sync-in";
    version = "v2.2.0-a1";

    src = pkgs.fetchFromGitHub {
      owner = "Sync-in";
      repo = "server";
      rev = "v2.2.0";
      hash = "sha256-PkdVveWfAqEU/Ljs28OZt1QPjE+DqQX4Aet/wCk7eok=";
    };

    npmDepsHash = "sha256-sOmR+cwIllv9V3JdqLlZnImsgntjS7ahDKXzyxKOS1M=";

    installPhase = ''
      mkdir -p $out
      cp -r . $out
    '';

    meta = with pkgs.lib; {
      description = "Sync-in server (self-hosted collaboration platform)";
      license = licenses.agpl3Only;
      platforms = platforms.linux;
    };
  }
