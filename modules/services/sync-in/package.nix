{pkgs ? import <nixpkgs> {}}:
pkgs.buildNpmPackage {
  pname = "sync-in";
  version = "2.2.0-a2";

  src = pkgs.fetchFromGitHub {
    owner = "Sync-in";
    repo = "server";
    rev = "v2.2.0";
    hash = "sha256-PkdVveWfAqEU/Ljs28OZt1QPjE+DqQX4Aet/wCk7eok=";
  };

  nativeBuildInputs = [pkgs.nodejs_24];

  # 🔥 force newer drizzle
  postPatch = ''
    ${pkgs.nodejs_24}/bin/npm pkg set dependencies.drizzle-orm="^0.45.2"
    # rm -f package-lock.json
  '';

  # ⚠️ replace with real hash after first build
  npmDepsHash = "sha256-sOmR+cwIllv9V3JdqLlZnImsgntjS7ahDKXzyxKOS1M=";

  buildPhase = ''
    runHook preBuild
    npm run build
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib
    cp -r . $out/lib

    mkdir -p $out/bin
    cat > $out/bin/sync-in <<EOF
    #!${pkgs.runtimeShell}
    exec ${pkgs.nodejs_24}/bin/node $out/lib/dist/index.js "\$@"
    EOF

    chmod +x $out/bin/sync-in

    runHook postInstall
  '';

  meta = with pkgs.lib; {
    description = "Sync-in server (self-hosted collaboration platform)";
    license = licenses.agpl3Only;
    platforms = platforms.linux;
  };
}
