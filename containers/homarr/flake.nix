{
  inputs.nixpkgs.url = "nixpkgs/nixos-unstable";

  outputs = {
    self,
    nixpkgs,
  }: {
    nixosConfigurations.container = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ({pkgs, ...}: {
          boot.isContainer = true;

          networking.firewall.allowedTCPPorts = [80 443];

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
            ../modules/packages/vim.nix
            ../modules/packages/common.nix
            (import ../overlays.nix {inputs = {nixpkgs-unstable = pkgs.unstable;};})
          ];
          environment.systemPackages = [
            # homarr
            pkgs.unstable.nodejs_25
            (pkgs.unstable.pnpm_10.override {nodejs = pkgs.unstable.nodejs_25;})
            pkgs.unstable.pnpmConfigHook
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
