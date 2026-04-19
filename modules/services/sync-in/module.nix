{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.services.sync-in;
  yaml = pkgs.formats.yaml {};
in {
  options.services.sync-in = {
    enable = lib.mkEnableOption "Sync-in";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.callPackage ./package.nix {};
    };

    dataDir = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/sync-in";
    };

    admin = {
      login = lib.mkOption {
        type = lib.types.str;
        default = "admin";
      };

      passwordFile = lib.mkOption {
        type = lib.types.path;
      };
    };

    database = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };

      name = lib.mkOption {
        type = lib.types.str;
        default = "syncin";
      };
      user = lib.mkOption {
        type = lib.types.str;
        default = "syncin";
      };
      passwordFile = lib.mkOption {type = lib.types.path;};

      host = lib.mkOption {
        type = lib.types.str;
        default = "localhost";
      };
      port = lib.mkOption {
        type = lib.types.int;
        default = 3306;
      };
    };

    redis = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
      host = lib.mkOption {
        type = lib.types.str;
        default = "127.0.0.1";
      };
      port = lib.mkOption {
        type = lib.types.int;
        default = 6379;
      };
    };

    ldap = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };

      url = lib.mkOption {
        type = lib.types.str;
        default = "";
      };
      bindDN = lib.mkOption {
        type = lib.types.str;
        default = "";
      };
      bindPasswordFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
      };

      searchBase = lib.mkOption {
        type = lib.types.str;
        default = "";
      };
      searchFilter = lib.mkOption {
        type = lib.types.str;
        default = "(uid={{username}})";
      };
    };

    server = {
      port = lib.mkOption {
        type = lib.types.int;
        default = 8080;
      };
      host = lib.mkOption {
        type = lib.types.str;
        default = "0.0.0.0";
      };
      publicUrl = lib.mkOption {
        type = lib.types.str;
        default = "http://localhost:8080";
      };
    };

    extraSettings = lib.mkOption {
      type = lib.types.attrs;
      default = {};
    };
  };

  config = lib.mkIf cfg.enable (
    let
      configFile = yaml.generate "environment.yaml" (
        lib.recursiveUpdate
        {
          server = {
            port = cfg.server.port;
            host = cfg.server.host;
            publicUrl = cfg.server.publicUrl;
          };

          database = lib.mkIf cfg.database.enable {
            type = "mysql";
            host = cfg.database.host;
            port = cfg.database.port;
            name = cfg.database.name;
            user = cfg.database.user;
            password = "__DB_PASSWORD__";
          };

          redis = lib.mkIf cfg.redis.enable {
            host = cfg.redis.host;
            port = cfg.redis.port;
          };

          ldap = lib.mkIf cfg.ldap.enable {
            url = cfg.ldap.url;
            bindDN = cfg.ldap.bindDN;
            bindPassword = "__LDAP_PASSWORD__";
            searchBase = cfg.ldap.searchBase;
            searchFilter = cfg.ldap.searchFilter;
          };
        }
        cfg.extraSettings
      );
    in {
      services.mysql.enable = cfg.database.enable;
      services.redis.enable = cfg.redis.enable;

      users.users.sync-in = {
        isSystemUser = true;
        home = cfg.dataDir;
        createHome = true;
        group = "sync-in";
      };

      users.groups.sync-in = {};

      systemd.services.sync-in = {
        description = "Sync-in";
        wantedBy = ["multi-user.target"];
        after = ["network.target" "mysql.service" "redis.service"];

        preStart = ''
          set -e
          cd ${cfg.dataDir}

          DB_PASS=$(cat ${cfg.database.passwordFile})
          ADMIN_PASS=$(cat ${cfg.admin.passwordFile})
          LDAP_PASS=""

          if [ -n "${cfg.ldap.bindPasswordFile or ""}" ]; then
            LDAP_PASS=$(cat ${cfg.ldap.bindPasswordFile})
          fi

          cp ${configFile} environment.yaml

          substituteInPlace environment.yaml \
            --replace "__DB_PASSWORD__" "$DB_PASS" \
            --replace "__LDAP_PASSWORD__" "$LDAP_PASS"

          if [ ! -f .initialized ]; then
            ${cfg.package}/bin/sync-in init
            touch .initialized
          fi

          ${pkgs.mysql}/bin/mysql <<EOF
          CREATE DATABASE IF NOT EXISTS ${cfg.database.name};
          CREATE USER IF NOT EXISTS '${cfg.database.user}'@'localhost' IDENTIFIED BY '$DB_PASS';
          GRANT ALL PRIVILEGES ON ${cfg.database.name}.* TO '${cfg.database.user}'@'localhost';
          FLUSH PRIVILEGES;
          EOF

          ${cfg.package}/bin/sync-in migrate-db

          if [ ! -f .admin_created ]; then
            ${cfg.package}/bin/sync-in migrate-db create-user \
              --role admin \
              --login "${cfg.admin.login}" \
              --password "$ADMIN_PASS"

            touch .admin_created
          fi
        '';

        serviceConfig = {
          ExecStart = "${cfg.package}/bin/sync-in start";
          Restart = "always";
          User = "sync-in";
          WorkingDirectory = cfg.dataDir;
        };
      };
    }
  );
}
