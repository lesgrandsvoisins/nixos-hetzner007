{
  pkgs,
  lib,
  config,
  vars,
  sync-in,
  ...
}: let
in {
  services.sync-in = {
    enable = true;
    port = vars.ports.sync-in;
    dataDir = "/srv/sync-in";
  };
}
