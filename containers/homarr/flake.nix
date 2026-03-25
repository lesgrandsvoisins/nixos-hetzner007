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
          # networking.firewall.enable = false;
          # networking.useHostResolvConf = lib.mkForce true;
          networking.firewall.allowedTCPPorts = [80 443 vars.ports.homarr 53 22];
          networking.firewall.trustedInterfaces = ["eth0" "eth0@if12"];

          services = {
            resolved = {
              enable = true;
              fallbackDns = [
                "8.8.8.8"
                "8.8.4.4"
                "1.1.1.1"
              ];
            };
          };
          # networking.firewall.allowedTCPPorts = [vars.ports.homarr];
          system.stateVersion = "25.11";
        })
      ];
    };
  };
}
