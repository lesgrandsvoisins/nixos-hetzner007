{
  description = "Homarr Dashboard";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { 
          inherit system; 
        };
      in
      {
        packages.default = pkgs.stdenv.mkDerivation rec {
          pname = "homarr";
          version = "1.48.0";

          src = pkgs.fetchFromGitHub {
            owner = "homarr-labs";
            repo = "homarr";
            tag = "v${version}";
            hash = "sha256-iWdaQv+aTPB+4uDCgkoLMq7tVfCFN8kv+acRo9Oby5g="; # first build → copy `got:` here
          };

          # phases = [ "installPhase" ];

          buildInputs = with pkgs; [
          #   corepack
            corepack_24
          ];

          pnpmDeps = pkgs.pnpm.fetchDeps {
            inherit pname version src;
            fetcherVersion = 3;
            hash = "";
          };

          # npmDepsHash = ""; # second build → copy `got:` here

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

          buildPhase = ''
            mkdir -p $out/bin
            pnpm install
          '';
            # corepack enable --install-directory=$out/bin pnpm


          meta = {
            description = "Dashy, a modernish dashboard";
            homepage = "https://dashy.to/";
            license = pkgs.lib.licenses.mit;
          };
        };

        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            corepack_24
            # corepack
          ];
        };
      }
    );
}
