{
  description = "Homarr Dashboard";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        # pkgs-unstable = import nixpkgs-unstable  { inherit system; };
        # pkgs-unstable = import (fetchTarball https://github.com/nixos/nixpkgs-channels/archive/nixos-unstable.tar.gz) {};
        # pnpm = unstable.pnpm;
        # nodejs25 = pkgs-unstable.nodejs_25;
        # npm = unstable.nodePackages.npm
      in
      {
        packages.default = pkgs.buildNpmPackage (finalAttrs: {
          pname = "homarr";
          version = "1.48.0";

          src = pkgs.fetchFromGitHub {
            owner = "homarr-labs";
            repo = "homarr";
            tag = "v${finalAttrs.version}";
            hash = "sha256-iWdaQv+aTPB+4uDCgkoLMq7tVfCFN8kv+acRo9Oby5g="; # first build → copy `got:` here
          };

          buildInputs = with pkgs; [ pnpm nodejs_25 nodePackages.npm ];

          npmDepsHash = ""; # second build → copy `got:` here

          # buildPhase = ''
          #   echo "Installing dependencies with PNPM..."
          #   pnpm config set nodeVersion 25.2.1
          #   pnpm install
          # '';
          # configurePhase = ''
          #   pnpm install
          #   npm install
          # '';

          # npmPackFlags = [ "--ignore-engines" ];
          # NODE_OPTIONS = "";

          # Inject your local package-lock.json
          # postPatch = ''
          #   echo "Copying vendored package-lock.json..."
          #   cp ${./package-lock.json} package-lock.json
          # '';

          meta = {
            description = "Dashy, a modernish dashboard";
            homepage = "https://dashy.to/";
            license = pkgs.lib.licenses.mit;
          };
        });

        devShells.default = pkgs.mkShell {
          buildInputs = [
            pkgs.nodejs_25
            pkgs.pnpm
            pkgs.nodePackages.npm
          ];
        };
      }
    );
}
