{
  pkgs,
  lib,
  config,
  vars,
  ...
}: let
in {
  users.users.oxicloud.uid = vars.uid.oxicloud;
  users.users.oxicloud.group = "services";
  users.users.oxicloud.isSystemUser = true;
  services.postgresql.ensureUsers = [
    {
      name = "oxicloud";
      ensureDBOwnership = true;
    }
  ];
  services.postgresql.ensureDatabases = ["oxicloud"];
  services.caddy = {
    virtualHosts."oxicloud.gv.je".extraConfig = ''
      reverse_proxy http://${vars.hosts.oxicloud.addr}:${builtins.toString vars.ports.oxicloud}
    '';
  };
  systemd.tmpfiles.rules = [
    "d /srv/oxicloud/storage"
  ];
  systemd.services.oxicloud = {
    enable = true;
    description = "Oxicloud Server";
    after = [
      "network.target"
      "postgresql.service"
      "oxicloud-env.service"
    ];
    environment = {
      "LOCALE_ARCHIVE" = "${pkgs.glibcLocales}/lib/locale/locale-archive";
      "TZDIR" = "${pkgs.tzdata}/share/zoneinfo";
      "OXICLOUD_STORAGE_PATH" = "/srv/oxicloud/storage";
      "OXICLOUD_STATIC_PATH" = "/srv/oxicloud/static";
      "OXICLOUD_SERVER_PORT" = "8086";
      "OXICLOUD_SERVER_HOST" = "127.0.0.1";
      "OXICLOUD_BASE_URL" = "https://oxicloud.gv.je";

      # "OXICLOUD_DB_CONNECTION_STRING" = "";
      "OXICLOUD_DB_MAX_CONNECTIONS" = "20";
      "OXICLOUD_DB_MIN_CONNECTIONS" = "5";

      "OXICLOUD_ENABLE_AUTH" = "true";
      "OXICLOUD_JWT_SECRET" = "(random)";

      "OXICLOUD_ACCESS_TOKEN_EXPIRY_SECS" = "3600";
      "OXICLOUD_REFRESH_TOKEN_EXPIRY_SECS" = "2592000";

      "OXICLOUD_ENABLE_USER_STORAGE_QUOTAS" = "false";
      "OXICLOUD_ENABLE_FILE_SHARING" = "true";
      "OXICLOUD_ENABLE_TRASH" = "true";
      "OXICLOUD_ENABLE_SEARCH" = "true";

      "OXICLOUD_OIDC_ENABLED" = "false";
      # "OXICLOUD_OIDC_ISSUER_URL" = "";
      # "OXICLOUD_OIDC_CLIENT_ID" = "";
      # "OXICLOUD_OIDC_CLIENT_SECRET" = "";
      # "OXICLOUD_OIDC_REDIRECT_URI" = "http://localhost:8086/api/auth/oidc/callback";
      # "OXICLOUD_OIDC_SCOPES" = "openid";
      # "OXICLOUD_OIDC_FRONTEND_URL" = "http://127.0.0.1:8086";

      "OXICLOUD_WOPI_ENABLED" = "false";
      # "OXICLOUD_WOPI_DISCOVERY_URL" = "";
      # "OXICLOUD_WOPI_SECRET" = "";
      #
      # dans /etc/oxicloud/oxicloud.env
      #
      # "OXICLOUD_DB_CONNECTION_STRING" = "postgres://oxicloud:@localhost:5432/oxicloud";
      # "OXICLOUD_STORAGE_PATH" = "/srv/oxicloud/storage";
      # "OXICLOUD_STATIC_PATH" = "/srv/oxicloud/static";
      # "OXICLOUD_JWT_SECRET" = "";
      # "OXICLOUD_SERVER_HOST" = "0.0.0.0";
      # "OXICLOUD_OIDC_CLIENT_SECRET" = "";
      # "OXICLOUD_OIDC_CLIENT_ID" = "oxicloud";
      # "OXICLOUD_OIDC_ISSUER_URL" = "https://key.gv.je/realms/master";
      # "OXICLOUD_OIDC_ENABLED" = "true";
      # "OXICLOUD_OIDC_REDIRECT_URI" = "https://oxicloud.gv.je/api/auth/oidc/callback";
      # "OXICLOUD_OIDC_FRONTEND_URL" = "https://oxicloud.gv.je";
      # "OXICLOUD_OIDC_ADMIN_GROUPS" = "admin";
      # "OXICLOUD_OIDC_DISABLE_PASSWORD_LOGIN" = "true";
      # "OXICLOUD_OIDC_PROVIDER_NAME" = "Key@GV.je";
    };
    enableDefaultPath = true;
    # path = [
    #   "${pkgs.coreutils}/bin"
    #   "${pkgs.coreutils}/sbin"
    #   "${pkgs.findutils}/bin"
    #   "${pkgs.findutils}/sbin"
    #   "${pkgs.gnugrep}/bin"
    #   "${pkgs.gnugrep}/sbin"
    #   "${pkgs.gnused}/bin"
    #   "${pkgs.gnused}/sbin"
    #   "${pkgs.systemd}/bin"
    #   "${pkgs.systemd}/sbin"
    # ];
    script = "${pkgs.unstable.oxicloud}/bin/oxicloud";
    unitConfig = {
    };
    serviceConfig = {
      "EnvironmentFile" = "-/etc/oxicloud/oxicloud.env";
      "WorkingDirectory" = "/srv/oxicloud";
      "ReadWritePaths" = "/srv/oxicloud";
      User = "oxicloud";
      Group = "services";
    };
  };
  # services.oxicloud = {
  #   enable = true;
  #   # database.url = "postgres://user:pass@localhost/oxicloud";
  #   user = "oxicloud";
  #   host = vars.hosts.oxicloud.addr;
  #   group = "services";
  #   dataDir = "/srv/oxicloud";
  #   port = vars.ports.oxicloud;
  #   baseUrl = "https://oxicloud.gv.je";
  # };
}
