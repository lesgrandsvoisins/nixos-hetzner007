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
  containers.homarr = {
    bindMounts = {
      "/etc/keycloak/" = {
        hostPath = "/etc/keycloak/";
        isReadOnly = true;
      };
    };
    autoStart = true;
    flake = "path:/home/mannchri/grandsvoisins-nixos/containers/homarr";
  };
}
