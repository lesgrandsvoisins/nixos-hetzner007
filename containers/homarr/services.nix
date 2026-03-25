{
  pkgs,
  lib,
  config,
  # vars,
  ...
}: let
  vars = import ../../vars.nix;
in {
  services = {
    redis.servers.homarr = {
      enable = true;
      bind = null;
      # openFirewall = true;
    };
    postgresql = {
      enable = true;
      ensureUsers = [
        {
          name = "homarr";
          ensureDBOwnership = true;
        }
      ];
      ensureDatabases = [
        "homarr"
      ];
      enableTCPIP = false;
    };
    # postgresqlBackup = {
    #   enable = true;
    #   backupAll = true;
    # };
  };
}
