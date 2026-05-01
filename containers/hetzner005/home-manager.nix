{
  config,
  pkgs,
  lib,
  ...
}: let
  # vars = import ./hetzner005/vars.nix;
  # home-manager = {
  #   url = "github:nix-community/home-manager/release-25.11";
  #   # The `follows` keyword in inputs is used for inheritance.
  #   # Here, `inputs.nixpkgs` of home-manager is kept consistent with
  #   # the `inputs.nixpkgs` of the current flake,
  #   # to avoid problems caused by different versions of nixpkgs.
  #   inputs.nixpkgs.follows = "nixpkgs";
  # };
  home-manager = builtins.fetchTarball {
    url = "https://github.com/nix-community/home-manager/archive/release-25.11.tar.gz";
    sha256 = "sha256:16mcnqpcgl3s2frq9if6vb8rpnfkmfxkz5kkkjwlf769wsqqg3i9";
  };

  vars = import ./vars.nix;
in {
  imports = [
    (import "${home-manager}/nixos")
  ];
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.mannchri = import ./home-manager/mannchri.nix;
  home-manager.users.fossil = import ./home-manager/fossil.nix;
  home-manager.users.filebrowser = import ./home-manager/filebrowser.nix;
  home-manager.users.guichet = import ./home-manager/guichet.nix;
}
