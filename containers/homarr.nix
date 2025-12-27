{ config, pkgs, lib, ... }:
let
  nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
in
{
  containers.homarr = {
    bindMounts = {
    };
    autoStart = true;
    config = { config, pkgs, lib, ... }: {
      nix.settings.experimental-features = "nix-command flakes";
      imports = [
        ../imports/packages/vim.nix
        ../imports/packages/common.nix
      ];
      services.redis.servers.homarr.enable = true;

      system.stateVersion = "25.11";
    };
  };
}