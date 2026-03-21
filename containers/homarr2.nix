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
  systemd.tmpfiles.rules = [
    "d /etc/homarr2 0755 homarr services"
  ];
  containers.homarr2 = {
    bindMounts = {
      "/etc/homarr2" = {
        hostPath = "/etc/homarr2";
        isReadOnly = true;
      };
    };
    autoStart = true;
    privateNetwork = true;
    hostAddress = vars.containers.homarr2.network.ipv4.host;
    localAddress = vars.containers.homarr2.network.ipv4.local;
    hostAddress6 = vars.containers.homarr2.network.ipv6.host;
    localAddress6 = vars.containers.homarr2.network.ipv6.local;
    flake = "file://./homarr2.tgz";
  };
}
