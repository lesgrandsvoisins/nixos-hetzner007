{
  description = "Dashy built dynamically with Yarn (no buildNpmPackage)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        node20 = pkgs.nodejs_20;
      in
      {
        packages.default = pkgs.stdenv.mkDerivation rec {
          pname = "dashy";
          version = "3.1.1";

          src = pkgs.fetchFromGitHub {
            owner = "Lissy93";
            repo = "dashy";
            tag = "${version}";
            hash = "sha256-ci4YlxFNp+JD5EzYfhtM9jKy5fl+a48vp9QzZHh5NRg="; # first build → copy got:
          };

          buildInputs = [ node20 pkgs.yarn ];

          dontUseSandbox = true;
          makeCacheWritable = true;

          # Run Yarn dynamically at build time
          buildPhase = ''
            echo "Installing Dashy dependencies with Yarn..."
            yarn --ignore-engines install 
            yarn --ignore-engines build 
          '';

          installPhase = ''
            mkdir -p $out
            cp -r ./* $out/
          '';

          meta = with pkgs.lib; {
            description = "Dashy dashboard installed dynamically with Yarn";
            homepage = "https://dashy.to/";
            license = licenses.mit;
          };
        };

        # Dev shell for local development
        devShells.default = pkgs.mkShell {
          buildInputs = [
            node20
            pkgs.yarn
          ];
        };
      }
    );
}
