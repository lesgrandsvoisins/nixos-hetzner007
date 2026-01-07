# home.nix
{pkgs, ...}: {
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    # nix.settings.experimental-features = ["nix-command" "flakes"];

    # users.homarr = {
    #   home.stateVersion = "25.11";
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
