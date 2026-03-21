{
  inputs.nixpkgs.url = "nixpkgs/nixos-unstable";
  # inputs.nixpkgs.url = "nixpkgs/nixos-25.11";

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
            pkgs.nodejs_24
            (pkgs.pnpm_9.override {nodejs = pkgs.nodejs_24;})
            pkgs.pnpmConfigHook
            # homarr
          ];

          system.stateVersion = "25.11";
        })
      ];
    };
  };
}
