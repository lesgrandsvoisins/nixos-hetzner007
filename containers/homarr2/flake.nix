{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    homarr-flake.url = "path:../../derivations/homarr";
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
    homarr-flake,
    ...
  }: let
    vars = import ../../vars.nix;
    system = "x86_64-linux";
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
          # homarr = import homarr {inherit system;};
          # homarr-package = import homarr-flake.packages.${stdenv.hostPlatform.system}.homarr;
          # homarr-module = import homarr-flake.nixosModules.${stdenv.hostPlatform.system}.homarr;
          pkgs = import nixpkgs {
            # system = pkgs.stdenv.hostPlatform.system;
            inherit system;
            config.allowUnfree = true;
            overlays = [
              (final: prev: {
                unstable = import nixpkgs-unstable {
                  # system = pkgs.stdenv.hostPlatform.system;
                  inherit system;
                  config.allowUnfree = true;
                };
                # homarr = homarr;
                # homarr = import homarr {
                #   inherit system;
                # };
              })
              # (final: prev: {
              #   homarr = import homarr {
              #     inherit system;
              #   };
              # })
            ];
          };
          # homarr = import ../../derivations/homarr/package.nix {
          #   unstable = pkgs.unstable;
          #   pkgs = pkgs;
          #   fetchFromGitHub = pkgs.fetchFromGitHub;
          #   nodePackages = pkgs.nodePackages;
          #   makeWrapper = pkgs.makeWrapper;
          #   nodejs = pkgs.nodejs_24;
          #   pnpm = pkgs.unstable.pnpm.override {nodejs = pkgs.nodejs_24;};
          #   fetchPnpmDeps = pkgs.fetchPnpmDeps;
          #   pnpmConfigHook = pkgs.pnpmConfigHook;
          #   python3 = pkgs.python3;
          #   stdenv = pkgs.stdenv;
          #   unixtools = pkgs.unixtools;
          #   cctools = pkgs.cctools;
          #   lib = pkgs.lib;
          #   nixosTests = pkgs.nixosTests;
          #   gnused = pkgs.gnused;
          # };
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
            # ./systemd-services.nix
            ./users.nix
            homarr-flake.nixosModules.default
          ];
          environment.systemPackages = [
            # pkgs.homarr
            # homarr
            # homarr-pkgs.homarr
            # homarr-package
          ];

          services.homarr = {
            enable = true;
            openFirewall = true;
            port = 7575;
            host = "0.0.0.0";
            environmentFile = "/etc/homarr/homarr.env";
          };

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
              # script = "${homarr-flake.packages.homarr}/bin/install.sh";
            };
          };
          systemd.tmpfiles.rules = [
            "d /etc/homarr 0755 homarr services"
            "f /etc/homarr/homarr.env 0755 homarr services"
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
