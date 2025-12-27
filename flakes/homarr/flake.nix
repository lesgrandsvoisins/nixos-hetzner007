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
        pkgs = import nixpkgs { inherit system; };
        nodejs = pkgs.nodejs_25;
        pnpm = pkgs.pnpm_10.override { nodejs = nodejs; };
        fetchPnpmDeps = pkgs.fetchPnpmDeps;
        stdenv = pkgs.stdenv;
        pnpmConfigHook = pkgs.pnpmConfigHook;
      in
      {
        packages.default = stdenv.mkDerivation (finalAttrs: {
          pname = "homarr";
          version = "1.48.0";

          src = pkgs.fetchFromGitHub {
            owner = "homarr-labs";
            repo = "homarr";
            tag = "v${finalAttrs.version}";
            hash = "sha256-iWdaQv+aTPB+4uDCgkoLMq7tVfCFN8kv+acRo9Oby5g="; 
          };

          nativeBuildInputs = [
            pnpm
            nodejs
            pnpmConfigHook
          ];

          pnpmDeps = fetchPnpmDeps {
            inherit (finalAttrs) pname version src;
            pnpm = pnpm;
            nodejs = nodejs;
            fetcherVersion = 3;
            hash = "sha256-fh599IyeF0EUlyyvinDiaq/qsJB3Zdp1WQ2iYr2L/GM=";
          };
          # Build Homarr
          # buildPhase = ''

          #   # Copy pre-fetched node_modules
          #   mkdir -p node_modules
          #   cp -r ${pnpmDeps}/node_modules/* node_modules/

          # '';

          pnpmInstallFlags = [ "--shamefully-hoist" ];


          installPhase = ''
            # Install built app to $out
            mkdir -p $out/src
            mkdir -p $out/node_modules
            mkdir -p $out/etc/homarr
            cp -r . $out/src/
            mv $out/src/node_modules/ $out/node_modules/
            cp $out/src/.env.example $out/etc/homarr/homarr.env
          '';

          meta = {
            description = "Homarr, a modernish dashboard";
            homepage = "https://homarr.dev/";
          };
        });

        devShells.default = pkgs.mkShell {
          buildInputs = [
            pnpm
            nodejs
          ];
        };
      }
    );
}
