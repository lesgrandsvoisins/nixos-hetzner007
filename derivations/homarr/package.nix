{
  pkgs ? import <nixpkgs-unstable> {},
  fetchFromGitHub ? pkgs.fetchFromGitHub,
  nodePackages ? pkgs.nodePackages,
  makeWrapper ? pkgs.makeWrapper,
  nodejs ? pkgs.nodejs_24,
  pnpm_10 ? pkgs.pnpm_10.override { nodejs = nodejs; },
  fetchPnpmDeps ? pkgs.fetchPnpmDeps,
  pnpmConfigHook ? pkgs.pnpmConfigHook,
  python3 ? pkgs.python3,
  stdenv ? pkgs.stdenv,
  unixtools ? pkgs.unixtools,
  cctools ? pkgs.cctools,
  lib ? pkgs.lib,
  nixosTests ? pkgs.nixosTests,
  gnused ? pkgs.gnused,
  enableLocalIcons ? false,
}:
let
  dashboardIcons = fetchFromGitHub {
    owner = "homarr-labs";
    repo = "dashboard-icons";
    rev = "f222c55843b888a82e9f2fe2697365841cbe6025"; # Until 2025-07-11
    hash = "sha256-VOWQh8ZadsqNInoXcRKYuXfWn5MK0qJpuYEWgM7Pny8=";
  };

  installLocalIcons = ''
    mkdir -p $out/share/homepage/public/icons
    cp -r --no-preserve=mode ${dashboardIcons}/png/. $out/share/homepage/public/icons
    cp -r --no-preserve=mode ${dashboardIcons}/svg/. $out/share/homepage/public/icons
    cp ${dashboardIcons}/LICENSE $out/share/homepage/public/icons/
  '';

  homarrAssets = ./assets;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "homarr";
  version = "1.48.0";

  src = fetchFromGitHub {
    owner = "homarr-labs";
    repo = "homarr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-iWdaQv+aTPB+4uDCgkoLMq7tVfCFN8kv+acRo9Oby5g="; 
  };



  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm_10;
    nodejs = nodejs;
    fetcherVersion = 3;
    hash = "sha256-GVjNQ3uS4K5AhWbJFlghHiaHjReaQjdOJJxfFLehLlM=";
  };

  nativeBuildInputs = [
    makeWrapper
    nodejs
    pnpmConfigHook
    pnpm_10
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ cctools ];

  buildInputs = [
    gnused
    pkgs.openssl
  ];

  # buildInputs = [
  #   nodePackages.node-gyp-build
  # ];

  # env.PYTHON = "${python3}/bin/python";

  preBuild = ''
    # patch next.js file-system-cache to use NIXPKGS_HOMARR_CACHE_DIR
    echo "install"



    echo ".env.example"
    # cp ./.env.example ./homarr.env
    # substituteInPlace ./homarr.env \ 
    #   --replace-warn  'FULL_PATH_TO_YOUR_SQLITE_DB_FILE' \
    #                   '/var/lib/homarr/homarr.sqlite3'

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
    # cp -r .next/standalone $out/share/homarr/

    cp ./.env.example $out/homarr.env

    
    
    # substituteInPlace ./homarr.env \ 
    #   --replace-warn  "DB_DRIVER='better-sqlite3'" \
    #                   "DB_DRIVER='@DB_DRIVER@'"
    #   --replace-warn  'FULL_PATH_TO_YOUR_SQLITE_DB_FILE' \
    #                   '@DB_URL@'
    #   --replace-warn  '0000000000000000000000000000000000000000000000000000000000000000' \
    #                   '@SECRET_ENCRYPTION_KEY@'
    #   --replace-warn  '# CRON_JOB_API_KEY="your-generated-api-key"' \
    #                   'CRON_JOB_API_KEY="@SECRET_API_KEY@"'
    #   --replace-warn  'supersecret' \
    #                   '@SECRET_AUTH@'
    for i in apps packages tooling
    do
      echo $i
      cp -r $i $out/share/homarr/$i
    done
    # cp -r public $out/share/homarr/public
    # chmod +x $out/share/homarr/server.js

    # mkdir -p $out/share/homarr/.next
    # cp -r .next/static $out/share/homarr/.next/static

    cp ${homarrAssets}/homarr-install.sh $out/bin/homarr-install.sh
    cp ${homarrAssets}/homarr.env $out/bin/homarr.env

    # wrapProgram $out/bin/homarr-install.sh

    # makeWrapper "${lib.getExe nodejs}" $out/bin/homarr \
    #   --set-default PORT 3000 \
    #   --set-default HOMARR_CONFIG_DIR /var/lib/homarr \
    #   --set-default NIXPKGS_HOMARR_CACHE_DIR /var/cache/homarr \
    #   --add-flags "$out/share/homarr/server.js" \
    #   --prefix PATH : "${lib.makeBinPath [ unixtools.ping ]}"

    # ${if enableLocalIcons then installLocalIcons else ""}

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
    platforms = lib.platforms.all;
  };
})