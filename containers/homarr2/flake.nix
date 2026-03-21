{
  inputs.nixpkgs.url = "nixpkgs/nixos-unstable";

  outputs = {
    self,
    nixpkgs,
  }: let
    vars = import ../../vars.nix;
    # homarr = pkgs.callPackage ../../derivations/homarr/package.nix {};
  in {
    nixosConfigurations.container = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      modules = [
        ({
          pkgs,
          lib,
          config,
          # vars,
          ...
        }: let
          # vars = import ../../vars.nix;
          # homarr = pkgs.callPackage ../../derivations/homarr/package.nix {};
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
            pkgs.nodejs_25
            (pkgs.pnpm_10.override {nodejs = pkgs.nodejs_25;})
            pkgs.pnpmConfigHook
            # homarr
          ];

          system.stateVersion = "25.11";
          console.enable = true;

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
