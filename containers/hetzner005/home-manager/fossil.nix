{
  config,
  pkgs,
  lib,
  ...
}: let
in {
  home.username = "fossil";
  home.homeDirectory = lib.mkDefault "/home/fossil";
  home.packages = with pkgs; [
    fossil
  ];
  home.stateVersion = "26.05";
  programs.home-manager.enable = true;
}
