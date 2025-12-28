{
  config,
  pkgs,
  lib,
  ...
}: let
  vars = import ../vars.nix;
  # homarr = pkgs.callPackage ../derivations/homarr/package.nix {};
  # nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  # unstable = import nixpkgs-unstable {
  #   system = pkgs.stdenv.hostPlatform.system;
  #   config.allowUnfree = true; # Also allow unfree packages from unstable
  # };
in {
  containers.homarr = {
    bindMounts = {
    };
    autoStart = true;
    config = {
      config,
      pkgs,
      lib,
      ...
    }: let
    in {
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
    };
  };
}
