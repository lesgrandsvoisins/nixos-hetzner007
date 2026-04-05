{pkgs ? import <nixpkgs> {}}:
pkgs.maven.buildMavenPackage {
  pname = "gv-je-key-authenticator";
  version = "0.0.9";

  src = ./je-gv-key-authenticator; # folder next to this .nix file

  mvnHash = "sha256-LH28BsYgeCkuLBaq+F56SzVlJuvkMwlR5rnCE3XOcbM=";

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp target/je-gv-key-authenticator*.jar $out/
    runHook postInstall
  '';
}
