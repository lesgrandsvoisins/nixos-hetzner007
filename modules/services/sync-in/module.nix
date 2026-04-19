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

    user = lib.mkOption {
      type = lib.types.str;
      default = "sync-in";
      description = "User to run sync-in service";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "sync-in";
      description = "Group to run sync-in service";
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
        default = false;
      };
      host = lib.mkOption {
        type = lib.types.str;
        default = "127.0.0.1";
      };
      port = lib.mkOption {
        type = lib.types.int;
        default = 6380;
      };
      name = lib.mkOption {
        type = lib.types.str;
        default = "sync-in";
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

    auth = {
      provider = lib.mkOption {
        type = lib.types.str;
        default = "mysql";
        description = "Authentication method mysql | ldap | oidc";
      };
      encryptionKey = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "Key used to encrypt user secret keys in the database";
      };
      cookieSameSite = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = " `lax` | `strict`";
      };
      token.access.secret = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "Used for token and cookie signatures";
      };
    };

    oidc = {
      redirectUri = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "";
      };
      clientSecretFile = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "";
      };
      issuerUrl = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "";
      };
      clientId = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "";
      };
      options = {
        autoCreatePermissions = lib.mkOption {
          type = lib.types.str;
          default = "[personal_space, spaces_access, webdav_access]";
          description = "";
        };
        adminRoleOrGroup = lib.mkOption {
          type = lib.types.str;
          default = "admin";
          description = "";
        };
        enablePasswordAuth = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "";
        };
        autoRedirect = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "";
        };
        buttonText = lib.mkOption {
          type = lib.types.str;
          default = "key.gv.je";
          description = "";
        };
      };
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

          auth = {
            provider = cfg.auth.provider;
            encryptionKey = cfg.auth.encryptionKey;
            cookieSameSite = cfg.auth.cookieSameSite;
            token.access.secret = cfg.auth.token.access.secret;
          };

          oidc = {
            redirectUri = cfg.oidc.redirectUri;
            clientSecretFile = cfg.oidc.clientSecretFile;
            issuerUrl = cfg.oidc.issuerUrl;
            clientId = cfg.oidc.clientId;
            options = {
              autoCreatePermissions = cfg.oidc.options.autoCreatePermissions;
              adminRoleOrGroup = cfg.oidc.options.adminRoleOrGroup;
              enablePasswordAuth = cfg.oidc.options.enablePasswordAuth;
              autoRedirect = cfg.oidc.options.autoRedirect;
              buttonText = cfg.oidc.options.buttonText;
            };
          };
        }
        cfg.extraSettings
      );
    in {
      services.mysql.enable = cfg.database.enable;
      services.redis.servers."${cfg.redis.name}" = {
        enable = cfg.redis.enable;
        port = cfg.redis.port;
        bind = cfg.redis.host;
      };

      systemd.tmpfiles.rules = [
        "d /etc/sync-in 0750 ${cfg.user} ${cfg.group}"
        "f ${cfg.database.passwordFile} 0600 ${cfg.user} ${cfg.group}"
        "f ${cfg.admin.passwordFile} 0600 ${cfg.user} ${cfg.group}"
      ];

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

          if [ -n "${builtins.toString cfg.ldap.bindPasswordFile or ""}" ]; then
            LDAP_PASS=$(cat ${builtins.toString cfg.ldap.bindPasswordFile})
          fi

          cp ${configFile} environment.yaml
          cp ${configFile} ${cfg.dataDir}/environment.yaml

          substituteInPlace environment.yaml \
            --replace "__DB_PASSWORD__" "$DB_PASS" \
            --replace "__LDAP_PASSWORD__" "$LDAP_PASS"

          if [ ! -f .initialized ]; then
            ${cfg.package}/bin/sync-in init
            touch .initialized
          fi

          ${pkgs.mariadb}/bin/mysql <<EOF
          CREATE DATABASE IF NOT EXISTS ${cfg.database.name};
          CREATE USER IF NOT EXISTS '${cfg.database.user}'@'localhost' IDENTIFIED BY '$DB_PASS';
          GRANT ALL PRIVILEGES ON ${cfg.database.name}.* TO '${cfg.database.user}'@'localhost';
          FLUSH PRIVILEGES;
          EOF

          ${cfg.package}/bin/sync-in migrate-db

          if [ ! -f .admin_created ]; then
            ${cfg.package}/bin/sync-in-create-user \
              --role admin \
              --login "${cfg.admin.login}" \
              --password "$ADMIN_PASS"

            touch .admin_created
          fi
        '';

        serviceConfig = {
          ExecStart = "${cfg.package}/bin/sync-in-start";
          Restart = "always";
          User = "sync-in";
          WorkingDirectory = cfg.dataDir;
        };
      };
    }
  );
}
