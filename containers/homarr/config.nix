{
  config,
  pkgs,
  lib,
  ...
}: let
  # unstable = import <nixpkgs-unstable>;
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
    # (import ../overlays.nix {inputs = {nixpkgs-unstable = pkgs.unstable;};})
  ];
  environment.systemPackages = [
    # homarr
    unstable.nodejs_25
    (unstable.pnpm_10.override {nodejs = unstable.nodejs_25;})
    unstable.pnpmConfigHook
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
}
