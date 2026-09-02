# home.nix
{
  pkgs,
  lib,
  config,
  vars,
  ...
}: let
in {
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    # nix.settings.experimental-features = ["nix-command" "flakes"];

    # users.homarr = {
    #   home.stateVersion = "26.05";
    #   # User-specific packages.
    #   home.packages = with pkgs; [
    #     unstable.nodejs_25
    #     (unstable.pnpm_10.override {nodejs = unstable.nodejs_25;})
    #     unstable.pnpmConfigHook
    #     # unstable.fetchPnpmDeps
    #   ];
    # };
  };
}
