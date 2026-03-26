# home.nix
{
  pkgs,
  lib,
  config,
  vars,
  ...
}: let
in {

  users.users.memos = {
    # isNormalUser = true;
    uid = vars.uid.memos;
    # group = "services";
    # extraGroups = ["caddy"];
  };
  # users.groups.users.gid = vars.gid.users;
  # users.groups.caddy.gid = vars.gid.caddy;
}
}