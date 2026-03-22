{
  pkgs ? import <nixpkgs> {},
  unstable ? import <nixpkgs-unstable> {config = {allowUnfree = true;};},
  fetchFromGitHub ? pkgs.fetchFromGitHub,
  nodePackages ? pkgs.nodePackages,
  makeWrapper ? pkgs.makeWrapper,
  nodejs ? pkgs.nodejs_24,
  pnpm ? unstable.pnpm.override {nodejs = nodejs;},
  fetchPnpmDeps ? pkgs.fetchPnpmDeps,
  pnpmConfigHook ? pkgs.pnpmConfigHook,
  python3 ? pkgs.python3,
  stdenv ? pkgs.stdenv,
  unixtools ? pkgs.unixtools,
  cctools ? pkgs.cctools,
  lib ? pkgs.lib,
  nixosTests ? pkgs.nixosTests,
  gnused ? pkgs.gnused,
}: let
  homarrAssets = ./assets;
in
  stdenv.mkDerivation (finalAttrs: {
    pname = "homarr";
    version = "1.56.1";

    src = fetchFromGitHub {
      owner = "homarr-labs";
      repo = "homarr";
      tag = "v${finalAttrs.version}";
      hash = "sha256-hUWE689K/HMhDc48Ft+HiaP2O1xe7QGQjiN602wrNK8=";
    };

    pnpmDeps = fetchPnpmDeps {
      inherit (finalAttrs) pname version src;
      pnpm = pnpm;
      nodejs = nodejs;
      fetcherVersion = 3;
      hash = "sha256-KLKQ0EmyMbpPq4tAHmPVciCXQKU0hMFmMqROPaLyfhM=";
    };

    nativeBuildInputs =
      [
        makeWrapper
        nodejs
        pnpmConfigHook
        pnpm
      ]
      ++ lib.optionals stdenv.hostPlatform.isDarwin [cctools];

    buildInputs = [
      gnused
      unstable.openssl
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

    # passthru = {
    #   tests = {
    #     inherit (nixosTests) homarr;
    #   };
    #   updateScript = ./update.sh;
    # };

    meta = {
      description = "Homarr Dashboard";
      changelog = "https://github.com/homarr-labs/homarr/releases/tag/v${finalAttrs.version}";
      mainProgram = "homarr";
      homepage = "https://homarr.dev";
      platforms = pkgs.lib.platforms.all;
    };
  })
