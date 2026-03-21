{
  config,
  pkgs,
  lib,
  vars,
  ...
}: let
  # vars = import ../vars.nix;
  # homarr = pkgs.callPackage ../derivations/homarr/package.nix {};
  # nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  # unstable = import <nixpkgs-unstable>;
in {
  containers.homarr2 = {
    bindMounts = {
    };
    autoStart = true;
    flake = "file:///home/mannchri/nixos-hetzner007/containers/homarr2/";
  };
}
