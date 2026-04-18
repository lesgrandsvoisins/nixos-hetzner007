{
  description = "Sync-in NixOS package + module";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {inherit system;};

        sync-in = pkgs.buildNpmPackage {
          pname = "sync-in";
          version = "1.0.0";

          src = pkgs.fetchFromGitHub {
            owner = "Sync-in";
            repo = "server";
            rev = "main";
            hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
          };

          npmDepsHash = "sha256-BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB=";

          installPhase = ''
            mkdir -p $out
            cp -r . $out
          '';

          meta = with pkgs.lib; {
            description = "Sync-in server (self-hosted collaboration platform)";
            license = licenses.agpl3Only;
            platforms = platforms.linux;
          };
        };
      in {
        packages.sync-in = sync-in;

        packages.default = sync-in;
      }
    )
    // {
      nixosModules.sync-in = import ./module.nix;
    };
}
