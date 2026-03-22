{
  description = "Homarr package flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
  }: let
    systems = [
      "x86_64-linux"
      "aarch64-linux"
      # "x86_64-darwin"
      # "aarch64-darwin"
    ];

    forAllSystems = f:
      nixpkgs.lib.genAttrs systems (system:
        f {
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;

            overlays = [
              (final: prev: {
                unstable = import nixpkgs-unstable {
                  inherit system;
                  config.allowUnfree = true;
                };
              })
              # (final: prev: {
              #   homarr = import homarr {
              #     inherit system;
              #   };
              # })
            ];
          };
        });
  in {
    packages = forAllSystems ({
      pkgs,
      # unstable,
    }: let
      lib = pkgs.lib;
      stdenv = pkgs.stdenv;
      nodejs = pkgs.unstable.nodejs_25;
      pnpm = pkgs.unstable.pnpm.override {nodejs = pkgs.unstable.nodejs_25;};
      homarrAssets = ./assets;
    in rec {
      homarr = stdenv.mkDerivation (finalAttrs: {
        pname = "homarr";
        version = "1.56.1";

        outputs = [
          "out"
          # "man"
        ];

        src = pkgs.fetchFromGitHub {
          owner = "homarr-labs";
          repo = "homarr";
          tag = "v${finalAttrs.version}";
          hash = "sha256-hUWE689K/HMhDc48Ft+HiaP2O1xe7QGQjiN602wrNK8=";
        };

        pnpmDeps = pkgs.unstable.fetchPnpmDeps {
          inherit (finalAttrs) pname version src;
          pnpm = pkgs.unstable.pnpm.override {nodejs = pkgs.unstable.nodejs_25;};
          nodejs = pkgs.unstable.nodejs_25;
          fetcherVersion = 3;
          hash = "sha256-KLKQ0EmyMbpPq4tAHmPVciCXQKU0hMFmMqROPaLyfhM=";
        };

        nativeBuildInputs =
          [
            pkgs.makeWrapper
            pkgs.unstable.nodejs_25
            pkgs.unstable.pnpmConfigHook
            pnpm
          ]
          ++ lib.optionals stdenv.hostPlatform.isDarwin [pkgs.cctools];

        buildInputs = [
          pkgs.gnused
          pkgs.openssl
        ];

        preBuild = ''
          echo "HOMARR Install"

          for i in apps/tasks/package.json apps/websocket/package.json packages/cli/package.json packages/db/package.json
          do
            echo "$i"
            substituteInPlace $i \
              --replace-warn 'outfile=' \
                             'outfile=/var/cache/homarr'
          done

          for i in packages/db/configs/mysql.config.ts packages/db/configs/postgresql.config.ts packages/db/configs/sqlite.config.ts
          do
            echo "$i"
            substituteInPlace $i \
              --replace-warn 'out: "./' \
                             'out: "/var/cache/homarr/'
          done

          for i in apps/tasks/package.json apps/nextjs/package.json apps/websocket/package.json packages/db/package.json
          do
            echo "$i"
            substituteInPlace $i \
              --replace-warn 'dotenv -e ../../.env --' \
                             'dotenv -e /etc/homarr/homarr.env --'
          done

          substituteInPlace package.json \
            --replace-warn 'dotenv -e .env --' \
                           'dotenv -e /etc/homarr/homarr.env --'

          # # source file
          # substituteInPlace node_modules/next/dist/server/lib/incremental-cache/file-system-cache.js \
          #   --replace-fail 'this.serverDistDir = ctx.serverDistDir;' \
          #                  'this.serverDistDir = require("path").join((process.env.NIXPKGS_HOMARR_CACHE_DIR || "/var/cache/homarr"), "homepage");'

          # # bundled runtimes
          # for bundle in node_modules/next/dist/compiled/next-server/*.runtime.prod.js; do
          #   substituteInPlace "$bundle" \
          #     --replace-fail 'this.serverDistDir=e.serverDistDir' \
          #                    'this.serverDistDir=(process.env.NIXPKGS_HOMARR_CACHE_DIR||"/var/cache/homarr")+"/homepage"'
          # done
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

        doDist = false;

        meta = with lib; {
          description = "Homarr Dashboard";
          changelog = "https://github.com/homarr-labs/homarr/releases/tag/v${finalAttrs.version}";
          mainProgram = "homarr";
          homepage = "https://homarr.dev";
          platforms = platforms.all;
        };
      });

      default = homarr;
    });

    # packages.${pkgs.stdenv.hostPlatform.system}.default = self.packages.${pkgs.stdenv.hostPlatform.system}.default;

    # defaultPackage =
    #   forAllSystems ({pkgs}:
    #     self.packages.${pkgs.stdenv.hostPlatform.system}.default);

    devShells = forAllSystems ({pkgs}: let
      nodejs = pkgs.unstable.nodejs_25;
      pnpm = pkgs.unstable.pnpm.override {nodejs = pkgs.unstable.nodejs_25;};
    in {
      default = pkgs.mkShell {
        packages = [
          pkgs.unstable.nodejs_25
          pnpm
          pkgs.openssl
          pkgs.gnused
        ];
      };
    });
  };
}
