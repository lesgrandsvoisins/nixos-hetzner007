{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.services.sync-in;
in {
  options.services.sync-in = {
    enable = lib.mkEnableOption "Sync-in";

    adminUser = lib.mkOption {
      type = lib.types.str;
      default = "admin";
    };

    adminPasswordFile = lib.mkOption {
      type = lib.types.path;
    };

    database = {
      name = lib.mkOption {
        type = lib.types.str;
        default = "syncin";
      };
      user = lib.mkOption {
        type = lib.types.str;
        default = "syncin";
      };
      passwordFile = lib.mkOption {type = lib.types.path;};
    };
  };

  config = lib.mkIf cfg.enable {
    services.mysql.enable = true;

    systemd.services.sync-in = {
      description = "Sync-in";
      after = ["network.target" "mysql.service"];
      wantedBy = ["multi-user.target"];

      preStart = ''
        set -e

        export HOME=/var/lib/sync-in
        cd /var/lib/sync-in

        ADMIN_PASS=$(cat ${cfg.adminPasswordFile})
        DB_PASS=$(cat ${cfg.database.passwordFile})

        # 1. init only once
        if [ ! -f .initialized ]; then
          echo "Initializing Sync-in..."

          ${cfg.package}/bin/sync-in init

          # Patch environment.yaml
          sed -i "s/password:.*/password: $DB_PASS/" environment.yaml

          touch .initialized
        fi

        # 2. ensure DB exists
        ${pkgs.mysql}/bin/mysql <<EOF
        CREATE DATABASE IF NOT EXISTS ${cfg.database.name};
        CREATE USER IF NOT EXISTS '${cfg.database.user}'@'localhost' IDENTIFIED BY '$DB_PASS';
        GRANT ALL PRIVILEGES ON ${cfg.database.name}.* TO '${cfg.database.user}'@'localhost';
        FLUSH PRIVILEGES;
        EOF

        # 3. run migrations (safe to re-run)
        ${cfg.package}/bin/sync-in migrate-db

        # 4. create admin only if missing
        if [ ! -f .admin_created ]; then
          ${cfg.package}/bin/sync-in migrate-db create-user \
            --role admin \
            --login "${cfg.adminUser}" \
            --password "$ADMIN_PASS"

          touch .admin_created
        fi
      '';

      serviceConfig = {
        ExecStart = "${cfg.package}/bin/sync-in start";
        WorkingDirectory = "/var/lib/sync-in";
        Restart = "always";
        User = "sync-in";
      };
    };

    users.users.sync-in = {
      isSystemUser = true;
      home = "/var/lib/sync-in";
      createHome = true;
      group = "sync-in";
    };

    users.groups.sync-in = {};
  };
}
