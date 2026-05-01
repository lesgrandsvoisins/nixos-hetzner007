{
  config,
  pkgs,
  lib,
  vars,
  ...
}: let
in {
  enable = true;
  environmentFile = "/etc/vaultwarden.env";
}
