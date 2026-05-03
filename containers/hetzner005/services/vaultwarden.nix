{
  config,
  pkgs,
  lib,
  vars,
  ...
}: let
  vars = import ../vars.nix;
in {
  services.vaultwarden = {
    enable = true;
    environmentFile = "/etc/vaultwarden.env";
  };
}
