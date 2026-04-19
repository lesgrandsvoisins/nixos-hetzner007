{pkgs ? import <nixpkgs> {}}:
pkgs.buildNpmPackage {
  pname = "sync-in";
  version = "2.2.0";

  src = pkgs.fetchFromGitHub {
    owner = "Sync-in";
    repo = "server";
    rev = "v2.2.0";
    hash = "sha256-PkdVveWfAqEU/Ljs28OZt1QPjE+DqQX4Aet/wCk7eok=";
  };

  nativeBuildInputs = [pkgs.nodejs_24];

  postPatch = ''
    ${pkgs.nodejs_24}/bin/npm pkg set dependencies.drizzle-orm="^0.45.2"
    ${pkgs.nodejs_24}/bin/npm pkg set dependencies.pdfjs-dist="^5.6.205"
  '';

  npmDepsHash = "sha256-sOmR+cwIllv9V3JdqLlZnImsgntjS7ahDKXzyxKOS1M=";

  buildPhase = ''
    runHook preBuild
    ${pkgs.nodejs_24}/bin/npm run build
    ${pkgs.nodejs_24}/bin/node scripts/build/release.mjs

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib
    cp -r . $out/lib

    mkdir -p $out/bin

    cat > $out/bin/sync-in-start <<EOF
    #!${pkgs.runtimeShell}
    exec ${pkgs.nodejs_24}/bin/node $out/lib/dist/server/main.js "\$@"
    EOF

    cat > $out/bin/sync-in <<EOF
    #!${pkgs.runtimeShell}
    exec ${pkgs.nodejs_24}/bin/node $out/lib/scripts/npm-sync-in-server.js "\$@"
    EOF

    chmod +x $out/bin/sync-in
    chmod +x $out/bin/sync-in-start

    runHook postInstall
  '';

  meta = with pkgs.lib; {
    description = "Sync-in server (self-hosted collaboration platform)";
    license = licenses.agpl3Only;
    platforms = platforms.linux;
  };
}
