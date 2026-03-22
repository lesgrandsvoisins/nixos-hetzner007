{
  description = "Homarr package + NixOS module";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
  }: let
    lib = nixpkgs.lib;
    systems = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];

    forAllSystems = f:
      lib.genAttrs systems (system:
        f {
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;

            overlays = [
              (final: prev: {
                unstable = import nixpkgs-unstable {
                  inherit system;
                  config.allowUnfree = true;
                };
              })
              # (final: prev: {
              #   homarr = import homarr {
              #     inherit system;
              #   };
              # })
            ];
          };
        });

    mkHomarr = {pkgs}: let
      inherit (pkgs) stdenv;
      nodejs = pkgs.unstable.nodejs_25;
      pnpm = pkgs.unstable.pnpm.override {inherit nodejs;};
      homarrAssets = ./assets;
    in
      stdenv.mkDerivation (finalAttrs: {
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
            pkgs.unstable.pnpmConfigHook
            pnpm
          ]
          ++ pkgs.lib.optionals stdenv.hostPlatform.isDarwin [pkgs.cctools];

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
      });
  in {
    packages = forAllSystems ({pkgs}: rec {
      homarr = mkHomarr {inherit pkgs;};
      default = homarr;
    });

    nixosModules.default = {
      config,
      lib,
      pkgs,
      ...
    }: let
      cfg = config.services.homarr;
    in {
      options.services.homarr = {
        enable = lib.mkEnableOption "Homarr";

        package = lib.mkOption {
          type = lib.types.package;
          default = self.packages.${pkgs.system}.homarr;
          defaultText = lib.literalExpression "self.packages.\${pkgs.system}.homarr";
          description = "The Homarr package to use.";
        };

        user = lib.mkOption {
          type = lib.types.str;
          default = "homarr";
          description = "User account under which Homarr runs.";
        };

        group = lib.mkOption {
          type = lib.types.str;
          default = "homarr";
          description = "Group under which Homarr runs.";
        };

        port = lib.mkOption {
          type = lib.types.port;
          default = 7575;
          description = "Port Homarr listens on.";
        };

        host = lib.mkOption {
          type = lib.types.str;
          default = "127.0.0.1";
          description = "Address Homarr listens on.";
        };

        dataDir = lib.mkOption {
          type = lib.types.path;
          default = "/var/lib/homarr";
          description = "Homarr state directory.";
        };

        cacheDir = lib.mkOption {
          type = lib.types.path;
          default = "/var/cache/homarr";
          description = "Homarr cache directory.";
        };

        environmentFile = lib.mkOption {
          type = lib.types.nullOr lib.types.path;
          default = "/etc/homarr/homarr.env";
          description = "Environment file passed to the service.";
        };

        openFirewall = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Open the configured port in the firewall.";
        };

        extraEnvironment = lib.mkOption {
          type = lib.types.attrsOf lib.types.str;
          default = {};
          description = "Extra environment variables for Homarr.";
        };
      };

      config = lib.mkIf cfg.enable {
        users.users = lib.mkIf (cfg.user == "homarr") {
          homarr = {
            isSystemUser = true;
            group = cfg.group;
            home = cfg.dataDir;
            createHome = true;
          };
        };

        users.groups = lib.mkIf (cfg.group == "homarr") {
          homarr = {};
        };

        systemd.tmpfiles.rules = [
          "d ${cfg.dataDir} 0750 ${cfg.user} ${cfg.group} - -"
          "d ${cfg.cacheDir} 0750 ${cfg.user} ${cfg.group} - -"
          "d /etc/homarr 0750 root ${cfg.group} - -"
        ];

        networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [cfg.port];

        systemd.services.homarr = {
          description = "Homarr Dashboard";
          after = ["network.target"];
          wantedBy = ["multi-user.target"];

          environment =
            {
              HOSTNAME = cfg.host;
              PORT = toString cfg.port;
              NODE_ENV = "production";
              NIXPKGS_HOMARR_CACHE_DIR = toString cfg.cacheDir;
            }
            // cfg.extraEnvironment;

          serviceConfig = {
            Type = "simple";
            User = cfg.user;
            Group = cfg.group;
            WorkingDirectory = "${cfg.package}/share/homarr";
            StateDirectory = lib.mkIf (cfg.dataDir == "/var/lib/homarr") "homarr";
            CacheDirectory = lib.mkIf (cfg.cacheDir == "/var/cache/homarr") "homarr";
            EnvironmentFile = lib.mkIf (cfg.environmentFile != null) cfg.environmentFile;
            ExecStart = "${pkgs.unstable.nodejs_25}/bin/node ${cfg.package}/share/homarr/apps/nextjs/server.js";
            Restart = "on-failure";
            RestartSec = 5;
          };
        };
      };
    };

    nixosModules.homarr = self.nixosModules.default;
  };
}
