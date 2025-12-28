{
  config,
  pkgs,
  lib,
  ...
}: let
  nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
in {
  containers.homarr = {
    bindMounts = {
    };
    autoStart = true;
    config = {
      config,
      pkgs,
      lib,
      ...
    }: {
      nix.settings.experimental-features = ["nix-command flakes"];
      imports = [
        ../modules/packages/vim.nix
        ../modules/packages/common.nix
      ];
      services.redis.servers.homarr.enable = true;

      system.stateVersion = "25.11";
    };
  };
}
