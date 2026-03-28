{pkgs ? import <nixpkgs> {}}:
pkgs.stdenv.mkDerivation rec {
  pname = "memos";
  version = "0.0.1-gv";

  src = pkgs.fetchurl {
    url = "https://github.com/chris2fr/memos/releases/download/v-${version}/memos";
    # fill this in with:
    # nix store prefetch-file --json <url>
    hash = "sha256-rcdTHFww8X+B3DM8ncqdeZq0GBxNIAwQp1mqfPmtGRc=";
    executable = true;
  };

  # nativeBuildInputs = [
  #   # autoPatchelfHook
  #   # makeWrapper
  # ];

  # buildInputs = [
  #   # glibc
  #   # zlib
  #   # openssl
  # ];

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp $src $out/bin/memos
    chmod +x $out/bin/memos

    runHook postInstall
  '';

  meta = with pkgs.lib; {
    description = "Memos binary release";
    homepage = "https://github.com/chris2fr/memos";
    platforms = platforms.linux;
    mainProgram = "memos";
  };
}
