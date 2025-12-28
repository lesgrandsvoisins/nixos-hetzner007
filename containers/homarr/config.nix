{
  pkgs,
  lib,
  ...
}: let
  # unstable = import <nixpkgs-unstable>;
in {
  nix.settings.experimental-features = ["nix-command flakes"];
  imports = [
    ../modules/packages/vim.nix
    ../modules/packages/common.nix
    ./services.nix
    ./systemd-services.nix
    ./users.nix
  ];
  environment.systemPackages = [
    unstable.nodejs_25
    (unstable.pnpm_10.override {nodejs = unstable.nodejs_25;})
    unstable.pnpmConfigHook
  ];

  system.stateVersion = "25.11";
}
