{
  config,
  pkgs,
  lib,
  vars,
  ...
}: let
in {
  home-manager.users.wagtail = {pkgs, ...}: {
    home.packages = with pkgs; [
      python311
      python311Packages.pillow
      python311Packages.gunicorn
      python311Packages.pip
      libjpeg
      zlib
      libtiff
      freetype
      python311Packages.venvShellHook
    ];
    home.stateVersion = "25.11";
    programs.home-manager.enable = true;
  };
}
