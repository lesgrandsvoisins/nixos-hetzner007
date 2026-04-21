{
  pkgs,
  lib,
  config,
  vars,
  sync-in,
  ...
}: let
in {
  services.caddy.virtualHosts."sync-in.gv.je".extraConfig = ''
    reverse_proxy http://127.0.0.1:8087
  '';
  users.users.sync-in.uid = vars.uid.sync-in;
  services.mysql = {
    ensureUsers = [
      {
        name = "syncin";
        ensurePermissions = {
          "syncin.*" = "ALL PRIVILEGES";
        };
      }
    ];
    initialDatabases = [
      {
        name = "syncin";
      }
    ];
  };
  # users.users.mysql.uid = vars.uid.mysql;
  services.sync-in = {
    enable = true;
    server = {
      port = vars.ports.sync-in;
      publicUrl = "https://sync-in.gv.je";
      host = "0.0.0.0";
    };
    mail = {
      auth = {
        passFile = "/etc/sync-in/mail.password";
        user = "list@lesgrandsvoisins.com";
      };
      host = "mail.lesgrandsvoisins.com";
      port = 465;
      secure = true;
      sender = "list@lesgrandsvoisins.com";
    };
    applications = {
      files = {
        dataPath = "/srv/sftpgo";
        contentIndexing = {
          enabled = true;
          ocr = {
            enabled = true;
            languages = [
              "fra"
              "eng"
            ];
          };
        };
        collabora = {
          enabled = false;
        };
        onlyoffice = {
          enabled = false;
        };
        showHiddenFiles = false;
        maxUploadSize = 41234567890; # about 39 GB
      };
      appStore.repository = "public";
    };
    logger.level = "info";
    admin = {
      passwordFile = "/etc/sync-in/admin.secret";
      login = "sync-in";
    };
    mysql = {
      passwordFile = "/etc/sync-in/mysql.secret";
      user = "syncin";
      logQueries = false;
    };
    auth = {
      provider = "oidc";
      token = {
        access.secretFile = "/etc/sync-in/access.token";
        refresh.secretFile = "/etc/sync-in/refresh.token";
      };
      oidc = {
        issuerUrl = "https://key.gv.je/realms/master";
        clientId = "sync-in";
        clientSecretFile = "/etc/sync-in/oidc.secret";
        redirectUri = "https://sync-in.gv.je/api/auth/oidc/callback";
        security = {
          scope = "openid email profile";
          tokenEndpointAuthMethod = "client_secret_post";
        };
        options = {
          adminRoleOrGroup = "admin";
          autoCreatePermissions = ["personal_space" "spaces_access" "webdav_access"];
          autoRedirect = false;
          buttonText = "key.gv.je";
          enablePasswordAuth = false;
        };
      };
    };
    user = "sync-in";
    group = "services";
  };
}
