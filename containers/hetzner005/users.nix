{
  pkgs,
  lib,
  config,
  ...
}: let
  vars = import ./vars.nix;
in {
  users.users.mannchri.isNormalUser = true;
  users.users.fossil.isNormalUser = true;
  users.users.guichet.isNormalUser = true;
  users.users.filebrowser.isNormalUser = true;
  users.users.mannchri.uid = vars.uid.mannchri;
  users.users.filebrowser.uid = vars.uid.filebrowser;
  users.users.guichet.uid = vars.uid.guichet;
  users.users.fossil.uid = vars.uid.fossil;
  users.groups.filebrowser.gid = vars.gid.filebrowser;
  users.groups.guichet.gid = vars.gid.guichet;
  users.groups.fossil.gid = vars.gid.fossil;
}
