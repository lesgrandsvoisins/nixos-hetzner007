{
  pkgs,
  lib,
  config,
  vars,
  ...
}: let
in {
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
  };
}
