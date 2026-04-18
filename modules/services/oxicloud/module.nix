{
  config,
  lib,
  pkgs,
  oxicloud,
  ...
}: let
  cfg = config.services.oxicloud;
in {
  options.services.oxicloud = {
    enable = lib.mkEnableOption "OxiCloud";

    envFile = lib.mkOption {
      type = lib.types.path;
      default = "/etc/oxicloud/oxicloud.env";
      description = "Environment file containing secrets (DATABASE_URL, etc.)";
    };

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.callPackage ./package.nix {};
    };

    user = lib.mkOption {
      type = lib.types.str;
      default = "oxicloud";
      description = "User to run OxiCloud service";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "services";
      description = "Group to run OxiCloud service";
    };

    dataDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/oxicloud";
      description = "Directory for OxiCloud data";
    };

    databaseUrl = lib.mkOption {
      type = lib.types.str;
      description = "PostgreSQL connection string";
    };

    port = lib.mkOption {
      type = lib.types.int;
      default = 8085;
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.tmpfiles.rules = [
      "d ${cfg.dataDir}/storage 0750 ${cfg.user} ${cfg.group} -"
      "d /etc/oxicloud 0750 root root -"
    ];

    # Create user/group only if using defaults
    users.users = lib.mkIf (cfg.user == "oxicloud") {
      oxicloud = {
        isSystemUser = true;
        group = cfg.group;
        description = "OxiCloud service user";
      };
    };

    users.groups = lib.mkIf (cfg.group == "oxicloud") {
      oxicloud = {};
    };

    systemd.services.oxicloud = {
      description = "OxiCloud server";
      after = ["network.target" "postgresql.service"];
      wantedBy = ["multi-user.target"];

      environment = {
        PORT = toString cfg.port;
        OXICLOUD_STORAGE_PATH = "${cfg.dataDir}/storage";
        OXICLOUD_STATIC_PATH = "${cfg.dataDir}/static";
        # OXICLOUD_SERVER_HOST = "${cfg.dataDir}/static";
      };

      # 🔥 run migrations automatically
      # preStart = ''
      #   ${cfg.package}/bin/oxicloud-migrate || true
      # '';

      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        EnvironmentFile = cfg.envFile;
        ExecStart = "${cfg.package}/bin/oxicloud";
        Restart = "always";

        # 🔥 run migrations before start
        # ExecStartPre = "${cfg.package}/bin/oxicloud-migrate";

        # 🔒 hardening
        NoNewPrivileges = true;
        PrivateTmp = true;
        ProtectSystem = "strict";
        ProtectHome = true;
        ReadWritePaths = [cfg.dataDir];

        # Non-secret config still inline
        # environment = {
        #   PORT = toString cfg.port;
        # };
      };
    };
  };
}
