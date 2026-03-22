{
  pkgs ? import <nixpkgs> {},
  unstable ? import <nixpkgs-unstable> {config = {allowUnfree = true;};},
  ...
}: let
  nodejs = unstable.nodejs_25;
  pnpm = unstable.pnpm.override {inherit nodejs;};
  homarrAssets = ./assets;
in
  pkgs.stdenv.mkDerivation (finalAttrs: {
    pname = "homarr";
    version = "1.56.1";

    outputs = ["out"];

    src = pkgs.fetchFromGitHub {
      owner = "homarr-labs";
      repo = "homarr";
      tag = "v${finalAttrs.version}";
      hash = "sha256-hUWE689K/HMhDc48Ft+HiaP2O1xe7QGQjiN602wrNK8=";
    };

    pnpmDeps = pkgs.fetchPnpmDeps {
      inherit (finalAttrs) pname version src;
      inherit pnpm nodejs;
      fetcherVersion = 3;
      hash = "sha256-KLKQ0EmyMbpPq4tAHmPVciCXQKU0hMFmMqROPaLyfhM=";
    };

    nativeBuildInputs =
      [
        pkgs.makeWrapper
        nodejs
        unstable.pnpmConfigHook
        pnpm
      ]
      ++ pkgs.lib.optionals pkgs.stdenv.hostPlatform.isDarwin [pkgs.cctools];

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
    '';

    buildPhase = ''
      runHook preBuild
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

    meta = with pkgs.lib; {
      description = "Homarr Dashboard";
      changelog = "https://github.com/homarr-labs/homarr/releases/tag/v${finalAttrs.version}";
      mainProgram = "homarr";
      homepage = "https://homarr.dev";
      platforms = platforms.all;
    };
  })
