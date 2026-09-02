{
  config,
  pkgs,
  lib,
  ...
}: let
in {
  home.username = "guichet";
  home.homeDirectory = lib.mkDefault "/home/guichet";
  home.packages = with pkgs; [
    go
    gnumake
    python311
    nodejs_20
  ];
  home.stateVersion = "26.05";
  programs.home-manager.enable = true;
}
