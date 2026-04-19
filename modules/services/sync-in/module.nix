{
  config,
  lib,
  pkgs,
  sync-in,
  ...
}: let
  cfg = config.services.sync-in;
in {
  options.services.sync-in = {
    enable = lib.mkEnableOption "Sync-in server";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.callPackage ./package.nix {inherit pkgs;};
      description = "Sync-in package";
    };

    port = lib.mkOption {
      type = lib.types.int;
      default = 8080;
    };

    dataDir = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/sync-in";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.sync-in = {
      description = "Sync-in Server";
      wantedBy = ["multi-user.target"];

      after = ["network.target"];

      serviceConfig = {
        WorkingDirectory = cfg.dataDir;
        ExecStart = "${cfg.package}/bin/node ${cfg.package}/server.js";
        Restart = "always";
        User = "sync-in";
        Group = "sync-in";
        Environment = [
          "PORT=${toString cfg.port}"
        ];
      };
    };

    users.users.sync-in = {
      isSystemUser = true;
      group = "sync-in";
      home = cfg.dataDir;
      createHome = true;
    };

    users.groups.sync-in = {};
  };
}
