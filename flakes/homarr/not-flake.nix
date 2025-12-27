{
  description = "Homarr Dashboard";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
        nodejs = pkgs.nodejs_25;
        pnpm = pkgs.pnpm_10.override { nodejs = nodejs; };
        fetchPnpmDeps = pkgs.fetchPnpmDeps;
        stdenv = pkgs.stdenv;
      in
      {
        packages.default = stdenv.mkDerivation (finalAttrs: {
          pname = "homarr";
          version = "1.48.0";

          src = pkgs.fetchFromGitHub {
            owner = "homarr-labs";
            repo = "homarr";
            tag = "v${finalAttrs.version}";
            hash = "sha256-iWdaQv+aTPB+4uDCgkoLMq7tVfCFN8kv+acRo9Oby5g="; # first build → copy `got:` here
            # sha256-iWdaQv+aTPB+4uDCgkoLMq7tVfCFN8kv+acRo9Oby5g=
          };

          nativeBuildInputs = [
            pnpm
            nodejs
          ];

          # pnpmDeps = pnpm.fetchDeps {
          pnpmDeps = fetchPnpmDeps {
            inherit (finalAttrs) pname version src;
            pnpm = pnpm;
            nodejs = nodejs;
            fetcherVersion = 3;
            hash = "sha256-fh599IyeF0EUlyyvinDiaq/qsJB3Zdp1WQ2iYr2L/GM=";
          };

          # configurePhase = ''
          #   export PATH="${node}/bin:$PATH"
          #   pnpm install --offline --frozen-lockfile --ignore-engines
          # '';

          # buildPhase = ''
          #   pnpm build
          # '';
          # dontUseSandbox = true;
          # installPhase = ''
          #   mkdir -p $out
          #   cp -r . $out/
          #   pnpm install --dir $out
          # '';

          # npmDepsHash = ""; # second build → copy `got:` here

          # buildPhase = ''
          #   echo "Installing dependencies with PNPM..."
          #   pnpm config set nodeVersion 25.2.1

          # '';
          # buildPhase = ''
          #   pnpm build
          # '';
          # configurePhase = ''
          #     ${pnpm}/bin/pnpm --offline --frozen-lockfile --ignore-engines
          # '';
          # installPhase = ''
          #   mkdir -p $out
          #   cp -r .next public $out/
          # '';

          # npmPackFlags = [ "--ignore-engines" ];
          # NODE_OPTIONS = "";

          # Inject your local package-lock.json
          # postPatch = ''
          #   echo "Copying vendored package-lock.json..."
          #   cp ${./package.json} package.json
          #   cp ${./pnpm-lock.yaml} pnpm-lock.yaml
          #   cp ${./pnpm-workspace.yaml} pnpm-workspace.yaml
          # '';

          # installPhase = ''
          #   mkdir -p $out/bin
          #   pnpm install

          # '';

          # buildPhase = ''
          #   mkdir -p $out/bin
          #   pnpm install
          # '';
          # corepack enable --install-directory=$out/bin pnpm

          meta = {
            description = "Homarr, a modernish dashboard";
            homepage = "https://homarr.dev/";
          };
        });

        devShells.default = pkgs.mkShell {
          buildInputs = [
            pnpm
            nodejs
          ];
        };
        # apps.default = {
        #   type = "app";
        #   program = "${self.packages.${system}.homarr}/public/index.html";
        # };
      }
    );
}
