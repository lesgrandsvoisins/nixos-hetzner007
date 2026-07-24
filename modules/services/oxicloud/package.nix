{pkgs ? import <nixpkgs> {}}:
pkgs.rustPlatform.buildRustPackage rec {
  pname = "OxiCloud";
  version = "v0.8.7";

  src = pkgs.fetchFromGitHub {
    owner = "AtalayaLabs";
    repo = "OxiCloud";
    rev = "v0.8.7";
    hash = "sha256-uDWs2gOqDXpozEkOCXmXcVT8nRICCff25Vtd6rzQgl4=";
  };

  cargoHash = "sha256-qvjhK1TNgVkc1fYrWce4Md09ALiKQPULRAkASp3R9Qg=";

  # If tests fail due to DB, disable:
  doCheck = false;

  # Install binary
  postInstall = ''
    mkdir -p $out/bin

    # main server
    if [ -f target/release/ ]; then
      cp -a target/release/oxicloud $out/bin/oxicloud
      cp -a target/release/generate-openapi $out/bin/generate-openapi
    fi

    cp -a static $out/static
    cp -a static-dist $out/static-dist
  '';

  meta = with pkgs.lib; {
    description = "Lightweight Rust-powered self-hosted cloud (Nextcloud alternative)";
    homepage = "https://github.com/AtalayaLabs/OxiCloud";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
