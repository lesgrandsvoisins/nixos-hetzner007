{
  pkgs,
  lib,
  config,
  # vars,
  ...
}: let
  vars = import ../../vars.nix;
  # unstable = import <nixpkgs-unstable>;
in {
  networking.hostName = "homarr";
  nix.settings.experimental-features = ["nix-command flakes"];
  imports = [
    ../modules/packages/vim.nix
    ../modules/packages/common.nix
    ./services.nix
    ./systemd-services.nix
    ./users.nix
  ];

  # # https://discourse.nixos.org/t/machine-shell-connection-to-the-local-host-terminated/75816/3
  # # Temporary Workaround
  # security.pam.services.login.updateWtmp = lib.mkForce false;

  environment.systemPackages = [
    unstable.nodejs_25
    (unstable.pnpm_10.override {nodejs = unstable.nodejs_25;})
    unstable.pnpmConfigHook
  ];

  system.stateVersion = "25.11";
}
