{
  config,
  pkgs,
  lib,
  ...
}: let
in {
  home.username = "filebrowser";
  home.homeDirectory = lib.mkDefault "/home/filebrowser";
  home.packages = with pkgs; [
    filebrowser
  ];
  home.stateVersion = "26.05";
  programs.home-manager.enable = true;
}
