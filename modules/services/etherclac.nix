{
  config,
  pkgs,
  lib,
  vars,
  ...
}: let
in {
  services.ethercalc = {
    # enable = true;
    enable = false;
    port = 8123;
  };
}
