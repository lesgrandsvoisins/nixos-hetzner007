{ config, pkgs, system, lib, ... }:
let
  nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
in
{
  containers.homarr = {
    bindMounts = {
    };
    autoStart = true;
    config = { config, pkgs, lib, ... }: {
      imports = [
        ../imports/packages/vim.nix
        ../imports/packages/common.nix
      ];
      
      system.stateVersion = "25.11";
    };
  };
}