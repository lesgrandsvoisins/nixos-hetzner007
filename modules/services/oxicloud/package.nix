{pkgs ? import <nixpkgs> {}}:
pkgs.rustPlatform.buildRustPackage rec {
  pname = "oxicloud";
  version = "unstable-2026-04-17";

  src = pkgs.fetchFromGitHub {
    owner = "DioCrafts";
    repo = "OxiCloud";
    rev = "v0.5.5";
    hash = "sha256-Nn8qgLdiw7w4PZIMCiI+UHZGNW64fjWZ5mErTJifRZU=";
  };

  cargoHash = "sha256-4KfrKL2AKkTt3cOXdl9Xr2qed+qy8WSWuqYfN8WJ0bQ=";

  # Required for common Rust deps (very likely needed here)
  nativeBuildInputs = [pkgs.pkg-config];
  buildInputs = [pkgs.openssl];

  # If tests fail due to DB, disable:
  doCheck = false;

  cargoBuildFlags = [
    "--release"
    "--features"
    "migrations"
  ];

  # Install both binaries
  postInstall = ''
    mkdir -p $out/bin

    # main server
    if [ -f target/release/oxicloud ]; then
      cp target/release/oxicloud $out/bin/
    fi

    # migration binary
    if [ -f target/release/migrate ]; then
      cp target/release/migrate $out/bin/oxicloud-migrate
    fi

    cp -r static $out/
  '';

  meta = with pkgs.lib; {
    description = "Lightweight Rust-powered self-hosted cloud (Nextcloud alternative)";
    homepage = "https://github.com/DioCrafts/OxiCloud";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
