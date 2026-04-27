{pkgs ? import <nixpkgs> {}}: let
  drizzleJsFile = ./drizzle.js;
  lib = pkgs.lib;
  fetchFromGitHub = pkgs.fetchFromGitHub;
  runtimeShell = pkgs.runtimeShell;
  buildNpmPackage = pkgs.buildNpmPackage;
  nodejs_24 = pkgs.nodejs_24;
  nixosTests = null;
in
  pkgs.buildNpmPackage {
    pname = "sync-in";
    version = "2.2.0";

    src = pkgs.fetchFromGitHub {
      owner = "Sync-in";
      repo = "server";
      rev = "v${version}";
      hash = "sha256-PkdVveWfAqEU/Ljs28OZt1QPjE+DqQX4Aet/wCk7eok=";
    };

    nativeBuildInputs = [pkgs.nodejs_24];

    postPatch = ''
      ${pkgs.nodejs_24}/bin/npm pkg set dependencies.drizzle-orm="^0.45.2"
      ${pkgs.nodejs_24}/bin/npm pkg set dependencies.pdfjs-dist="^5.6.205"
      ${pkgs.nodejs_24}/bin/npm pkg set dependencies.drizzle-kit="^v0.31.10"
    '';

    # npmInstallFlags = "";

    npmDepsHash = "sha256-sOmR+cwIllv9V3JdqLlZnImsgntjS7ahDKXzyxKOS1M=";

    buildPhase = ''
      runHook preBuild
      ${pkgs.nodejs_24}/bin/npm run build && ${pkgs.nodejs_24}/bin/node scripts/build/release.mjs
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/lib
      cp -r . $out/lib

      mkdir -p $out/bin
      mkdir -p $out/conf
      # cp $ {./drizzle.js} $out/conf/drizzle.js

      cat > $out/conf/drizzle.js <<EOF
      import { defineConfig } from "drizzle-kit";

      export default defineConfig({
        dialect: "mysql",
        schema: "$out/lib/release/sync-in-server/server/infrastructure/database/schema.js",
        out: "./backend-migrations",
        url: "mysql://__USER__:__PASSWORD__@__HOST__:__PORT__/__NAME__",
        tablesFilter: [
          'files_content_*'
        ]
      });
      EOF

      cat > $out/bin/sync-in <<EOF
      #!${pkgs.runtimeShell}
      export NODE_PATH=$NODE_PATH:$out/lib/node_modules
      exec ${pkgs.nodejs_24}/bin/node $out/lib/release/sync-in-server/server/main.js "\$@"
      EOF

      cat > $out/bin/sync-in-migrate-db <<EOF
      #!${pkgs.runtimeShell}
      export NODE_PATH=$NODE_PATH:$out/lib/node_modules
      exec ${pkgs.nodejs_24}/bin/npx drizzle-kit migrate --config=/etc/sync-in/drizzle.js "\$@"
      EOF

      chmod +x $out/bin/sync-in
      chmod +x $out/bin/sync-in-*

      runHook postInstall
    '';

    meta = with pkgs.lib; {
      description = "Sync-in server (self-hosted collaboration platform)";
      license = licenses.agpl3Only;
      platforms = platforms.linux;
      homepage = "https://github.com/Sync-in/server";
      changelog = "https://github.com/Sync-in/server/releases/tag/v${version}";
    };
  }
