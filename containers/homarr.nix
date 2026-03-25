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
    "d /etc/homarr 0755 homarr services"
    "f /etc/homarr/homarr.env 0755 homarr services"
  ];
  # networking.hosts = {
  #   "${vars.containers.homarr.network.ipv4.local}" = [
  #     "${vars.containers.homarr.network.lanName}"
  #     "${vars.containers.homarr.network.hostName}"
  #   ];
  #   "${vars.containers.homarr.network.ipv6.local}" = [
  #     "${vars.containers.homarr.network.lanName}"
  #     "${vars.containers.homarr.network.hostName}"
  #   ];
  # };
  services.caddy.virtualHosts = {
    "je.grandsvoisins.org" = {
      extraConfig = ''
        redir https://www.gv.je{uri} 301
      '';
    };
    "gv.je" = {
      extraConfig = ''
        redir https://www.gv.je{uri} 301
      '';
    };
    "www.gv.je" = {
      extraConfig = ''
        reverse_proxy http://${vars.containers.homarr.network.ipv4.local}:${builtins.toString vars.ports.homarr}
      '';
    };
  };
  containers.homarr = {
    autoStart = true;
    privateNetwork = true;
    hostAddress = vars.containers.homarr.network.ipv4.host;
    localAddress = vars.containers.homarr.network.ipv4.local;
    hostAddress6 = vars.containers.homarr.network.ipv6.host;
    localAddress6 = vars.containers.homarr.network.ipv6.local;
    bindMounts = {
    };
    flake = "path:/home/mannchri/hetzner007-nixos/containers/homarr";
  };
}
