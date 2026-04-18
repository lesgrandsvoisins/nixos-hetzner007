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

    dataDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/oxicloud";
      description = "Directory for OxiCloud data";
    };

    storagePath = lib.mkOption {
      type = lib.types.path;
      default = "${cfg.dataDir}/storage";
      description = "Path for storage file storage";
    };

    staticPath = lib.mkOption {
      type = lib.types.path;
      default = "${cfg.dataDir}/static";
      description = "Path for static file storage";
    };

    port = lib.mkOption {
      type = lib.types.int;
      default = 8085;
      description = "Server port";
    };

    host = lib.mkOption {
      type = lib.types.str;
      default = "127.0.0.1";
      description = "Server bind address";
    };

    baseUrl = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "Public base URL for share links";
    };

    database = {
      url = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "PostgreSQL connection string: postgres://postgres:postgres@localhost:5432/oxicloud";
      };

      maxConnections = lib.mkOption {
        type = lib.types.int;
        default = 20;
        description = "Max pool connections";
      };

      minConnections = lib.mkOption {
        type = lib.types.int;
        default = 5;
        description = "Min pool connections";
      };
    };

    auth = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable authentication";
      };

      jwtSecret = lib.mkOption {
        type = lib.types.str;
        default = "(random)";
        description = "JWT signing secret";
      };

      accessTokenExpirySecs = lib.mkOption {
        type = lib.types.int;
        default = 3600;
        description = "Access token lifetime (seconds)";
      };

      refreshTokenExpirySecs = lib.mkOption {
        type = lib.types.int;
        default = 2592000;
        description = "Refresh token lifetime (seconds)";
      };
    };

    features = {
      userStorageQuotas = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Per-user storage quotas";
      };

      fileSharing = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "File/folder sharing";
      };

      trash = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Trash / recycle bin";
      };

      search = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Search";
      };
    };

    sso = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable OIDC";
      };

      issuerUrl = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "OIDC issuer URL";
      };

      clientId = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "Client ID";
      };

      clientSecret = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "Client secret";
      };

      redirectUri = lib.mkOption {
        type = lib.types.str;
        default = "http://localhost:8086/api/auth/oidc/callback";
        description = "Callback URL";
      };

      scopes = lib.mkOption {
        type = lib.types.str;
        default = "openid";
        description = "profile email	Requested scopes";
      };

      frontendUrl = lib.mkOption {
        type = lib.types.str;
        default = "http://localhost:8086";
        description = "Frontend URL";
      };

      autoProvision = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Auto-create users on first SSO login";
      };

      adminGroups = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "Groups that grant admin role";
      };

      disablePasswordLogin = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Hide password form when OIDC enabled";
      };

      providerName = lib.mkOption {
        type = lib.types.str;
        default = "SSO";
        description = "Display name for the provider";
      };
    };
    wopi = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable WOPI";
      };

      discoveryUrl = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "Collabora/OnlyOffice discovery URL";
      };

      secret = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "(JWT secret) WOPI token signing key";
      };

      tokenTtlSecs = lib.mkOption {
        type = lib.types.int;
        default = 86400;
        description = "Token lifetime";
      };

      lockTtlSecs = lib.mkOption {
        type = lib.types.int;
        default = 1800;
        description = "Lock expiration";
      };
    };

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.callPackage ./package.nix {};
      description = "oxicloud nix package";
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

    # dataDir = lib.mkOption {
    #   type = lib.types.path;
    #   default = "/var/lib/oxicloud";
    #   description = "Directory for OxiCloud data";
    # };

    # databaseUrl = lib.mkOption {
    #   type = lib.types.str;
    #   default = "";
    #   description = "PostgreSQL connection string";
    # };
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
        STORAGE_PATH = cfg.storagePath;
        STATIC_PATH = cfg.staticPath;
        SERVER_PORT = builtins.toString cfg.port;
        SERVER_HOST = cfg.host;
        BASE_URL = cfg.baseUrl;
        DB_CONNECTION_STRING = cfg.database.url;
        DB_MAX_CONNECTIONS = builtins.toString cfg.database.maxConnections;
        DB_MIN_CONNECTIONS = builtins.toString cfg.database.minConnections;
        JWT_SECRET = cfg.auth.jwtSecret;
        ACCESS_TOKEN_EXPIRY_SECS = builtins.toString cfg.auth.accessTokenExpirySecs;
        REFRESH_TOKEN_EXPIRY_SECS = builtins.toString cfg.auth.refreshTokenExpirySecs;
        ENABLE_AUTH = builtins.toString cfg.auth.enable;
        ENABLE_USER_STORAGE_QUOTAS = builtins.toString cfg.features.userStorageQuotas;
        ENABLE_FILE_SHARING = builtins.toString cfg.features.fileSharing;
        ENABLE_TRASH = builtins.toString cfg.features.trash;
        ENABLE_SEARCH = builtins.toString cfg.features.search;
        OIDC_ENABLED = builtins.toString cfg.sso.enable;
        OIDC_ISSUER_URL = cfg.sso.issuerUrl;
        OIDC_CLIENT_ID = cfg.sso.clientId;
        OIDC_CLIENT_SECRET = cfg.sso.clientSecret;
        OIDC_REDIRECT_URI = cfg.sso.redirectUri;
        OIDC_SCOPES = cfg.sso.scopes;
        OIDC_FRONTEND_URL = cfg.sso.frontendUrl;
        OIDC_AUTO_PROVISION = builtins.toString cfg.sso.autoProvision;
        OIDC_ADMIN_GROUPS = cfg.sso.adminGroups;
        OIDC_DISABLE_PASSWORD_LOGIN = builtins.toString cfg.sso.disablePasswordLogin;
        OIDC_PROVIDER_NAME = cfg.sso.providerName;
        WOPI_ENABLED = builtins.toString cfg.wopi.enable;
        WOPI_DISCOVERY_URL = cfg.wopi.discoveryUrl;
        WOPI_SECRET = cfg.wopi.secret;
        WOPI_TOKEN_TTL_SECS = builtins.toString cfg.wopi.tokenTtlSecs;
        WOPI_LOCK_TTL_SECS = builtins.toString cfg.wopi.lockTtlSecs;
      };

      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        EnvironmentFile = cfg.envFile;
        ExecStart = "${cfg.package}/bin/oxicloud";
        Restart = "always";
        WorkingDirectory = "${cfg.dataDir}";

        # 🔒 hardening
        NoNewPrivileges = true;
        PrivateTmp = true;
        ProtectSystem = "strict";
        ProtectHome = true;
        ReadWritePaths = [cfg.dataDir];
      };
    };
  };
}
