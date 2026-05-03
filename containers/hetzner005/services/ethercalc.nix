{
  config,
  pkgs,
  lib,
  vars,
  ...
}: let
  vars = import ../vars.nix;
in {
  services.ethercalc = {
    # enable = true;
    enable = false;
    port = 8123;
  };
}
