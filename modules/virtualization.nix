{
  config,
  pkgs,
  lib,
  vars,
  ...
}: let
in {
  virtualisation.docker = {
    enable = true;
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };

  users.extraGroups.docker.members = ["mannchri"];

  virtualisation.lxc.enable = true;
  virtualisation.lxc.lxcfs.enable = true;
}
