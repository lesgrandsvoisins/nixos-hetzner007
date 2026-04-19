{
  pkgs,
  lib,
  config,
  vars,
  sync-in,
  ...
}: let
in {
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
    port = vars.ports.sync-in;
    dataDir = "/srv/sync-in";
  };
}
