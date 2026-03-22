{
  pkgs,
  lib,
  config,
  # vars,
  ...
}: let
  vars = import ../../vars.nix;
  # homarr = pkgs.callPackage ../../derivations/homarr/package.nix {};
in {
  boot.isNspawnContainer = true;
  # environment.systemPackages = [homarr];
  services = {
    redis.servers.homarr.enable = true;
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
    };
    postgresqlBackup = {
      enable = true;
      backupAll = true;
    };
  };
}
