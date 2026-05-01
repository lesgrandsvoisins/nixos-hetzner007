{
  config,
  pkgs,
  lib,
  ...
}: let
  vars = import ./vars.nix;
in {
  imports = [
    ./common.nix
    ./services.nix
  ];
  system.stateVersion = "25.11";
  users.groups.services.gid = vars.gid.services;
  users.users.vikunja.uid = vars.uid.vikunja;
}
