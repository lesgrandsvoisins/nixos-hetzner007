{
  config,
  pkgs,
  lib,
  ...
}: let
  vars = import ../vars.nix;
  # homarr = pkgs.callPackage ../derivations/homarr/package.nix {};
  # nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  # unstable = import <nixpkgs-unstable>;
in {
  containers.homarr = {
    bindMounts = {
    };
    autoStart = true;
    flake = "path:/home/mannchri/whowhatetc-nixos/containers/homarr/flake";
    # config = /home/mannchri/whowhatetc-nixos/containers/homarr/config
  };
}
