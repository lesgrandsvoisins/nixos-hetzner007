{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  };

  # outputs = {
  #   self,
  #   nixpkgs,
  #   nixpkgs-unstable,
  #   unstable-packages,
  #   ...
  outputs = inputs @ {
    nixpkgs,
    nixpkgs-unstable,
    ...
  }: let
    vars = import ../../vars.nix;
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
      overlays = [
        (final: prev: {
          unstable = import nixpkgs-unstable {
            inherit system;
            config.allowUnfree = true;
          };
        })
      ];
    };
    homarr = import ../../derivations/homarr/package.nix {
      unstable = pkgs.unstable;
      pkgs = pkgs;
      fetchFromGitHub = pkgs.fetchFromGitHub;
      nodePackages = pkgs.nodePackages;
      makeWrapper = pkgs.makeWrapper;
      nodejs = pkgs.nodejs_24;
      pnpm = pkgs.unstable.pnpm.override {nodejs = pkgs.nodejs_24;};
      fetchPnpmDeps = pkgs.fetchPnpmDeps;
      pnpmConfigHook = pkgs.pnpmConfigHook;
      python3 = pkgs.python3;
      stdenv = pkgs.stdenv;
      unixtools = pkgs.unixtools;
      cctools = pkgs.cctools;
      lib = pkgs.lib;
      nixosTests = pkgs.nixosTests;
      gnused = pkgs.gnused;
    };
  in {
    nixosConfigurations.container = nixpkgs.lib.nixosSystem {
      inherit system;

      modules = [
        ({
          pkgs,
          lib,
          config,
          ...
        }: let
        in {
          boot.isContainer = true;
          boot.isNspawnContainer = true;

          # networking.firewall.allowedTCPPorts = [80 443];
          # networking.hostname = "homarr";

          nix.settings.experimental-features = ["nix-command flakes"];

          imports = [
            ../../modules/packages/vim.nix
            ../../modules/packages/common.nix
            ./services.nix
            ./systemd-services.nix
            ./users.nix
          ];
          environment.systemPackages = [
            homarr
          ];

          system.stateVersion = "25.11";
          console.enable = true;
          systemd.services = {
            homarr-setup = {
              enable = true;
              wantedBy = ["multi-user.target"];
              unitConfig = {
                Type = "oneshot";
              };
              serviceConfig = {
                User = "homarr";
                Group = "services";
              };
              script = "${homarr}/bin/install.sh";
            };
          };
          systemd.tmpfiles.rules = [
            "d /etc/homarr2 0755 homarr services"
          ];
          networking = {
            hostName = vars.containers.homarr2.network.hostName;
            domain = vars.containers.homarr2.network.domain;
            hosts = {
              "${vars.containers.homarr2.network.ipv6.local}" = [vars.containers.homarr2.network.domain];
            };
            useHostResolvConf = false;
            interfaces."eth0".useDHCP = true;
            firewall = {
              enable = true;
              allowedTCPPorts = [
                80
                443
              ];
            };
          };

          services = {
            resolved = {
              enable = true;
            };
          };
        })
      ];
    };
  };
}
