{
  config,
  pkgs,
  lib,
  vars,
  ...
}: let
in {
  services.vaultwarden = {
    enable = true;
    environmentFile = "/etc/vaultwarden.env";
  };
}
