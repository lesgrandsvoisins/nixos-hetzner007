{
  config,
  pkgs,
  lib,
  vars,
  ...
}: let
  host_vars = import ../vars.nix;
  vars = import ./vars.nix;
  home-manager = {
    url = "github:nix-community/home-manager/release-25.11";
    # The `follows` keyword in inputs is used for inheritance.
    # Here, `inputs.nixpkgs` of home-manager is kept consistent with
    # the `inputs.nixpkgs` of the current flake,
    # to avoid problems caused by different versions of nixpkgs.
    inputs.nixpkgs.follows = "nixpkgs";
  };
  agenix.url = "github:ryantm/agenix";
  # simple-nixos-mailserver.url = "gitlab:simple-nixos-mailserver/nixos-mailserver/nixos-25.11";
in {
  containers.hetzner005.localAddress = host_vars.containers.hetzner005.localAddress;
  containers.hetzner005.hostAddress = host_vars.containers.hetzner005.hostAddress;
  containers.hetzner005.localAddress6 = host_vars.containers.hetzner005.localAddress6;
  containers.hetzner005.hostAddress6 = host_vars.containers.hetzner005.hostAddress6;
  containers.hetzner005.bindMounts = host_vars.containers.hetzner005.bindMounts;

  containers.hetzner005 = {
    autoStart = true;
    privateNetwork = true;
    config = {
      config,
      pkgs,
      lib,
      vars,
      ...
    }: let
      # vars = import ./hetzner005/vars.nix;
    in {
      imports = [
        (builtins.fetchTarball {
          # Pick a release version you are interested in and set its hash, e.g.
          url = "https://gitlab.com/simple-nixos-mailserver/nixos-mailserver/-/archive/nixos-25.11/nixos-mailserver-nixos-25.11.tar.gz";
          # To get the sha256 of the nixos-mailserver tarball, we can use the nix-prefetch-url command:
          # release="nixos-25.11"; nix-prefetch-url "https://gitlab.com/simple-nixos-mailserver/nixos-mailserver/-/archive/${release}/nixos-mailserver-${release}.tar.gz" --unpack
          sha256 = "sha256:0f1mq2gdmx9wd0k89f6w61sbfzpd1wwz857l2xvyp1x0msmd2z20";
        })
        ./hetzner005/configuration.nix
      ];
    };
  };
}
