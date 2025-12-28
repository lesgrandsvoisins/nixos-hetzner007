{
  description = "Homarr Dashboard";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {inherit system;};
        nodejs = pkgs.nodejs_25;
        pnpm = pkgs.pnpm_10.override {nodejs = nodejs;};
        fetchPnpmDeps = pkgs.fetchPnpmDeps;
        stdenv = pkgs.stdenv;
        pnpmConfigHook = pkgs.pnpmConfigHook;
        homarrAssets = ./assets;
      in {
        packages.default = stdenv.mkDerivation (finalAttrs: {
          pname = "homarr";
          version = "1.48.0";

          src = pkgs.fetchFromGitHub {
            owner = "homarr-labs";
            repo = "homarr";
            tag = "v${finalAttrs.version}";
            hash = "sha256-iWdaQv+aTPB+4uDCgkoLMq7tVfCFN8kv+acRo9Oby5g=";
          };

          pnpmDeps = fetchPnpmDeps {
            inherit (finalAttrs) pname version src;
            pnpm = pnpm;
            nodejs = nodejs;
            fetcherVersion = 3;
            hash = "sha256-GVjNQ3uS4K5AhWbJFlghHiaHjReaQjdOJJxfFLehLlM=";
          };

          nativeBuildInputs = [
            pnpm
            nodejs
            pnpmConfigHook
          ];

          buildInputs = [
            pkgs.gnused
          ];

          preBuild = ''
            # patch next.js file-system-cache to use NIXPKGS_HOMARR_CACHE_DIR
            echo "HOMARR Install"


            for i in apps/tasks/package.json apps/websocket/package.json packages/cli/package.json packages/db/package.json
            do
              echo "$i"
              substituteInPlace $i \
                --replace-warn  'outfile=' \
                                'outfile=/var/cache/homarr'
            done

            for i in packages/db/configs/mysql.config.ts packages/db/configs/postgresql.config.ts packages/db/configs/sqlite.config.ts
            do
              echo "$i"
              substituteInPlace $i \
                --replace-warn  'out: "./' \
                                'out: "/var/cache/homarr/'
            done

            for i in apps/tasks/package.json apps/nextjs/package.json apps/websocket/package.json packages/db/package.json
            do
              echo "$i"
              substituteInPlace $i \
                --replace-warn  'dotenv -e ../../.env --' \
                                'dotenv -e /etc/homarr/homarr.env --'
            done

            substituteInPlace package.json \
              --replace-warn  'dotenv -e .env --' \
                              'dotenv -e /etc/homarr/homarr.env --'

          '';

          buildPhase = ''
            runHook preBuild

            # mkdir -p config
            # pnpm build
            runHook postBuild
          '';

          installPhase = ''
            runHook preInstall

            mkdir -p $out/{bin,share/homarr}

            for i in apps packages tooling
            do
              echo $i
              cp -r $i $out/share/homarr/$i
            done

            cp ${homarrAssets}/homarr-install.sh $out/bin/homarr-install.sh
            cp ${homarrAssets}/homarr.env $out/bin/homarr.env

            runHook postInstall

          '';

          # doDist = false;

          meta = {
            description = "Homarr Dashboard";
            changelog = "https://github.com/homarr-labs/homarr/releases/tag/v${finalAttrs.version}";
            mainProgram = "homarr";
            homepage = "https://homarr.dev";
            # platforms = lib.platforms.all;
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
