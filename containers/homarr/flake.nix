{
  inputs.nixpkgs.url = "nixpkgs/nixos-unstable";

  outputs = {
    self,
    nixpkgs,
  }: let
    # vars = import ../../vars.nix;
  in {
    nixosConfigurations.container = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ({pkgs, ...}: let
          vars = import ../../vars.nix;
        in {
          boot.isContainer = true;

          privateNetwork = false;

          # networking.firewall.allowedTCPPorts = [80 443];

          users.users.homarr = {
            isNormalUser = true;
            uid = vars.uid.homarr;
            group = "users";
            extraGroups = ["caddy"];
          };
          users.groups.users.gid = vars.gid.users;
          users.groups.caddy.gid = vars.gid.caddy;
          nix.settings.experimental-features = ["nix-command flakes"];
          imports = [
            ../../modules/packages/vim.nix
            ../../modules/packages/common.nix
            # (import ../overlays.nix {inputs = {nixpkgs-unstable = pkgs.unstable;};})
          ];
          environment.systemPackages = [
            # homarr
            pkgs.nodejs_25
            (pkgs.pnpm_10.override {nodejs = pkgs.nodejs_25;})
            pkgs.pnpmConfigHook
            # homarr
          ];

          services = {
            redis.servers.homarr.enable = true;
            postgresql = {
              enable = true;
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
          };

          system.stateVersion = "25.11";
        })
      ];
    };
  };
}
