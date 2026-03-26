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
  imports = [./homarr/users.nix];
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
        reverse_proxy http://localhost:${builtins.toString vars.ports.homarr}
      '';
    };
  };
  services.postgresql = {
    ensureUsers = [
      {
        name = "homarr";
        ensureDBOwnership = true;
      }
    ];
    ensureDatabases = [
      "homarr"
    ];
  };
  containers.homarr = {
    autoStart = true;
    privateNetwork = false;
    hostAddress = vars.containers.homarr.network.ipv4.host;
    localAddress = vars.containers.homarr.network.ipv4.local;
    hostAddress6 = vars.containers.homarr.network.ipv6.host;
    localAddress6 = vars.containers.homarr.network.ipv6.local;
    bindMounts = {
      "/etc/homarr" = {
        hostPath = "/etc/homarr";
        isReadOnly = true;
      };
    };
    flake = "path:/home/mannchri/hetzner007-nixos/containers/homarr";
  };
}
