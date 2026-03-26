{
  pkgs,
  lib,
  config,
  # vars,
  ...
}: let
  vars = import ../../vars.nix;
in {
  services = {
    redis.servers.homarr = {
      enable = true;
      bind = null;
      # openFirewall = true;
    };
  };
}
