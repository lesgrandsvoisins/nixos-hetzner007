{
  config,
  pkgs,
  lib,
  vars,
  ...
}: let
  # vars = import ./hetzner005/vars.nix;
  home-manager = {
    url = "github:nix-community/home-manager/release-25.11";
    # The `follows` keyword in inputs is used for inheritance.
    # Here, `inputs.nixpkgs` of home-manager is kept consistent with
    # the `inputs.nixpkgs` of the current flake,
    # to avoid problems caused by different versions of nixpkgs.
    inputs.nixpkgs.follows = "nixpkgs";
  };
  agenix.url = "github:ryantm/agenix";
  simple-nixos-mailserver.url = "gitlab:simple-nixos-mailserver/nixos-mailserver/nixos-25.11";
in {
  containers.hetzner005.localAddress = vars.containers.hetzner005.localAddress;
  containers.hetzner005.hostAddress = vars.containers.hetzner005.hostAddress;
  containers.hetzner005.localAddress6 = vars.containers.hetzner005.localAddress6;
  containers.hetzner005.hostAddress6 = vars.containers.hetzner005.hostAddress6;
  containers.hetzner005.bindMounts = vars.containers.hetzner005.bindMounts;

  containers.hetzner005 = {
    autoStart = false;
    privateNetwork = true;
    config = {
      config,
      pkgs,
      lib,
      ...
    }: let
      vars = import ./hetzner005/vars.nix;
    in {
      imports = [
        ./hetzner005/configuration.nix
      ];
    };
  };
}
