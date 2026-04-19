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
        name = "sync-in";
        ensurePermissions = {
          "sync-in.*" = "ALL PRIVILEGES";
        };
      }
    ];
    initialDatabases = [
      {
        name = "sync-in";
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
