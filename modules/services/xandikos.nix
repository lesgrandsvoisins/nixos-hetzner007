{
  config,
  pkgs,
  lib,
  vars,
  ...
}: let
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
