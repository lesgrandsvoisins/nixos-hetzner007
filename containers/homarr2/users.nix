{
  pkgs,
  config,
  lib,
  # vars,
  ...
}: let
  vars = import ../../vars.nix;
in {
  users.users.homarr = {
    isNormalUser = true;
    uid = vars.uid.homarr;
    group = "users";
    extraGroups = ["caddy"];
  };
  users.groups.users.gid = vars.gid.users;
  users.groups.caddy.gid = vars.gid.caddy;
}
