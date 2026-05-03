{
  config,
  pkgs,
  lib,
  vars,
  ...
}: let
  vars = import ../vars.nix;
in {
  services.xandikos = {
    enable = true;
    port = vars.ports.xandikos;
    extraOptions = [
      "--autocreate"
      "--defaults"
    ];
  };
}
