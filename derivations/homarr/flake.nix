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
          # unstable = import nixpkgs-unstable {
          #   inherit system;
          #   config.allowUnfree = true;
          # };
        });
  in {
    packages = forAllSystems ({pkgs}: rec {
      homarr = import ./homarr.nix {
        inherit pkgs;
        unstable = pkgs.unstable;
      };
      default = homarr;
    });

    nixosModules.default = {
      config,
      lib,
      pkgs,
      # unstable,
      ...
    }: let
      cfg = config.services.homarr;
    in {
      options.services.homarr = {
        enable = lib.mkEnableOption "Homarr";

        package = lib.mkOption {
          type = lib.types.package;
          default = self.packages.${pkgs.stdenv.hostPlatform.system}.homarr;
          defaultText = lib.literalExpression "self.packages.\${pkgs.stdenv.hostPlatform.system}.homarr";
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

      settingsFormat = pkgs.formats.json {};

      # configFile = pkgs.writeTextDir "package.yaml" ''
      #   Yoohoo
      # '';
      configFileFormatted = pkgs.runCommand "configFileFormatted" {} ''
        mkdir -p $out
        cp --no-preserve=mode ${cfg.package}/app/homarr.env $out/homarr.env
      '';

      config = lib.mkIf cfg.enable {
        users.users = lib.mkIf (cfg.user == "homarr") {
          homarr = {
            isSystemUser = true;
            group = cfg.group;
            home = cfg.dataDir;
            createHome = true;
          };
        };

        users.groups = lib.mkIf (cfg.group == "services") {
          services = {};
        };

        systemd.tmpfiles.rules = [
          "d ${cfg.dataDir} 0750 ${cfg.user} ${cfg.group} - -"
          "d ${cfg.cacheDir} 0750 ${cfg.user} ${cfg.group} - -"
          "d /etc/homarr 0750 root ${cfg.group} - -"
        ];

        networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [cfg.port];

        systemd.services.homarr-tasks = {
          description = "Homarr Tasks";
          after = ["network.target"];
          wantedBy = ["multi-user.target"];

          environment =
            {
              # HOSTNAME = cfg.host;
              # PORT = toString cfg.port;
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
            ExecStart = "${cfg.package}/nodejs/bin/node ${cfg.package}/share/homarr/apps/tasks/tasks.cjs";
            Restart = "on-failure";
            RestartSec = 5;
          };
        };
        systemd.services.homarr-websocket = {
          description = "Homarr Websocket";
          after = ["network.target"];
          wantedBy = ["multi-user.target"];

          environment =
            {
              # HOSTNAME = cfg.host;
              # PORT = toString cfg.port;
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
            ExecStart = "${cfg.package}/nodejs/bin/node ${cfg.package}/share/homarr/apps/websocket/wssServer.cjs";
            Restart = "on-failure";
            RestartSec = 5;
          };
        };
        systemd.services.homarr-nextjs = {
          description = "Homarr Dashboard via NexJS";
          after = ["network.target"];
          wantedBy = ["multi-user.target"];

          environment =
            {
              # HOSTNAME = cfg.host;
              # PORT = toString cfg.port;
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
            ExecStart = "${cfg.package}/pnpm/bin/pnpm next start ${cfg.package}/share/homarr/apps/nextjs/";
            Restart = "on-failure";
            RestartSec = 5;
          };
        };
      };
    };

    nixosModules.homarr = self.nixosModules.default;
  };
}
