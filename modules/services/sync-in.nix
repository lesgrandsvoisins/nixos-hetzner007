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
    server.port = vars.ports.sync-in;
    dataDir = "/srv/sync-in";
    admin.passwordFile = "/etc/sync-in/admin.secret";
    admin.login = "sync-in";
    database.passwordFile = "/etc/sync-in/database.secret";
    user = "sync-in";
    group = "services";
  };
}
